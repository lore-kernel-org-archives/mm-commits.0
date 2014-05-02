From: akpm@linux-foundation.org
Subject: +
 kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch
 added to -mm tree
Date: Fri, 02 May 2014 15:34:28 -0700
Message-ID: <53641d74.vQeSE3Ibwoy0Tnhl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaEBWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2014 18:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, atomlin@redhat.com, mq@suse.cz

Subject: + kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch added to -mm tree
To: mq@suse.cz,atomlin@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 02 May 2014 15:34:28 -0700


The patch titled
     Subject: kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix-2.patch

