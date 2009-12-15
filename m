From: akpm@linux-foundation.org
Subject: [merged] kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:48 -0800
Message-ID: <200912152155.nBFLtmER015513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933791AbZLOV4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     kallsyms: remove deprecated print_fn_descriptor_symbol()
has been removed from the -mm tree.  Its filename was
     kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kallsyms: remove deprecated print_fn_descriptor_symbol()
From: Amerigo Wang <amwang@redhat.com>

According to feature-removal-schedule.txt, it is the time to remove
print_fn_descriptor_symbol().

And a quick grep shows that it no longer has any callers.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    9 ---------
 include/linux/kallsyms.h                   |   12 ------------
 2 files changed, 21 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~kallsyms-remove-deprecated-print_fn_descriptor_symbol Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~kallsyms-remove-deprecated-print_fn_descriptor_symbol
+++ a/Documentation/feature-removal-schedule.txt
@@ -298,15 +298,6 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
 ---------------------------
 
-What: print_fn_descriptor_symbol()
-When: October 2009
-Why:  The %pF vsprintf format provides the same functionality in a
-      simpler way.  print_fn_descriptor_symbol() is deprecated but
-      still present to give out-of-tree modules time to change.
-Who:  Bjorn Helgaas <bjorn.helgaas@hp.com>
-
----------------------------
-
 What:	/sys/o2cb symlink
 When:	January 2010
 Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
diff -puN include/linux/kallsyms.h~kallsyms-remove-deprecated-print_fn_descriptor_symbol include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~kallsyms-remove-deprecated-print_fn_descriptor_symbol
+++ a/include/linux/kallsyms.h
@@ -107,18 +107,6 @@ static inline void print_symbol(const ch
 		       __builtin_extract_return_addr((void *)addr));
 }
 
-/*
- * Pretty-print a function pointer.  This function is deprecated.
- * Please use the "%pF" vsprintf format instead.
- */
-static inline void __deprecated print_fn_descriptor_symbol(const char *fmt, void *addr)
-{
-#if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
-	addr = *(void **)addr;
-#endif
-	print_symbol(fmt, (unsigned long)addr);
-}
