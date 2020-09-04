Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EB8C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 19:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52B9206A5
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 19:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599247224;
	bh=Vz0GsSgDO8q8xBMI4DkeNCOSUSuiO0p2JyZZ6rGt+aA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=c/M8lXueWanoLJ12A4145yW6EWXS2e9x6r8ygy2fI68KhPpuogk4Dn3F/xnrn8hbV
	 l+eeR0nr5Z+iwo5LOkGT5BM3ujQ+5xLjipgfR/x8Z8aqpDjQjbG4tFL9pwBQqi8V8/
	 ypd5wdm4dM6pd8fbDwbZC8PJO97RbUkE9Wh9Rn+E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIDTUY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 15:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726135AbgIDTUY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 15:20:24 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D373D20684;
        Fri,  4 Sep 2020 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599247223;
        bh=Vz0GsSgDO8q8xBMI4DkeNCOSUSuiO0p2JyZZ6rGt+aA=;
        h=Date:From:To:Subject:From;
        b=eDoAbdqUDbptwx5IfeiOMAnydlJA2gbGIzIZ11Hj1b2ln3uR+78SgPMdUMnwEZT+s
         3OGaCjr9sbf58hG99q+1Qo9KAQ0eEQRHH+kvDDTzD2mMapZPjbbc/XmF9TyfacXBi3
         0FiCLeAttkMTvjHqf4IngqlrXxJEQZsHpKAhLxbM=
Date:   Fri, 04 Sep 2020 12:20:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, walken@google.com,
        tony.luck@intel.com, rppt@kernel.org,
        richard.weiyang@linux.alibaba.com, pankaj.gupta.linux@gmail.com,
        osalvador@suse.de, mhocko@suse.com, mgorman@techsingularity.net,
        mgorman@suse.de, logang@deltatee.com, fenghua.yu@intel.com,
        david@redhat.com, dan.j.williams@intel.com,
        charante@codeaurora.org, bhe@redhat.com, akpm@linux-foundation.org
Subject:  + mm-memory_hotplug-simplify-page-offlining-fix.patch added
 to -mm tree
Message-ID: <20200904192020.AuiIV%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-simplify-page-offlining-fix
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-simplify-page-offlining-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-simplify-page-offlining-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-simplify-page-offlining-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1580,9 +1580,10 @@ int __ref offline_pages(unsigned long st
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

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch

