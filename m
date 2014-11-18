From: akpm@linux-foundation.org
Subject: + exit-reparent-cleanup-the-changing-of-parent-fix.patch added to -mm tree
Date: Tue, 18 Nov 2014 13:23:42 -0800
Message-ID: <546bb8de.U/VE771U8yBLAbGX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110AbaKRVXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Nov 2014 16:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: silence a bogus static checker warning
has been added to the -mm tree.  Its filename is
     exit-reparent-cleanup-the-changing-of-parent-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-reparent-cleanup-the-changing-of-parent-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/exit-reparent-cleanup-the-changing-of-parent-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: exit: silence a bogus static checker warning

Smatch complains about this:

	kernel/exit.c:543 forget_original_parent()
	warn: add some parenthesis here?

I don't normally advocate changing the code to make the static checker
happy but these are normally precedence bugs so I think it's ok to put
parenthesis so it's clear the code is deliberate.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent-fix kernel/exit.c
--- a/kernel/exit.c~exit-reparent-cleanup-the-changing-of-parent-fix
+++ a/kernel/exit.c
@@ -571,7 +571,7 @@ static void forget_original_parent(struc
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
-			BUG_ON(!t->ptrace != (t->parent == father));
+			BUG_ON((!t->ptrace) != (t->parent == father));
 			if (likely(!t->ptrace))
 				t->parent = t->real_parent;
 			if (t->pdeath_signal)
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

ocfs2-fix-an-off-by-one-bug_on-statement.patch
exit-reparent-cleanup-the-changing-of-parent-fix.patch
checkpatch-add-strict-pointer-comparison-to-null-test.patch
rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
decompress_bunzip2-off-by-one-in-get_next_block.patch
linux-next.patch

