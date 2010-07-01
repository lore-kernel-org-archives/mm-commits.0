From: akpm@linux-foundation.org
Subject: + add-oops-end-marker-to-lib-bugc-warn-implementation.patch added to -mm tree
Date: Thu, 01 Jul 2010 14:12:55 -0700
Message-ID: <201007012112.o61LCtAZ027852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758737Ab0GAVNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jul 2010 17:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, arjan@infradead.org, kirill@shutemov.name, mingo@elte.hu


The patch titled
     lib/bug.c: add oops end marker to WARN implementation
has been added to the -mm tree.  Its filename is
     add-oops-end-marker-to-lib-bugc-warn-implementation.patch

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
Subject: lib/bug.c: add oops end marker to WARN implementation
From: Anton Blanchard <anton@samba.org>

We are missing the oops end marker for the exception based WARN implementation
in lib/bug.c. This is useful for logfile analysis tools.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    1 +
 kernel/panic.c         |    2 +-
 lib/bug.c              |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~add-oops-end-marker-to-lib-bugc-warn-implementation include/linux/kernel.h
--- a/include/linux/kernel.h~add-oops-end-marker-to-lib-bugc-warn-implementation
+++ a/include/linux/kernel.h
@@ -177,6 +177,7 @@ NORET_TYPE void panic(const char * fmt, 
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
 extern void oops_enter(void);
 extern void oops_exit(void);
+void print_oops_end_marker(void);
 extern int oops_may_print(void);
 NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
diff -puN kernel/panic.c~add-oops-end-marker-to-lib-bugc-warn-implementation kernel/panic.c
--- a/kernel/panic.c~add-oops-end-marker-to-lib-bugc-warn-implementation
+++ a/kernel/panic.c
@@ -338,7 +338,7 @@ static int init_oops_id(void)
 }
 late_initcall(init_oops_id);
 
-static void print_oops_end_marker(void)
+void print_oops_end_marker(void)
 {
 	init_oops_id();
 	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
diff -puN lib/bug.c~add-oops-end-marker-to-lib-bugc-warn-implementation lib/bug.c
--- a/lib/bug.c~add-oops-end-marker-to-lib-bugc-warn-implementation
+++ a/lib/bug.c
@@ -166,6 +166,7 @@ enum bug_trap_type report_bug(unsigned l
 
 		print_modules();
 		show_regs(regs);
+		print_oops_end_marker();
 		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch
panic-keep-blinking-in-spite-of-long-spin-timer-mode.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one.patch
lib-bugc-make-warn-implementation-match-the-kernel-panicc-one-checkpatch-fixes.patch
add-oops-end-marker-to-lib-bugc-warn-implementation.patch

