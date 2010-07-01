From: akpm@linux-foundation.org
Subject: + lib-bugc-make-warn-implementation-match-the-kernel-panicc-one.patch added to -mm tree
Date: Thu, 01 Jul 2010 14:12:23 -0700
Message-ID: <201007012112.o61LCNw9027740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758882Ab0GAVNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 17:13:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, arjan@infradead.org, kirill@shutemov.name, mingo@elte.hu


The patch titled
     lib/bug.c: make WARN implementation match the kernel/panic.c one
has been added to the -mm tree.  Its filename is
     lib-bugc-make-warn-implementation-match-the-kernel-panicc-one.patch

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
Subject: lib/bug.c: make WARN implementation match the kernel/panic.c one
From: Anton Blanchard <anton@samba.org>

There are a few issues with the exception based WARN implementation in
lib/bug.c:

- Inconsistent printk flags. The "cut here" line is printed at KERN_EMERG, so
  the console and all logged in users see the single line:

------------[ cut here ]------------

  for each WARN. Fix this so we print everything at KERN_WARNING to match the
  kernel/panic.c version.

- The lib/bug.c WARN would print "Badness at". Change it to match the
  kernel/panic.c version which prints "WARNING: at".

- Print the list of modules, similar to kernel/panic.c of modules, similar to
  kernel/panic.c

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bug.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN lib/bug.c~lib-bugc-make-warn-implementation-match-the-kernel-panicc-one lib/bug.c
--- a/lib/bug.c~lib-bugc-make-warn-implementation-match-the-kernel-panicc-one
+++ a/lib/bug.c
@@ -136,8 +136,6 @@ enum bug_trap_type report_bug(unsigned l
 
 	bug = find_bug(bugaddr);
 
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
-
 	file = NULL;
 	line = 0;
 	warning = 0;
@@ -156,19 +154,24 @@ enum bug_trap_type report_bug(unsigned l
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
+		printk(KERN_WARNING "------------[ cut here ]------------\n");
+
 		if (file)
-			printk(KERN_ERR "Badness at %s:%u\n",
+			printk(KERN_WARNING "WARNING: at %s:%u\n",
 			       file, line);
 		else
-			printk(KERN_ERR "Badness at %p "
+			printk(KERN_WARNING "WARNING: at %p "
 			       "[verbose debug info unavailable]\n",
 			       (void *)bugaddr);
 
+        	print_modules();
 		show_regs(regs);
 		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
 
+	printk(KERN_EMERG "------------[ cut here ]------------\n");
+
 	if (file)
 		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
 		       file, line);
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one.patch
add-oops-end-marker-to-lib-bugc-warn-implementation.patch

