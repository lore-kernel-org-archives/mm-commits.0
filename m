From: akpm@linux-foundation.org
Subject: + futex_compat-fix-list-traversal-bugs.patch added to -mm tree
Date: Tue, 11 Sep 2007 00:48:29 -0700
Message-ID: <200709110748.l8B7mTJZ032455@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758832AbXIKHtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 03:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, davem@davemloft.net, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     futex_compat: fix list traversal bugs
has been added to the -mm tree.  Its filename is
     futex_compat-fix-list-traversal-bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: futex_compat: fix list traversal bugs
From: Arnd Bergmann <arnd@arndb.de>

The futex list traversal on the compat side appears to have
a bug.

It's loop termination condition compares:

        while (compat_ptr(uentry) != &head->list)

But that can't be right because "uentry" has the special
"pi" indicator bit still potentially set at bit 0.  This
is cleared by fetch_robust_entry() into the "entry"
return value.

What this seems to mean is that the list won't terminate
when list iteration gets back to the the head.  And we'll
also process the list head like a normal entry, which could
cause all kinds of problems.

So we should check for equality with "entry".  That pointer
is of the non-compat type so we have to do a little casting
to keep the compiler and sparse happy.

The same problem can in theory occur with the 'pending'
variable, although that has not been reported from users
so far.

Based on the original patch from David Miller.

Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex_compat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/futex_compat.c~futex_compat-fix-list-traversal-bugs kernel/futex_compat.c
--- a/kernel/futex_compat.c~futex_compat-fix-list-traversal-bugs
+++ a/kernel/futex_compat.c
@@ -61,10 +61,10 @@ void compat_exit_robust_list(struct task
 	if (fetch_robust_entry(&upending, &pending,
 			       &head->list_op_pending, &pip))
 		return;
-	if (upending)
+	if (pending)
 		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
 
-	while (compat_ptr(uentry) != &head->list) {
+	while (entry != (struct robust_list __user *) &head->list) {
 		/*
 		 * A pending lock might already be on the list, so
 		 * dont process it twice:
_

Patches currently in -mm which might be from arnd@arndb.de are

futex_compat-fix-list-traversal-bugs.patch
futex_compat-simplify-pointer-magic.patch
futex_compat-update-to-match-native-version.patch
whitespace-fixes-compat-syscalls.patch
