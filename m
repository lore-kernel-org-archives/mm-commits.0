From: akpm@linux-foundation.org
Subject: - modpost-detect-unterminated-device-id-lists.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:04 -0700
Message-ID: <200709202115.l8KLF4uc002871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60964 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbXITVP6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:15:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@ubuntu.com, adobriyan@gmail.com, bcollins@ubuntu.com, flamingice@sourmilk.net, greg@kroah.com, jeff@garzik.org, rusty@rustcorp.com.au, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     modpost: detect unterminated device id lists
has been removed from the -mm tree.  Its filename was
     modpost-detect-unterminated-device-id-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: modpost: detect unterminated device id lists
From: Kees Cook <kees@ubuntu.com>

Cause modpost to fail if any device id lists are incorrectly terminated,
after reporting the offender.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Greg KH <greg@kroah.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ben Collins <bcollins@ubuntu.com>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/mod/file2alias.c |   38 ++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff -puN scripts/mod/file2alias.c~modpost-detect-unterminated-device-id-lists scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~modpost-detect-unterminated-device-id-lists
+++ a/scripts/mod/file2alias.c
@@ -55,10 +55,13 @@ do {                                    
  * Check that sizeof(device_id type) are consistent with size of section
  * in .o file. If in-consistent then userspace and kernel does not agree
  * on actual size which is a bug.
+ * Also verify that the final entry in the table is all zeros.
  **/
-static void device_id_size_check(const char *modname, const char *device_id,
-				 unsigned long size, unsigned long id_size)
+static void device_id_check(const char *modname, const char *device_id,
+			    unsigned long size, unsigned long id_size,
+			    void *symval)
 {
+	int i;
 	if (size % id_size || size < id_size) {
 		fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "
 		      "of the size of section __mod_%s_device_table=%lu.\n"
@@ -66,6 +69,18 @@ static void device_id_size_check(const c
 		      "in mod_devicetable.h\n",
 		      modname, device_id, id_size, device_id, size, device_id);
 	}
+	/* Verify last one is a terminator */
+	for (i = 0; i < id_size; i++ ) {
+		if ( *(uint8_t*)(symval+size-id_size+i) ) {
+			fprintf(stderr,"%s: struct %s_device_id is %lu bytes.  The last of %lu is:\n", modname, device_id, id_size, size / id_size);
+			for (i = 0; i < id_size; i++ ) {
+				fprintf(stderr,"0x%02x ", *(uint8_t*)(symval+size-id_size+i) );
+			}
+			fprintf(stderr,"\n");
+			fatal("%s: struct %s_device_id is not terminated "
+				"with a NULL entry!\n", modname, device_id);
+		}
+	}
 }
 
 /* USB is special because the bcdDevice can be matched against a numeric range */
@@ -168,7 +183,7 @@ static void do_usb_table(void *symval, u
 	unsigned int i;
 	const unsigned long id_size = sizeof(struct usb_device_id);
 
-	device_id_size_check(mod->name, "usb", size, id_size);
+	device_id_check(mod->name, "usb", size, id_size, symval);
 
 	/* Leave last one: it's the terminator. */
 	size -= id_size;
@@ -529,7 +544,7 @@ static void do_table(void *symval, unsig
 	char alias[500];
 	int (*do_entry)(const char *, void *entry, char *alias) = function;
 
-	device_id_size_check(mod->name, device_id, size, id_size);
+	device_id_check(mod->name, device_id, size, id_size, symval);
 	/* Leave last one: it's the terminator. */
 	size -= id_size;
 
@@ -551,14 +566,22 @@ void handle_moddevtable(struct module *m
 			Elf_Sym *sym, const char *symname)
 {
 	void *symval;
+	char *zeros = NULL;
 
 	/* We're looking for a section relative symbol */
 	if (!sym->st_shndx || sym->st_shndx >= info->hdr->e_shnum)
 		return;
 
-	symval = (void *)info->hdr
-		+ info->sechdrs[sym->st_shndx].sh_offset
-		+ sym->st_value;
+	/* Handle all-NULL symbols allocated into .bss */
+	if (info->sechdrs[sym->st_shndx].sh_type & SHT_NOBITS) {
+		zeros = calloc(1, sym->st_size);
+		symval = zeros;
+	}
+	else {
+		symval = (void *)info->hdr
+			+ info->sechdrs[sym->st_shndx].sh_offset
+			+ sym->st_value;
+	}
 
 	if (sym_is(symname, "__mod_pci_device_table"))
 		do_table(symval, sym->st_size,
@@ -627,6 +650,7 @@ void handle_moddevtable(struct module *m
 		do_table(symval, sym->st_size,
 			 sizeof(struct ssb_device_id), "ssb",
 			 do_ssb_entry, mod);
+	if (zeros) free(zeros);
 }
 
 /* Now add out buffered information to the generated C source */
_

Patches currently in -mm which might be from kees@ubuntu.com are

git-kbuild.patch
