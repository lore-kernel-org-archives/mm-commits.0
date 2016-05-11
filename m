From: akpm@linux-foundation.org
Subject: + mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch
 added to -mm tree
Date: Wed, 11 May 2016 15:36:25 -0700
Message-ID: <5733b3e9.LS5psAB7VnqscvVm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbcEKWg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2016 18:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Do not build vmstat_refresh if there is no procfs support
has been added to the -mm tree.  Its filename is
     mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-proc-sys-vm-stat_refresh-to-force-vmstat-update-fix.patch
vmstat-get-rid-of-the-ugly-cpu_stat_off-variable-v2.patch

