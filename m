Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1EBC61DA4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjCMTvw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCMTvv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302FF23327
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA3DA614B6
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03326C433D2;
        Mon, 13 Mar 2023 19:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678737109;
        bh=RPdQPkgVZ6pkwRMDvPGKJKbSjvDUXV4nhtRSY4BKF0E=;
        h=Date:To:From:Subject:From;
        b=BOf80k9G37B3J2qc0KJuuOFaqn2JvfdWZ1bL4CKwt67R0jMOMdQ0qj5xCq7WZDKb8
         6PrmnCNEWG7OsbkjNNgHFUUeTLFn1WURoqPa6l2WB1uZnulm15n/9tDshKmHVp75pl
         bMBcQZkF6fHU3PxwVvfy7lhRYXyKe+ogt2n7+uQs=
Date:   Mon, 13 Mar 2023 12:51:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        thomas.hellstrom@linux.intel.com, peterx@redhat.com,
        mtosatti@redhat.com, mhocko@suse.com, lstoakes@gmail.com,
        linux@armlinux.org.uk, kirill.shutemov@linux.intel.com,
        jgg@ziepe.ca, hca@linux.ibm.com, frederic@kernel.org,
        dan.j.williams@intel.com, cl@linux.com, christian.koenig@amd.com,
        chenhuacai@kernel.org, atomlin@atomlin.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch added to mm-unstable branch
Message-Id: <20230313195149.03326C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
Date: Mon Mar 13 12:50:06 PM PDT 2023

update cpu_vm_stats_fold() stub to fix build

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
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/vmstat.h~vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix
+++ a/include/linux/vmstat.h
@@ -408,7 +408,7 @@ static inline void __dec_node_page_state
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_zone_stat_thresholds(void) { }
-static inline void cpu_vm_stats_fold(int cpu) { }
+static inline void cpu_vm_stats_fold(int cpu, bool do_pagesets) { }
 static inline void quiet_vmstat(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-reduce-page-alloc-free-sanity-checks-checkpatch-fixes.patch
mm-page_alloc-reduce-page-alloc-free-sanity-checks-fix.patch
mm-userfaultfd-support-wp-on-multiple-vmas-fix.patch
mm-add-new-api-to-enable-ksm-per-process-fix.patch
vmstat-add-pcp-remote-node-draining-via-cpu_vm_stats_fold-fix.patch
scripts-link-vmlinuxsh-fix-error-message-presentation.patch

