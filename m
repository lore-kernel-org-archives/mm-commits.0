From: akpm@linux-foundation.org
Subject: +
 watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch added to -mm tree
Date: Mon, 19 Jun 2017 11:57:28 -0700
Message-ID: <59481e98.mmksNXbnnhoN8tyw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49470 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdFSS5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2017 14:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@gmail.com, babu.moger@oracle.com, benh@kernel.crashing.org, dzickus@redhat.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix
has been added to the -mm tree.  Its filename is
     watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix

add code comments

Link: http://lkml.kernel.org/r/20170617125933.774d3858@roar.ozlabs.ibm.com
Cc: Don Zickus <dzickus@redhat.com>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix
+++ a/kernel/watchdog.c
@@ -114,6 +114,10 @@ int __read_mostly watchdog_suspended;
 /*
  * These functions can be overridden if an architecture implements its
  * own hardlockup detector.
+ *
+ * watchdog_nmi_enable/disable can be implemented to start and stop when
+ * softlockup watchdog threads start and stop. The arch must select the
+ * SOFTLOCKUP_DETECTOR Kconfig.
  */
 int __weak watchdog_nmi_enable(unsigned int cpu)
 {
@@ -123,6 +127,17 @@ void __weak watchdog_nmi_disable(unsigne
 {
 }
 
+/*
+ * watchdog_nmi_reconfigure can be implemented to be notified after any
+ * watchdog configuration change. The arch hardlockup watchdog should
+ * respond to the following variables:
+ * - nmi_watchdog_enabled
+ * - watchdog_thresh
+ * - watchdog_cpumask
+ * - sysctl_hardlockup_all_cpu_backtrace
+ * - hardlockup_panic
+ * - watchdog_suspended
+ */
 void __weak watchdog_nmi_reconfigure(void)
 {
 }
_

Patches currently in -mm which might be from npiggin@gmail.com are

watchdog-remove-unused-declaration.patch
watchdog-introduce-arch_touch_nmi_watchdog.patch
watchdog-split-up-config-options.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs.patch
watchdog-provide-watchdog_reconfigure-for-arch-watchdogs-fix.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog.patch

