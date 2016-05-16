From: akpm@linux-foundation.org
Subject: [alternative-merged]
 mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch removed from
 -mm tree
Date: Mon, 16 May 2016 16:53:39 -0700
Message-ID: <573a5d83.wZjcW1BuceQ/V2Ka%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbcEPXxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 May 2016 19:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Do not build vmstat_refresh if there is no procfs support
has been removed from the -mm tree.  Its filename was
     mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: Do not build vmstat_refresh if there is no procfs support

It makes no sense to build functionality into the kernel that
cannot be used and causes build issues.

Link: http://lkml.kernel.org/r/alpine.DEB.2.20.1605111011260.9351@east.gentwo.org
Signed-off-by: Christoph Lameter <cl@linux.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix
+++ a/mm/vmstat.c
@@ -1371,7 +1371,6 @@ static const struct file_operations proc
 	.llseek		= seq_lseek,
 	.release	= seq_release,
 };
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_SMP
 static struct workqueue_struct *vmstat_wq;
@@ -1436,7 +1435,10 @@ int vmstat_refresh(struct ctl_table *tab
 		*lenp = 0;
 	return 0;
 }
+#endif /* CONFIG_SMP */
+#endif /* CONFIG_PROC_FS */
 
+#ifdef CONFIG_SMP
 static void vmstat_update(struct work_struct *w)
 {
 	if (refresh_cpu_vm_stats(true)) {
_

Patches currently in -mm which might be from cl@linux.com are

vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2.patch

