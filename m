From: akpm@osdl.org
Subject: - modpost-whitelist-reference-to-more-symbols-pattern-3.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:40 -0800
Message-ID: <200701102303.l0AN3ePl010843@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262AbXAJXDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, ak@suse.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     Modpost whitelist reference to more symbols (pattern 3)
has been removed from the -mm tree.  Its filename was
     modpost-whitelist-reference-to-more-symbols-pattern-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Modpost whitelist reference to more symbols (pattern 3)
From: Vivek Goyal <vgoyal@in.ibm.com>

o MODPOST generates warning on i386 if kernel is compiled with
  CONFIG_RELOCATABLE=y.

WARNING: vmlinux - Section mismatch: reference to .init.text:__init_begin from .text between 'free_initmem' (at offset 0xc0114fd3) and 'do_test_wp_bit'
WARNING: vmlinux - Section mismatch: reference to .init.text:_sinittext from .text between 'core_kernel_text' (at offset 0xc012aeae) and 'kernel_text_address'
WARNING: vmlinux - Section mismatch: reference to .init.text:_einittext from .text between 'core_kernel_text' (at offset 0xc012aeb7) and 'kernel_text_address'
WARNING: vmlinux - Section mismatch: reference to .init.text:_sinittext from .text between 'get_symbol_pos' (at offset 0xc0135776) and 'reset_iter'
WARNING: vmlinux - Section mismatch: reference to .init.text:_einittext from .text between 'get_symbol_pos' (at offset 0xc013577d) and 'reset_iter'

o These symbols (__init_begin, _sinittext, _einittext) belong to init
  section and generally represent a section boundary. These are special
  symbols in the sense that their size is zero and no memory is allocated
  for them in init section. Their addr and value are same. So even if
  we free the init section, it is ok to reference them.

o Whitelist access to such select symbols in MODPOST.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 scripts/mod/modpost.c |   26 ++++++++++++++++++++++++--
 1 files changed, 24 insertions(+), 2 deletions(-)

diff -puN scripts/mod/modpost.c~modpost-whitelist-reference-to-more-symbols-pattern-3 scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~modpost-whitelist-reference-to-more-symbols-pattern-3
+++ a/scripts/mod/modpost.c
@@ -582,9 +582,19 @@ static int strrcmp(const char *s, const 
  *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
  *   atsym = *driver, *_template, *_sht, *_ops, *_probe, *probe_one
+ *
+ * Pattern 3:
+ *   Some symbols belong to init section but still it is ok to reference
+ *   these from non-init sections as these symbols don't have any memory
+ *   allocated for them and symbol address and value are same. So even
+ *   if init section is freed, its ok to reference those symbols.
+ *   For ex. symbols marking the init section boundaries.
+ *   This pattern is identified by
+ *   refsymname = __init_begin, _sinittext, _einittext
  **/
 static int secref_whitelist(const char *modname, const char *tosec,
-			    const char *fromsec, const char *atsym)
+			    const char *fromsec, const char *atsym,
+			    const char *refsymname)
 {
 	int f1 = 1, f2 = 1;
 	const char **s;
@@ -599,6 +609,13 @@ static int secref_whitelist(const char *
 		NULL
 	};
 
+	const char *pat3refsym[] = {
+		"__init_begin",
+		"_sinittext",
+		"_einittext",
+		NULL
+	};
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
@@ -637,6 +654,11 @@ static int secref_whitelist(const char *
 			((strcmp(tosec, ".init.data") == 0) ||
 			(strcmp(tosec, ".init.text") == 0)))
 		return 1;
+
+		/* Check for pattern 3 */
+		for (s = pat3refsym; *s; s++)
+			if (strcmp(refsymname, *s) == 0)
+				return 1;
 	}
 	return 0;
 }
@@ -746,7 +768,7 @@ static void warn_sec_mismatch(const char
 	/* check whitelist - we may ignore it */
 	if (before &&
 	    secref_whitelist(modname, secname, fromsec,
-			     elf->strtab + before->st_name))
+			     elf->strtab + before->st_name, refsymname))
 		return;
 
 	if (before && after) {
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
