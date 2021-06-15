Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59AF3C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 320D8610A0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhFOC2i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:28:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229782AbhFOC2h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 22:28:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA80C6100B;
        Tue, 15 Jun 2021 02:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623722748;
        bh=ZFtyuTx8VLBSFTFBWid2ovfEPURebQPmXTtCIu3lq1Y=;
        h=Date:From:To:Subject:From;
        b=eug7IGURQ+BMQjci8V8eRyFxJ/9NAAjsGX0xe6RtJ+1m/zeoY9sdr1LuAVnXF7+bs
         rIZUSFKFX7wLa9JC10nM0k+NeE+DQA/RBonpknnGFHPhAZAXkAcTJO83XQ4IDx0t0h
         l17/iboJ6dIzW52duNm6P8b6kII1n7ZL5GmiDrzs=
Date:   Mon, 14 Jun 2021 19:05:47 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, hca@linux.ibm.com,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        yuzhao@google.com
Subject:  + mm-mark-idle-page-tracking-as-broken.patch added to -mm
 tree
Message-ID: <20210615020547.0bhMmTZsz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mark idle page tracking as BROKEN
has been added to the -mm tree.  Its filename is
     mm-mark-idle-page-tracking-as-broken.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mark-idle-page-tracking-as-broken.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mark-idle-page-tracking-as-broken.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: mark idle page tracking as BROKEN

In discussion with other MM developers around how idle page tracking
should be fixed for transparent huge pages, several expressed the opinion
that it should be removed as it is inefficient at accomplishing the job
that it is supposed to, and we have better mechanisms (eg uffd) for
accomplishing the same goals these days.

Mark the feature as BROKEN for now and we can remove it entirely in a few
months if nobody complains.  It is not enabled by Android, ChromeOS,
Debian, Fedora or SUSE.  Red Hat enabled it with RHEL-8.1 and UEK followed
suit, but I have been unable to find why RHEL enabled it.

Link: https://lkml.kernel.org/r/20210612000714.775825-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Yu Zhao <yuzhao@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
SeongJae Park <sj38.park@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-mark-idle-page-tracking-as-broken
+++ a/mm/Kconfig
@@ -772,7 +772,7 @@ config DEFERRED_STRUCT_PAGE_INIT
 
 config IDLE_PAGE_TRACKING
 	bool "Enable idle page tracking"
-	depends on SYSFS && MMU
+	depends on SYSFS && MMU && BROKEN
 	select PAGE_EXTENSION if !64BIT
 	help
 	  This feature allows to estimate the amount of user pages that have
_

Patches currently in -mm which might be from willy@infradead.org are

mm-mark-idle-page-tracking-as-broken.patch
mm-make-__dump_page-static.patch
mm-debug-factor-pagepoisoned-out-of-__dump_page.patch
mm-page_owner-constify-dump_page_owner.patch
mm-make-compound_head-const-preserving.patch
mm-constify-get_pfnblock_flags_mask-and-get_pfnblock_migratetype.patch
mm-constify-page_count-and-page_ref_count.patch
mm-optimise-nth_page-for-contiguous-memmap.patch

