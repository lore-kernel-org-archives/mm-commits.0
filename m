Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BC6C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978602065D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027060;
	bh=p/qzCwik9jEXqC0Jqb0Kli6I4UTRmbEICE0+oPYT520=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yEUkb8oQdPTlwrq5AKR2xXTSzUlxSDRW9CSqUa/sbHwaW+51uBEZq4mdXLM+KyCpi
	 kdgXsgvBFhQYa/7vzAMq6klB4yM7m3rRupJMxYBQIC3QVnNe9SHreeM3gHPRuj1HDE
	 G9Jc9cIcTTccKeGWye9A1u6VCHqCijQOyUg5/D1M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJChk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:37:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJChk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:37:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D491206C3;
        Mon, 10 Aug 2020 02:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027059;
        bh=p/qzCwik9jEXqC0Jqb0Kli6I4UTRmbEICE0+oPYT520=;
        h=Date:From:To:Subject:From;
        b=dJGueyZO7HCBfRyH4mYMOZjcNkV7WhSIBxWtOjWI+0ju9mpLpr/K8XT1up669tGvy
         r61Hj1yxOUTfRAd/6ABWg3Fgk3dJ8a3F2cuIdckM+3ah7YxkKu4zpBx3zdXDxi2jB2
         sIgES4uHdpaZmv35XEpkmBAsXmZaVdADrbRdUS4o=
Date:   Sun, 09 Aug 2020 19:37:39 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        zhangalex@google.com
Subject:  [merged]
 mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch removed from
 -mm tree
Message-ID: <20200810023739.lbxVPSY61%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: make remap_pfn_range() reject unaligned addr
has been removed from the -mm tree.  Its filename was
     mm-memoryc-make-remap_pfn_range-reject-unaligned-addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alex Zhang <zhangalex@google.com>
Subject: mm/memory.c: make remap_pfn_range() reject unaligned addr

This function implicitly assumes that the addr passed in is page aligned. 
A non page aligned addr could ultimately cause a kernel bug in
remap_pte_range as the exit condition in the logic loop may never be
satisfied.  This patch documents the need for the requirement, as well as
explicitly adds a check for it.

Link: http://lkml.kernel.org/r/20200617233512.177519-1-zhangalex@google.com
Signed-off-by: Alex Zhang <zhangalex@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-make-remap_pfn_range-reject-unaligned-addr
+++ a/mm/memory.c
@@ -2082,7 +2082,7 @@ static inline int remap_p4d_range(struct
 /**
  * remap_pfn_range - remap kernel memory to userspace
  * @vma: user vma to map to
- * @addr: target user address to start at
+ * @addr: target page aligned user address to start at
  * @pfn: page frame number of kernel physical memory address
  * @size: size of mapping area
  * @prot: page protection flags for this mapping
@@ -2101,6 +2101,9 @@ int remap_pfn_range(struct vm_area_struc
 	unsigned long remap_pfn = pfn;
 	int err;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
+		return -EINVAL;
+
 	/*
 	 * Physically remapped pages are special. Tell the
 	 * rest of the world about it:
_

Patches currently in -mm which might be from zhangalex@google.com are


