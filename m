From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch
 removed from -mm tree
Date: Mon, 23 Jun 2014 13:10:16 -0700
Message-ID: <53a889a8.NxWCuxFc+IZngiwA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFWUKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, atomlin@redhat.com, mq@suse.cz


The patch titled
     Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch

This patch was dropped because it was folded into kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch

------------------------------------------------------
From: Jan Moskyto Matejka <mq@suse.cz>
Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2

This commit fixes this warning:

kernel/watchdog.c: In function `watchdog_timer_fn':
kernel/watchdog.c:368:4: warning: `smp_mb__after_clear_bit' is deprecated (declared at include/linux/bitops.h:48) [-Wdeprecated-declarations]
    smp_mb__after_clear_bit();

That code was introduced in commit 90e6b763ca8a5eb739e59489f42d45e13431d157
("kernel/watchdog.c: print traces for all cpus on lockup detection") and then
merged with another branch containing commit
febdbfe8a91ce0d11939d4940b592eb0dba8d663 ("arch: Prepare for
smp_mb__{before,after}_atomic()") which deprecates the
smp_mb__after_clear_bit() call in favour of smp_mb__after_atomic().

Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2 kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2
+++ a/kernel/watchdog.c
@@ -363,7 +363,7 @@ static enum hrtimer_restart watchdog_tim
 
 			clear_bit(0, &soft_lockup_nmi_warn);
 			/* Barrier to sync with other cpus */
-			smp_mb__after_clear_bit();
+			smp_mb__after_atomic();
 		}
 
 		if (softlockup_panic)
_

Patches currently in -mm which might be from mq@suse.cz are

kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch

