Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2710FC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiANVaH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:30:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55858 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANVaF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:30:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D91661F92
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522CAC36AE5;
        Fri, 14 Jan 2022 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195804;
        bh=Hp4Iz1RKfTHvF2uOoKVR/Kmrhonf3yx+igQIGaRNqAY=;
        h=Date:From:To:Subject:From;
        b=y4CCvcCm2dTKiXooWkbDcWe5UNU5kLMvCcHyA4SiHfmjqM/5qeAY0fx0RkbaaFC61
         O6j2oDNKZ8TFZLKQ4K2V1/eJ9pKkbnjSF1Oaiz2WDnRbnAC4ymczbXM+BM/5koR6Mr
         bQ/X4qQyFLF4pnUnh9VxpKRriaBK5nGpd+0FHW7Q=
Date:   Fri, 14 Jan 2022 13:30:03 -0800
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, keescook@chromium.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, songmuchun@bytedance.com
Subject:  [folded-merged]
 hugetlb-add-hugetlbnuma_stat-file-fix-2.patch removed from -mm tree
Message-ID: <20220114213003.4cTKFzais%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: fix copy/paste array assignment
has been removed from the -mm tree.  Its filename was
     hugetlb-add-hugetlbnuma_stat-file-fix-2.patch

This patch was dropped because it was folded into hugetlb-add-hugetlbnuma_stat-file.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: hugetlb/cgroup: fix copy/paste array assignment

Fix mismatched array assignment, reported by an -Warray-bounds build:

mm/hugetlb_cgroup.c: In function '__hugetlb_cgroup_file_legacy_init':
mm/hugetlb_cgroup.c:850:35: error: array subscript 8 is above array bounds of 'struct cftype[8]' [-Werror=array-bounds ]
  850 |         cft = &h->cgroup_files_dfl[8];
      |                ~~~~~~~~~~~~~~~~~~~^~~
In file included from mm/hugetlb_cgroup.c:23:
./include/linux/hugetlb.h:625:23: note: while referencing 'cgroup_files_dfl'
  625 |         struct cftype cgroup_files_dfl[8];
      |                       ^~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20211203065647.2819707-1-keescook@chromium.org
Fixes: e45f4726bcad ("hugetlb: add hugetlb.*.numa_stat file")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~hugetlb-add-hugetlbnuma_stat-file-fix-2
+++ a/mm/hugetlb_cgroup.c
@@ -847,7 +847,7 @@ static void __init __hugetlb_cgroup_file
 	cft->read_u64 = hugetlb_cgroup_read_u64;
 
 	/* Add the numa stat file */
-	cft = &h->cgroup_files_dfl[8];
+	cft = &h->cgroup_files_legacy[8];
 	snprintf(cft->name, MAX_CFTYPE_NAME, "%s.numa_stat", buf);
 	cft->private = MEMFILE_PRIVATE(idx, 1);
 	cft->seq_show = hugetlb_cgroup_read_numa_stat;
_

Patches currently in -mm which might be from keescook@chromium.org are

hugetlb-add-hugetlbnuma_stat-file.patch
hfsplus-use-struct_group_attr-for-memcpy-region.patch
ubsan-remove-config_ubsan_object_size.patch

