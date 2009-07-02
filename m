From: akpm@linux-foundation.org
Subject: + flat-use-is_err_value-helper-macro.patch added to -mm tree
Date: Wed, 01 Jul 2009 23:36:23 -0700
Message-ID: <200907020636.n626aNtL028844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848AbZGBGgw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 02:36:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, david_mccullough@securecomputing.com, dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org


The patch titled
     flat: use IS_ERR_VALUE() helper macro
has been added to the -mm tree.  Its filename is
     flat-use-is_err_value-helper-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flat: use IS_ERR_VALUE() helper macro
From: Mike Frysinger <vapier@gentoo.org>

There is a common macro now for testing mixed pointer/errno values, so use
that rather than handling the casts ourself.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: David McCullough <david_mccullough@securecomputing.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN fs/binfmt_flat.c~flat-use-is_err_value-helper-macro fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-use-is_err_value-helper-macro
+++ a/fs/binfmt_flat.c
@@ -278,8 +278,6 @@ static int decompress_exec(
 		ret = bprm->file->f_op->read(bprm->file, buf, LBUFSIZE, &fpos);
 		if (ret <= 0)
 			break;
-		if (ret >= (unsigned long) -4096)
-			break;
 		len -= ret;
 
 		strm.next_in = buf;
@@ -335,7 +333,7 @@ calc_reloc(unsigned long r, struct lib_i
 					"(%d != %d)", (unsigned) r, curid, id);
 			goto failed;
 		} else if ( ! p->lib_list[id].loaded &&
-				load_flat_shared_library(id, p) > (unsigned long) -4096) {
+				IS_ERR_VALUE(load_flat_shared_library(id, p))) {
 			printk("BINFMT_FLAT: failed to load library %d", id);
 			goto failed;
 		}
@@ -545,7 +543,7 @@ static int load_flat_file(struct linux_b
 		textpos = do_mmap(bprm->file, 0, text_len, PROT_READ|PROT_EXEC,
 				  MAP_PRIVATE|MAP_EXECUTABLE, 0);
 		up_write(&current->mm->mmap_sem);
-		if (!textpos  || textpos >= (unsigned long) -4096) {
+		if (!textpos || IS_ERR_VALUE(textpos)) {
 			if (!textpos)
 				textpos = (unsigned long) -ENOMEM;
 			printk("Unable to mmap process text, errno %d\n", (int)-textpos);
@@ -560,7 +558,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 
-		if (realdatastart == 0 || realdatastart >= (unsigned long)-4096) {
+		if (realdatastart == 0 || IS_ERR_VALUE(realdatastart)) {
 			if (!realdatastart)
 				realdatastart = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process data, errno %d\n",
@@ -587,7 +585,7 @@ static int load_flat_file(struct linux_b
 			result = bprm->file->f_op->read(bprm->file, (char *) datapos,
 					data_len + (relocs * sizeof(unsigned long)), &fpos);
 		}
-		if (result >= (unsigned long)-4096) {
+		if (IS_ERR_VALUE(result)) {
 			printk("Unable to read data+bss, errno %d\n", (int)-result);
 			do_munmap(current->mm, textpos, text_len);
 			do_munmap(current->mm, realdatastart, data_len + extra);
@@ -607,7 +605,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
 		up_write(&current->mm->mmap_sem);
 
-		if (!textpos  || textpos >= (unsigned long) -4096) {
+		if (!textpos || IS_ERR_VALUE(textpos)) {
 			if (!textpos)
 				textpos = (unsigned long) -ENOMEM;
 			printk("Unable to allocate RAM for process text/data, errno %d\n",
@@ -641,7 +639,7 @@ static int load_flat_file(struct linux_b
 			fpos = 0;
 			result = bprm->file->f_op->read(bprm->file,
 					(char *) textpos, text_len, &fpos);
-			if (result < (unsigned long) -4096)
+			if (!IS_ERR_VALUE(result))
 				result = decompress_exec(bprm, text_len, (char *) datapos,
 						 data_len + (relocs * sizeof(unsigned long)), 0);
 		}
@@ -651,13 +649,13 @@ static int load_flat_file(struct linux_b
 			fpos = 0;
 			result = bprm->file->f_op->read(bprm->file,
 					(char *) textpos, text_len, &fpos);
-			if (result < (unsigned long) -4096) {
+			if (!IS_ERR_VALUE(result)) {
 				fpos = ntohl(hdr->data_start);
 				result = bprm->file->f_op->read(bprm->file, (char *) datapos,
 					data_len + (relocs * sizeof(unsigned long)), &fpos);
 			}
 		}
-		if (result >= (unsigned long)-4096) {
+		if (IS_ERR_VALUE(result)) {
 			printk("Unable to read code+data+bss, errno %d\n",(int)-result);
 			do_munmap(current->mm, textpos, text_len + data_len + extra +
 				MAX_SHARED_LIBS * sizeof(unsigned long));
@@ -835,7 +833,7 @@ static int load_flat_shared_library(int 
 
 	res = prepare_binprm(&bprm);
 
-	if (res <= (unsigned long)-4096)
+	if (!IS_ERR_VALUE(res))
 		res = load_flat_file(&bprm, libs, id, NULL);
 
 	abort_creds(bprm.cred);
@@ -880,7 +878,7 @@ static int load_flat_binary(struct linux
 	stack_len += FLAT_DATA_ALIGN - 1;  /* reserve for upcoming alignment */
 	
 	res = load_flat_file(bprm, &libinfo, 0, &stack_len);
-	if (res > (unsigned long)-4096)
+	if (IS_ERR_VALUE(res))
 		return res;
 	
 	/* Update data segment pointers for all libraries */
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
drivers-serial-bfin_sport_uartc-remove-wrong-and-unneeded-memset.patch
flat-fix-uninitialized-ptr-with-shared-libs.patch
serial-bfin_5xx-fix-building-as-module-when-early-printk-is-enabled.patch
kernel-printkc-handle-more-than-one-con_boot.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch
rtc-update-documentation-wrt-rtc_pie-irq_set_state.patch
rtc-bfin-do-not-share-rtc-irq.patch
flat-use-is_err_value-helper-macro.patch

