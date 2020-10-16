Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D38C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9057D20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602814604;
	bh=rGcdInkKQ+SiMbWQTktA7R+UG/z+MiCzUeRTSKfwGsg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Rn7IPtnDIhEescOXJaYEZhu0GE0CGDr1SxxKbaKE7ylnKLW3fkU1nGu+6oCwafDDU
	 sRusLRHp3gUGeW6PCW1DPbsXb7LgqrASKP706UHwVm8kIV3pOOb+Rl4kax6nsGSn0u
	 FEiIovOY30v+wvgC5nghIybUsjcTL8WDVtZSiWWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388739AbgJPCQo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387691AbgJPCQn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:16:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF13B20878;
        Fri, 16 Oct 2020 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602814602;
        bh=rGcdInkKQ+SiMbWQTktA7R+UG/z+MiCzUeRTSKfwGsg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jkqunlIrOEVIv5/gLNsue/cyWcX+mGfg5X83A+KFxHvapMA+ZTq7qHKsrI02pJsxE
         Q/3MZv2bjy8VsUES9yMWtbnxqRfhGwObz5hilL+85C7Q4mnSYKR6qodvKrSESTMaeP
         HRRRAB9nZhR5pcCD3kQxDxubpeMrRq3ALMQBvFvY=
Date:   Thu, 15 Oct 2020 19:16:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  [folded-merged]
 mm-memory_hotplug-simplify-page-offlining-fix.patch removed from -mm tree
Message-ID: <20201016021641.Z9BVU5V5D%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-simplify-page-offlining-fix
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-simplify-page-offlining-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-simplify-page-offlining.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory_hotplug-simplify-page-offlining-fix

Cc: Baoquan He <bhe@redhat.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-simplify-page-offlining-fix
+++ a/mm/memory_hotplug.c
@@ -1581,9 +1581,10 @@ int __ref offline_pages(unsigned long st
 		 * because has_unmovable_pages explicitly checks for
 		 * PageBuddy on freed pages on other zones.
 		 */
+		ret = test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE);
 		if (ret)
 			drain_all_pages(zone);
-	} while (test_pages_isolated(start_pfn, end_pfn, MEMORY_OFFLINE));
+	} while (ret);
 
 	/* Mark all sections offline and remove free pages from the buddy. */
 	__offline_isolated_pages(start_pfn, end_pfn);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-simplify-page-offlining.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
linux-next-rejects.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

