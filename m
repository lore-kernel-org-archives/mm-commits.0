From: akpm@linux-foundation.org
Subject: +
 watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch added
 to -mm tree
Date: Tue, 20 Jun 2017 14:01:52 -0700
Message-ID: <59498d40.1agSgReu1x3O24sk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35194 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdFTVBx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2017 17:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, babu.moger@oracle.com, dzickus@redhat.com, khlebnikov@yandex-team.ru, mingo@kernel.org, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: hide unused function
has been added to the -mm tree.  Its filename is
     watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: kernel/watchdog: hide unused function

watchdog_update_cpus() is defined unconditionally, but only used when
CONFIG_SYSCTL is defined:

kernel/watchdog.c:608:12: error: 'watchdog_update_cpus' defined but not used [-Werror=unused-function]

This adds another #ifdef around it.

Fixes: mmotm ("kernel/watchdog: provide watchdog_nmi_reconfigure() for arch watchdogs")
Link: http://lkml.kernel.org/r/20170620204854.966601-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2 kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2
+++ a/kernel/watchdog.c
@@ -620,11 +620,13 @@ static void watchdog_disable_all_cpus(vo
 	}
 }
 
+#ifdef CONFIG_SYSCTL
 static int watchdog_update_cpus(void)
 {
 	return smpboot_update_cpumask_percpu_thread(
 		    &watchdog_threads, &watchdog_cpumask);
 }
+#endif
 
 #else /* SOFTLOCKUP */
 static int watchdog_park_threads(void)
@@ -645,10 +647,12 @@ static void watchdog_disable_all_cpus(vo
 {
 }
 
+#ifdef CONFIG_SYSCTL
 static int watchdog_update_cpus(void)
 {
 	return 0;
 }
+#endif
 
 static void set_sample_period(void)
 {
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level-fix.patch
mm-hugetlb-soft-offline-dissolve-source-hugepage-after-successful-migration-fix.patch
kernelh-handle-pointers-to-arrays-better-in-container_of-fix.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch

