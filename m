From: akpm@linux-foundation.org
Subject: [merged] watchdog-fix-watchdog_nmi_enable_all.patch removed from
 -mm tree
Date: Mon, 18 May 2015 11:44:26 -0700
Message-ID: <555a330a.iFHuKJvb2HiqAA8s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbbERSo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 May 2015 14:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: uobergfe@redhat.com, dzickus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: fix watchdog_nmi_enable_all()
has been removed from the -mm tree.  Its filename was
     watchdog-fix-watchdog_nmi_enable_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ulrich Obergfell <uobergfe@redhat.com>
Subject: kernel/watchdog.c: fix watchdog_nmi_enable_all()

The 'watchdog_user_enabled' variable is only used as an 'interface' to the
/proc/sys/kernel/watchdog parameter.  The actual state of the watchdog is
tracked by bits in the 'watchdog_enabled' variable.  So,
watchdog_nmi_enable_all() should check the NMI_WATCHDOG_ENABLED bit in
'watchdog_enabled'.

This patch improves code consistency - there are no userspace-visible
changes.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/watchdog.c~watchdog-fix-watchdog_nmi_enable_all kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-fix-watchdog_nmi_enable_all
+++ a/kernel/watchdog.c
@@ -608,7 +608,7 @@ void watchdog_nmi_enable_all(void)
 {
 	int cpu;
 
-	if (!watchdog_user_enabled)
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
 		return;
 
 	get_online_cpus();
_

Patches currently in -mm which might be from uobergfe@redhat.com are

smpboot-allow-excluding-cpus-from-the-smpboot-threads.patch
smpboot-allow-excluding-cpus-from-the-smpboot-threads-fix.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz.patch
watchdog-add-watchdog_cpumask-sysctl-to-assist-nohz-fix-2.patch
procfs-treat-parked-tasks-as-sleeping-for-task-state.patch
linux-next.patch

