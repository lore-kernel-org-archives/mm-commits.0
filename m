From: akpm@linux-foundation.org
Subject: [folded-merged] panic-add-taint_softlockup-fix.patch removed from -mm tree
Date: Fri, 08 Aug 2014 13:59:36 -0700
Message-ID: <53e53a38.vZhdXOVYWHGZy9Y6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:59616 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065AbaHHU7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:59:37 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1558507pab.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:59:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbaron@akamai.com, johunt@akamai.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: panic-add-taint_softlockup-fix
has been removed from the -mm tree.  Its filename was
     panic-add-taint_softlockup-fix.patch

This patch was dropped because it was folded into panic-add-taint_softlockup.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-add-taint_softlockup-fix

apply the tain before calling panic()

Cc: Jason Baron <jbaron@akamai.com>
Cc: Josh Hunt <johunt@akamai.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~panic-add-taint_softlockup-fix kernel/watchdog.c
--- a/kernel/watchdog.c~panic-add-taint_softlockup-fix
+++ a/kernel/watchdog.c
@@ -368,9 +368,9 @@ static enum hrtimer_restart watchdog_tim
 			smp_mb__after_atomic();
 		}
 
+		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
-		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
 		__this_cpu_write(soft_watchdog_warn, true);
 	} else
 		__this_cpu_write(soft_watchdog_warn, false);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors.patch
panic-add-taint_softlockup.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

