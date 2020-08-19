Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE018C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:19:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA9F320829
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 03:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597807160;
	bh=rUWJN8hlgo+Yoho3OLukbzLXTPkmY3lt4WLJTR7qLC0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dI2YQ04z93239ck4BUjfObqLjFFoBXeREHseEc/Hn+HUzHYWlcIykku83woQ/19EG
	 C/wz+c1XRGMt27imAVvk9H6zHQnqYGF57o+FgNW70OjUnojJ5unpuKkgBl4Ewam6aq
	 eJIJgWVRVwtU6rb7vf2+Dzy5bqpD+Qu5yE1yACew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHSDTU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 23:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbgHSDTT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 23:19:19 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4F5E2083B;
        Wed, 19 Aug 2020 03:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597807159;
        bh=rUWJN8hlgo+Yoho3OLukbzLXTPkmY3lt4WLJTR7qLC0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Z1sUhAmVChMJDs4u0KjTLEOlID1Eslwllbefknz69zSjfdDsxquGFZR4hX8E9TXBx
         9c+qHaWziPxvY8p23X8eChU66YUwv4KYkdfnALZHYLUuQ1KK9B2Lihl6+Rm48z4Hm5
         XQkwMq0jf05yIYH7PxsMJha0/bJiNiw2gQpz7LaY=
Date:   Tue, 18 Aug 2020 20:19:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jbaron@akamai.com, kirill.shutemov@linux.intel.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, opendmb@gmail.com,
        rientjes@google.com
Subject:  + mm-include-cma-pages-in-lowmem_reserve-at-boot.patch
 added to -mm tree
Message-ID: <20200819031918.AQXsfLOq1%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: include CMA pages in lowmem_reserve at boot
has been added to the -mm tree.  Its filename is
     mm-include-cma-pages-in-lowmem_reserve-at-boot.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-include-cma-pages-in-lowmem_reserve-at-boot.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-include-cma-pages-in-lowmem_reserve-at-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Berger <opendmb@gmail.com>
Subject: mm: include CMA pages in lowmem_reserve at boot

The lowmem_reserve arrays provide a means of applying pressure against
allocations from lower zones that were targeted at higher zones.  Its
values are a function of the number of pages managed by higher zones and
are assigned by a call to the setup_per_zone_lowmem_reserve() function.

The function is initially called at boot time by the function
init_per_zone_wmark_min() and may be called later by accesses of the
/proc/sys/vm/lowmem_reserve_ratio sysctl file.

The function init_per_zone_wmark_min() was moved up from a module_init to
a core_initcall to resolve a sequencing issue with khugepaged. 
Unfortunately this created a sequencing issue with CMA page accounting.

The CMA pages are added to the managed page count of a zone when
cma_init_reserved_areas() is called at boot also as a core_initcall.  This
makes it uncertain whether the CMA pages will be added to the managed page
counts of their zones before or after the call to
init_per_zone_wmark_min() as it becomes dependent on link order.  With the
current link order the pages are added to the managed count after the
lowmem_reserve arrays are initialized at boot.

This means the lowmem_reserve values at boot may be lower than the values
used later if /proc/sys/vm/lowmem_reserve_ratio is accessed even if the
ratio values are unchanged.

In many cases the difference is not significant, but for example
an ARM platform with 1GB of memory and the following memory layout
[    0.000000] cma: Reserved 256 MiB at 0x0000000030000000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000000000-0x000000002fffffff]
[    0.000000]   Normal   empty
[    0.000000]   HighMem  [mem 0x0000000030000000-0x000000003fffffff]

would result in 0 lowmem_reserve for the DMA zone.  This would allow
userspace to deplete the DMA zone easily.  Funnily enough

$ cat /proc/sys/vm/lowmem_reserve_ratio

would fix up the situation because it forces setup_per_zone_lowmem_reserve
as a side effect.

This commit breaks the link order dependency by invoking
init_per_zone_wmark_min() as a postcore_initcall so that the CMA pages
have the chance to be properly accounted in their zone(s) and allowing the
lowmem_reserve arrays to receive consistent values.

Link: http://lkml.kernel.org/r/1597423766-27849-1-git-send-email-opendmb@gmail.com
Fixes: bc22af74f271 ("mm: update min_free_kbytes from khugepaged after core initialization")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jason Baron <jbaron@akamai.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-include-cma-pages-in-lowmem_reserve-at-boot
+++ a/mm/page_alloc.c
@@ -7888,7 +7888,7 @@ int __meminit init_per_zone_wmark_min(vo
 
 	return 0;
 }
-core_initcall(init_per_zone_wmark_min)
+postcore_initcall(init_per_zone_wmark_min)
 
 /*
  * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so
_

Patches currently in -mm which might be from opendmb@gmail.com are

mm-include-cma-pages-in-lowmem_reserve-at-boot.patch

