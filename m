From: akpm@linux-foundation.org
Subject: + watchdog-fix-print-once-on-enable.patch added to -mm tree
Date: Wed, 13 Aug 2014 15:28:47 -0700
Message-ID: <53ebe69f.07IJm0Aaox06J1Ss%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:38230 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaHMW2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 18:28:48 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so109295oig.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 15:28:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, drjones@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: fix print-once on enable
has been added to the -mm tree.  Its filename is
     watchdog-fix-print-once-on-enable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-fix-print-once-on-enable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-fix-print-once-on-enable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: fix print-once on enable

This patch avoids printing the message 'enabled on all CPUs, ...' multiple
times.  For example, the issue can occur in the following scenario:

1) watchdog_nmi_enable() fails to enable PMU counters and sets
   cpu0_err.

2) 'echo [0|1] > /proc/sys/kernel/nmi_watchdog' is executed to
   disable and re-enable the watchdog mechanism 'on the fly'.

3) If watchdog_nmi_enable() succeeds to enable PMU counters, each
   CPU will print the message because step1 left behind a non-zero
   cpu0_err.

   if (!IS_ERR(event)) {
       if (cpu == 0 || cpu0_err)
       pr_info("enabled on all CPUs, ...")

The patch avoids this by clearing cpu0_err in watchdog_nmi_disable().

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/watchdog.c~watchdog-fix-print-once-on-enable kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-print-once-on-enable
+++ a/kernel/watchdog.c
@@ -525,6 +525,9 @@ static void watchdog_nmi_disable(unsigne
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
 	}
+	if (cpu == 0)
+		/* watchdog_nmi_enable() expects this to be zero initially. */
+		cpu0_err = 0;
 	return;
 }
 #else
_

Patches currently in -mm which might be from uobergfe@redhat.com are

watchdog-fix-print-once-on-enable.patch
watchdog-control-hard-lockup-detection-default.patch
kvm-ensure-hard-lockup-detection-is-disabled-by-default.patch

