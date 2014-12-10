From: akpm@linux-foundation.org
Subject: [folded-merged]
 exit-reparent-cleanup-the-changing-of-parent-fix.patch removed from -mm
 tree
Date: Wed, 10 Dec 2014 15:19:50 -0800
Message-ID: <5488d516.GDP/18d8QIX5Lego%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbaLJXTv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:19:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: silence a bogus static checker warning
has been removed from the -mm tree.  Its filename was
     exit-reparent-cleanup-the-changing-of-parent-fix.patch

This patch was dropped because it was folded into exit-reparent-cleanup-the-changing-of-parent.patch

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

origin.patch
sh-off-by-one-bug_on-in-setup_bootmem_node.patch
ocfs2-fix-an-off-by-one-bug_on-statement.patch
ocfs2-remove-bogus-null-check-in-ocfs2_move_extents.patch
ocfs2-remove-unneeded-null-check.patch
exit-reparent-cleanup-the-changing-of-parent.patch
checkpatch-add-strict-pointer-comparison-to-null-test.patch
checkpatch-add-ability-to-fix-coalesce-string-fragments-on-multiple-lines.patch
rtc-pcf8563-remove-leftover-code.patch
rtc-pcf8563-fix-write-of-invalid-bits-to-st2-reg.patch
rtc-pcf8563-fix-wrong-time-from-read_alarm.patch
rtc-pcf8563-handle-consequeces-of-lacking-second-alarm-reg.patch
rtc-pcf8563-save-battery-power.patch
rtc-pcf8563-clear-expired-alarm-at-boot-time.patch
rtc-ds1374-add-watchdog-support.patch
rtc-ds1374-add-watchdog-support-fix.patch

