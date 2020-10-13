Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAA9C2D0A3
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1BE822201
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633143;
	bh=Bt1wofAOZG5357ODR7cfgLhSFUlCFFMxMkjLjY1Z/4E=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZpEgYn7YR/8uYQfX+zMkdRXNuK7PPIAovYREcRZDRy9O9jvQ5jnQkiZNAbVcs5p/P
	 7p8mYsUQFsDzO/q9Gy4BeCBapNF4IgBH1htf5snrp2ACWDBpb4lbS/ZvmZ31bY9hU3
	 Vq9ruQbMWCtONq09KroSOtMMo4VpRuoXqD2YnClQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgJMXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbgJMXvw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9337C21D81;
        Tue, 13 Oct 2020 23:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633111;
        bh=Bt1wofAOZG5357ODR7cfgLhSFUlCFFMxMkjLjY1Z/4E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WpmOp3HT2QLsJXgIiL/rzc6XEwBhmLHV/zFR2XLghVAFPXC8gWhzlaUpmRCx9uFBk
         4qwJyc/VAJMLAvJh+DbEM2tVwuFi8c6b7KGMTA9+qnkha54AENvIvzfjWbfXvD9on1
         zA7oW2F6rQc0xIR2CL70KeYyFnlo5shNm96vQpes=
Date:   Tue, 13 Oct 2020 16:51:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ira.weiny@intel.com,
        jhubbard@nvidia.com, keith.busch@intel.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com,
        torvalds@linux-foundation.org
Subject:  [patch 064/181] mm/gup_benchmark: update the
 documentation in Kconfig
Message-ID: <20201013235151.1uV1MoXWp%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
