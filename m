From: akpm@linux-foundation.org
Subject: + kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:32:09 -0700
Message-ID: <200910151932.n9FJW9Dw029083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933351AbZJOTd3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:33:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, bjorn.helgaas@hp.com


The patch titled
     kallsyms: remove deprecated print_fn_descriptor_symbol()
has been added to the -mm tree.  Its filename is
     kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch

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
Subject: kallsyms: remove deprecated print_fn_descriptor_symbol()
From: Amerigo Wang <amwang@redhat.com>

According to feature-removal-schedule.txt, it is the time to remove
print_fn_descriptor_symbol().

And a quick grep shows that it no longer has any callers.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/feature-removal-schedule.txt~kallsyms-remove-deprecated-print_fn_descriptor_symbol Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~kallsyms-remove-deprecated-print_fn_descriptor_symbol
+++ a/Documentation/feature-removal-schedule.txt
@@ -283,15 +283,6 @@ Who:	Glauber Costa <gcosta@redhat.com>
 
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
