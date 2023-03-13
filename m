Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D0C74A4B
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 18:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCMSID (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 14:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCMSHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 14:07:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145EA7A907
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 11:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAAC1B811C0
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 18:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611D3C433EF;
        Mon, 13 Mar 2023 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678730865;
        bh=9oC5ppfl+TtNPk9bGH39Fho6KAOcALIUMkMmFXefz+Q=;
        h=Date:To:From:Subject:From;
        b=shQyn7g1SDLCophtDyoe9xM76Uzwij/BxhVWuPX9LvoEw0RvCbnn6XoEUpnqtWOLr
         3y+dZXtm4gWNhhEH9ObgZeaZRT5NKz3iukIvFciwUC3f8TCFlrO3lnwWGNRael5MeU
         RLHoGmMw61BZjoM0256LunI1MyVXB4xjmWKDFOZc=
Date:   Mon, 13 Mar 2023 11:07:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mhocko@suse.com, lstoakes@gmail.com, linux@armlinux.org.uk,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, hca@linux.ibm.com,
        frederic@kernel.org, dan.j.williams@intel.com, cl@linux.com,
        christian.koenig@amd.com, chenhuacai@kernel.org,
        atomlin@atomlin.com, mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch added to mm-unstable branch
Message-Id: <20230313180745.611D3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: refresh stats remotely instead of via work item
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: mm/vmstat: refresh stats remotely instead of via work item
Date: Mon, 13 Mar 2023 13:25:18 -0300

Refresh per-CPU stats remotely, instead of queueing work items, for the
stat_refresh procfs method.

This fixes sosreport hang (which uses vmstat_refresh) with spinning
SCHED_FIFO process.

Link: https://lkml.kernel.org/r/20230313162634.535939407@redhat.com
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmstat.c~mm-vmstat-refresh-stats-remotely-instead-of-via-work-item
+++ a/mm/vmstat.c
@@ -1907,11 +1907,20 @@ static DEFINE_PER_CPU(struct delayed_wor
 int sysctl_stat_interval __read_mostly = HZ;
 
 #ifdef CONFIG_PROC_FS
+#ifdef CONFIG_HAVE_CMPXCHG_LOCAL
+static int refresh_all_vm_stats(void);
+#else
 static void refresh_vm_stats(struct work_struct *work)
 {
 	refresh_cpu_vm_stats(true);
 }
 
+static int refresh_all_vm_stats(void)
+{
+	return schedule_on_each_cpu(refresh_vm_stats);
+}
+#endif
+
 int vmstat_refresh(struct ctl_table *table, int write,
 		   void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -1931,7 +1940,7 @@ int vmstat_refresh(struct ctl_table *tab
 	 * transiently negative values, report an error here if any of
 	 * the stats is negative, so we know to go looking for imbalance.
 	 */
-	err = schedule_on_each_cpu(refresh_vm_stats);
+	err = refresh_all_vm_stats();
 	if (err)
 		return err;
 	for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++) {
@@ -2051,7 +2060,7 @@ static DECLARE_DEFERRABLE_WORK(shepherd,
 
 #ifdef CONFIG_HAVE_CMPXCHG_LOCAL
 /* Flush counters remotely if CPU uses cmpxchg to update its per-CPU counters */
-static void vmstat_shepherd(struct work_struct *w)
+static int refresh_all_vm_stats(void)
 {
 	int cpu;
 
@@ -2061,7 +2070,12 @@ static void vmstat_shepherd(struct work_
 		cond_resched();
 	}
 	cpus_read_unlock();
+	return 0;
+}
 
+static void vmstat_shepherd(struct work_struct *w)
+{
+	refresh_all_vm_stats();
 	schedule_delayed_work(&shepherd,
 		round_jiffies_relative(sysctl_stat_interval));
 }
_

Patches currently in -mm which might be from mtosatti@redhat.com are

this_cpu_cmpxchg-arm64-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-loongarch-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-s390-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
this_cpu_cmpxchg-x86-switch-this_cpu_cmpxchg-to-locked-add-_local-function.patch
add-this_cpu_cmpxchg_local-and-asm-generic-definitions.patch
convert-this_cpu_cmpxchg-users-to-this_cpu_cmpxchg_local.patch
mm-vmstat-switch-counter-modification-to-cmpxchg.patch
vmstat-switch-per-cpu-vmstat-counters-to-32-bits.patch
mm-vmstat-use-xchg-in-cpu_vm_stats_fold.patch
mm-vmstat-switch-vmstat-shepherd-to-flush-per-cpu-counters-remotely.patch
mm-vmstat-refresh-stats-remotely-instead-of-via-work-item.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold.patch

