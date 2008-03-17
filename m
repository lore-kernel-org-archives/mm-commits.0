From: akpm@linux-foundation.org
Subject: + fix-verify_export_symbols.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:52:26 -0700
Message-ID: <200803172152.m2HLqQBt032734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754864AbYCQVwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com, rusty@rustcorp.com.au


The patch titled
     modules: fix verify_export_symbols()
has been added to the -mm tree.  Its filename is
     fix-verify_export_symbols.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: fix verify_export_symbols()
From: "Jan Beulich" <jbeulich@novell.com>

When the newer export flavors were added, it was apparently forgotten to add
respective code here.

In order to not double the (source) size of the function, add some abstraction
to reduce code duplication.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff -puN kernel/module.c~fix-verify_export_symbols kernel/module.c
--- a/kernel/module.c~fix-verify_export_symbols
+++ a/kernel/module.c
@@ -1394,33 +1394,32 @@ EXPORT_SYMBOL_GPL(__symbol_get);
  */
 static int verify_export_symbols(struct module *mod)
 {
-	const char *name = NULL;
-	unsigned long i, ret = 0;
+	const char *name;
+	unsigned int i;
 	struct module *owner;
 	const unsigned long *crc;
 
-	for (i = 0; i < mod->num_syms; i++)
-		if (!IS_ERR_VALUE(__find_symbol(mod->syms[i].name,
-							&owner, &crc, 1))) {
-			name = mod->syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
+#define VERIFY(syms) \
+	for (i = 0; i < mod->num_##syms; i++) { \
+		name = mod->syms[i].name; \
+		if (!IS_ERR_VALUE(__find_symbol(name, &owner, &crc, 1))) \
+			goto dup; \
+	}
 
-	for (i = 0; i < mod->num_gpl_syms; i++)
-		if (!IS_ERR_VALUE(__find_symbol(mod->gpl_syms[i].name,
-							&owner, &crc, 1))) {
-			name = mod->gpl_syms[i].name;
-			ret = -ENOEXEC;
-			goto dup;
-		}
+	VERIFY(syms);
+	VERIFY(gpl_syms);
+	VERIFY(gpl_future_syms);
+	VERIFY(unused_syms);
+	VERIFY(unused_gpl_syms);
+#undef VERIFY
+
+	return 0;
 
 dup:
-	if (ret)
-		printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
-			mod->name, name, module_name(owner));
+	printk(KERN_ERR "%s: exports duplicate symbol %s (owned by %s)\n",
+		mod->name, name, module_name(owner));
 
-	return ret;
+	return -ENOEXEC;
 }
 
 /* Change all symbols so that st_value encodes the pointer directly. */
_

Patches currently in -mm which might be from jbeulich@novell.com are

lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
lib-swiotlbc-cleanups.patch
reduce-module-image-and-resident-size.patch
make-module_sect_attrs-private-to-kernel-modulec.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
fix-verify_export_symbols.patch

