Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B081FC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A9F225AB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgLWByF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgLWByE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:54:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34EE22573;
        Wed, 23 Dec 2020 01:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608688404;
        bh=yVnkLH8IvyWDTZZ06mr8d9XVFfOzAddc0b04//Jts+0=;
        h=Date:From:To:Subject:From;
        b=mifJg44hhsviEYBmh4pUpT4fQrX1/0LPb6PVqTEn5T8VFM6nZ0N4TI+rpidvrcK3N
         NKG3J1tI92B/R5yHRNazvzNPnWqKBPqF1c/CLTKOEHuXX7hVSIlnpgpajbpOq+8M6L
         QW8Bzl3osH4EKvIW2I5NLHEB94crUsn6yak3SORA=
Date:   Tue, 22 Dec 2020 17:53:23 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        rppt@linux.ibm.com, riel@surriel.com, mhocko@kernel.org,
        iamjoonsoo.kim@lge.com, guro@fb.com
Subject:  + mm-cma-allocate-cma-areas-bottom-up.patch added to -mm
 tree
Message-ID: <20201223015323.MfXZG%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: allocate cma areas bottom-up
has been added to the -mm tree.  Its filename is
     mm-cma-allocate-cma-areas-bottom-up.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocate-cma-areas-bottom-up.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocate-cma-areas-bottom-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20201217201214.3414100-1-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up
+++ a/mm/cma.c
@@ -336,6 +336,22 @@ int __init cma_declare_contiguous_nid(ph
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
+		if (!memblock_bottom_up() &&
+		    memblock_end >= SZ_4G + size) {
+			memblock_set_bottom_up(true);
+			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
+							limit, nid, true);
+			memblock_set_bottom_up(false);
+		}
+
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
 					limit, nid, true);
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

