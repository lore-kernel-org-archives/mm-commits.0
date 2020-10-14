Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115A7C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2BEB22253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709161;
	bh=XeYSScrkGQAjNkm0YB8hEzrlvoketiJBn0pXXLUQ2fM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ahWn9rvD9L61MDD4Zfu8A5FCAWs+HG5ia3apiZnHJ+KYjtJkogfJjvxb8+hdU/1+L
	 6MXc6ENmF7DeHJHW3YAoZYsTsb8hV49QG+pgciQkze9ZTzIt79KLbVaJoGQlSMkqvw
	 0TjNAfNc6gr0BlPmA4u44PwnDNXWXPfmRM4PR0vI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389512AbgJNU7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:21 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8277E20725;
        Wed, 14 Oct 2020 20:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709160;
        bh=XeYSScrkGQAjNkm0YB8hEzrlvoketiJBn0pXXLUQ2fM=;
        h=Date:From:To:Subject:From;
        b=UE/Q0ngoZ35c1xSpzswdhn27bJCe/bfsQS6kFZrRiHIlBrr7JBC1BnmgKGTdli2GL
         EMn+RJ4uXPIwPSxe80qQFDrhDka4+xdYdvZHRovbdeHA9N1iEnfLMLKw5o7f5fd85A
         SMRbd02Jbd3VlL27+YUleqjxbAqUyF1lZzLIR9iM=
Date:   Wed, 14 Oct 2020 13:59:20 -0700
From:   akpm@linux-foundation.org
To:     ira.weiny@intel.com, jhubbard@nvidia.com, keith.busch@intel.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com
Subject:  [merged]
 mm-gup_benchmark-update-the-documentation-in-kconfig.patch removed from -mm
 tree
Message-ID: <20201014205920.FiwvYbPM-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: update the documentation in Kconfig
has been removed from the -mm tree.  Its filename was
     mm-gup_benchmark-update-the-documentation-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm/gup_benchmark: update the documentation in Kconfig

In the beginning, mm/gup_benchmark.c supported get_user_pages_fast() only,
but right now, it supports the benchmarking of a couple of
get_user_pages() related calls like:

* get_user_pages_fast()
* get_user_pages()
* pin_user_pages_fast()
* pin_user_pages()

The documentation is confusing and needs update.

Link: https://lkml.kernel.org/r/20200821032546.19992-1-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/Kconfig~mm-gup_benchmark-update-the-documentation-in-kconfig
+++ a/mm/Kconfig
@@ -831,10 +831,10 @@ config PERCPU_STATS
 	  be used to help understand percpu memory usage.
 
 config GUP_BENCHMARK
-	bool "Enable infrastructure for get_user_pages_fast() benchmarking"
+	bool "Enable infrastructure for get_user_pages() and related calls benchmarking"
 	help
 	  Provides /sys/kernel/debug/gup_benchmark that helps with testing
-	  performance of get_user_pages_fast().
+	  performance of get_user_pages() and related calls.
 
 	  See tools/testing/selftests/vm/gup_benchmark.c
 
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are


