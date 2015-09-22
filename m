From: akpm@linux-foundation.org
Subject: + kernel-watchdog-is_hardlockup-can-be-boolean.patch added to -mm tree
Date: Tue, 22 Sep 2015 11:50:52 -0700
Message-ID: <5601a30c.ANOCjK5X5xrlrJo2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbbIVSux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 14:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, atomlin@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: is_hardlockup can be boolean
has been added to the -mm tree.  Its filename is
     kernel-watchdog-is_hardlockup-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdog-is_hardlockup-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdog-is_hardlockup-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: kernel/watchdog.c: is_hardlockup can be boolean

Make is_hardlockup return bool to improve readability due to this
particular function only using either one or zero as its return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/watchdog.c~kernel-watchdog-is_hardlockup-can-be-boolean kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdog-is_hardlockup-can-be-boolean
+++ a/kernel/watchdog.c
@@ -263,15 +263,15 @@ void touch_softlockup_watchdog_sync(void
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 /* watchdog detector functions */
-static int is_hardlockup(void)
+static bool is_hardlockup(void)
 {
 	unsigned long hrint = __this_cpu_read(hrtimer_interrupts);
 
 	if (__this_cpu_read(hrtimer_interrupts_saved) == hrint)
-		return 1;
+		return true;
 
 	__this_cpu_write(hrtimer_interrupts_saved, hrint);
-	return 0;
+	return false;
 }
 #endif
 
_

Patches currently in -mm which might be from bywxiaobai@163.com are

kernel-watchdog-is_hardlockup-can-be-boolean.patch
mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch
mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch

