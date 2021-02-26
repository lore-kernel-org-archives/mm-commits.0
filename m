Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28418C433E6
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF56464EE4
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhBZBRL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhBZBRE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 012E764EE4;
        Fri, 26 Feb 2021 01:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302194;
        bh=oswZ/n8kvYSQSHFbTQC9B5gb7ozgoQXb7LeLHiWeZuE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t3c2+QMiAPGkPihl7HIsXCID86AT8RwRqOaBzlZCuDCmyG+7o82aVZFWSZXrVJp2A
         ZTQYgyPf0ZvKyojT9IvUol+V/2tRTEQa7ym8lTM1hEHvh84jr1iWQiHxYu+bXJKXi2
         d3q1kCUm2oJpkKSYbXovvedDWVL/myoCTjAaq6IU=
Date:   Thu, 25 Feb 2021 17:16:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        riel@surriel.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, vvghjk1234@gmail.com
Subject:  [patch 019/118] mm: cma: allocate cma areas bottom-up
Message-ID: <20210226011633.vTL2E_Khb%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: cma: allocate cma areas bottom-up

Currently cma areas without a fixed base are allocated close to the end of
the node.  This placement is sub-optimal because of compaction: it brings
pages into the cma area.  In particular, it can bring in hot executable
pages, even if there is a plenty of free memory on the machine.  This
results in cma allocation failures.

Instead let's place cma areas close to the beginning of a node.  In this
case the compaction will help to free cma areas, resulting in better cma
allocation success rates.

If there is enough memory let's try to allocate bottom-up starting with
4GB to exclude any possible interference with DMA32.  On smaller machines
or in a case of a failure, stick with the old behavior.

16GB vm, 2GB cma area:
With this patch:
[    0.000000] Command line: root=/dev/vda3 rootflags=subvol=/root systemd.unified_cgroup_hierarchy=1 enforcing=0 console=ttyS0,115200 hugetlb_cma=2G
[    0.002928] hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
[    0.002930] cma: Reserved 2048 MiB at 0x0000000100000000
[    0.002931] hugetlb_cma: reserved 2048 MiB on node 0

Without this patch:
[    0.000000] Command line: root=/dev/vda3 rootflags=subvol=/root systemd.unified_cgroup_hierarchy=1 enforcing=0 console=ttyS0,115200 hugetlb_cma=2G
[    0.002930] hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
[    0.002933] cma: Reserved 2048 MiB at 0x00000003c0000000
[    0.002934] hugetlb_cma: reserved 2048 MiB on node 0

v2:
  - switched to memblock_set_bottom_up(true), by Mike
  - start with 4GB, by Mike

[guro@fb.com: whitespace fix, per Mike]
  Link: https://lkml.kernel.org/r/20201221170551.GB3428478@carbon.DHCP.thefacebook.com
[guro@fb.com: fix 32-bit warnings]
  Link: https://lkml.kernel.org/r/20201223163537.GA4011967@carbon.DHCP.thefacebook.com
[guro@fb.com: fix 32-bit systems]
[akpm@linux-foundation.org: build fix]
Link: https://lkml.kernel.org/r/20201217201214.3414100-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up
+++ a/mm/cma.c
@@ -336,6 +336,23 @@ int __init cma_declare_contiguous_nid(ph
 			limit = highmem_start;
 		}
 
+		/*
+		 * If there is enough memory, try a bottom-up allocation first.
+		 * It will place the new cma area close to the start of the node
+		 * and guarantee that the compaction is moving pages out of the
+		 * cma area and not into it.
+		 * Avoid using first 4GB to not interfere with constrained zones
+		 * like DMA/DMA32.
+		 */
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
+			memblock_set_bottom_up(true);
+			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
+							limit, nid, true);
+			memblock_set_bottom_up(false);
+		}
+#endif
+
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
 					limit, nid, true);
_
