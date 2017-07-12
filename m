From: akpm@linux-foundation.org
Subject: [folded-merged]
 watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch
 removed from -mm tree
Date: Wed, 12 Jul 2017 14:19:05 -0700
Message-ID: <59669249.orWn+rCctfADBed7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753447AbdGLVTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, babu.moger@oracle.com, dzickus@redhat.com, khlebnikov@yandex-team.ru, mingo@kernel.org, npiggin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog: hide unused function
has been removed from the -mm tree.  Its filename was
     watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix-2.patch

This patch was dropped because it was folded into watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch

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
Acked-by: Don Zickus <dzickus@redhat.com>
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

watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix.patch

