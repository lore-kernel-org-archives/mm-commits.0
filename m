Return-Path: <SRS0=ColI=A4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D89AC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082E120704
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jul 2020 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595018106;
	bh=S+qHSL5cD5ixwl9ORoIXSsWj/Me3k35IfJwGDQD9ga0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=cfIHH7l2QS9A2ix8ZK+S7udt3RdhbQkhW9WopkdKpL05d4Oyryn/cdHiKa1SS4KCs
	 +TN58Gt0ShFYAfxVk6/kD1Zc+RV39CN5n3C0YUtyqPmdX2Vx6Y0ywbMXSqVBpsovYH
	 BsVuFpVvRJ7kNiV/CRdm4Dawu5U3hf87KIA6YiOI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgGQUfE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 17 Jul 2020 16:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgGQUfE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Jul 2020 16:35:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA95D20684;
        Fri, 17 Jul 2020 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595018104;
        bh=S+qHSL5cD5ixwl9ORoIXSsWj/Me3k35IfJwGDQD9ga0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vSb0J1WyO/xFh7rPgJ5d3TXTFb4aqFjFKOpGDRVSwo0fIZ1a5IIbHRQLuTwl3vRSI
         BGV7ofqsvAjezzKHvLi6RWEFOP3VwtRjZiE34yoO7C39mS3CkgyxcoolFyXP7spPRh
         xC7O4F//bvQyEGmzaoIYY+996j3pOmL1CT2tj5PA=
Date:   Fri, 17 Jul 2020 13:35:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com,
        jonathan.cameron@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com
Subject:  +
 mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
 added to -mm tree
Message-ID: <20200717203503.5bMQidYMg%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch

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
Subject: mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix

fix CONFIG_CMA=n warning

mm/hugetlb.c:48:20: warning: hugetlb_cma defined but not used [-Wunused-variable]

Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix
+++ a/mm/hugetlb.c
@@ -45,7 +45,9 @@ int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
+#ifdef CONFIG_CMA
 static struct cma *hugetlb_cma[MAX_NUMNODES];
+#endif
 static unsigned long hugetlb_cma_size __initdata;
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-race-between-munmap-and-expand_upwards-downwards-fix.patch
mm-hugetlb-avoid-hardcoding-while-checking-if-cma-is-enabled-fix.patch
mm.patch
mm-handle-page-mapping-better-in-dump_page-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix.patch
mm-thp-replace-http-links-with-https-ones-fix.patch
mm-vmstat-add-events-for-thp-migration-without-split-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-2.patch
kernel-forkc-export-kernel_thread-to-modules.patch

