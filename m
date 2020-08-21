Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B036C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 21:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2718207DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 21:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598045820;
	bh=l+myBhIMCy/AH3UwAAeVElw4+acp4ZsLBIhhiZsOmJg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Vyuf0VaaMFAVwhQclOxsZMttlxYN+sMh/W3X8mU+w7JG9Hcr2qWbUk61mgXXomZ73
	 RIvzeSxC7NEnv0qdUahTkvr+s4G2uWcU9KTcOm+C++lmiWZ27DDLOo42Q36BSyqQ/U
	 nkhhHz/fM7Jel+Z0hPvt20aTwXOnKdH6LoFv2khQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHUVhA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 17:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgHUVhA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 17:37:00 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A679C20724;
        Fri, 21 Aug 2020 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598045819;
        bh=l+myBhIMCy/AH3UwAAeVElw4+acp4ZsLBIhhiZsOmJg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=L1HHH9nbNNIfWcBmp646Ygb+7TzXuL8WZNIB+hbX/3b/aZq9VO0a/+3QrFKubjGpW
         27T45f7vXzW0CFR0XxsxarnaZPNvIYth7v+lh3fc5hVTMsCHTrUvIVH7LzafRC6/VD
         byl+VjZJMW6gW/pfzxhTWHtW7VctEn+EooEmnPrw=
Date:   Fri, 21 Aug 2020 14:36:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ira.weiny@intel.com, jhubbard@nvidia.com, keith.busch@intel.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        song.bao.hua@hisilicon.com
Subject:  +
 mm-gup_benchmark-update-the-documentation-in-kconfig.patch added to -mm
 tree
Message-ID: <20200821213659.gu9n5TeBv%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_benchmark: update the documentation in Kconfig
has been added to the -mm tree.  Its filename is
     mm-gup_benchmark-update-the-documentation-in-kconfig.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup_benchmark-update-the-documentation-in-kconfig.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup_benchmark-update-the-documentation-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-gup_benchmark-update-the-documentation-in-kconfig.patch
mm-gup_benchmark-use-pin_user_pages-for-foll_longterm-flag.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm.patch

