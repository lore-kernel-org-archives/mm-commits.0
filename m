Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C3AC43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 22:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40BB4208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 22:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599258767;
	bh=zMxsCGfjDZfF/4dABVtr0xFyfiaZxffH1pvl+QmgmEc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gq/FKcAOtYoHeltzqWx5PfyZvGTC0gyHpK5XeHNkat/k2xwZ0EArRCsNRTaMnvfgf
	 rNq0KY3oCFfE/wNUh9r93purZh0VizGfr/XkGqTEbTg/1u930983L3CjGTF7QZlTB3
	 FHZeL1DlVbefhrRXEsKIldrgnF136tyHMUrbPEpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgIDWcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 18:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgIDWcq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 18:32:46 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB8F52083B;
        Fri,  4 Sep 2020 22:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599258765;
        bh=zMxsCGfjDZfF/4dABVtr0xFyfiaZxffH1pvl+QmgmEc=;
        h=Date:From:To:Subject:From;
        b=YOLWotUSmoqO/1P0q38488G6i0uWOOcFxbqDyZW52xEnDWf301huWGVz6Vmuj7bPm
         D53mOKiZ8WePSWNfUk1Rn9thEcApr2HUj11shYXHnha7H2xvnKGU4FpJQRpJg7XKqn
         4NIRCkjQFo1R5DChPaYSgFXpO6ILn3A+77JjAXfI=
Date:   Fri, 04 Sep 2020 15:32:44 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, jroedel@suse.de, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch removed
 from -mm tree
Message-ID: <20200904223244.jC9pR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ARCH_PAGE_TABLE_SYNC_MASK needs vmalloc.h
has been removed from the -mm tree.  Its filename was
     mm-track-page-table-modifications-in-__apply_to_page_range-fix.patch

This patch was dropped because it was folded into mm-track-page-table-modifications-in-__apply_to_page_range.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ARCH_PAGE_TABLE_SYNC_MASK needs vmalloc.h

Link: https://lkml.kernel.org/r/20200825172508.16800a4f@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c~mm-track-page-table-modifications-in-__apply_to_page_range-fix
+++ a/mm/memory.c
@@ -73,6 +73,7 @@
 #include <linux/numa.h>
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
+#include <linux/vmalloc.h>
 
 #include <trace/events/kmem.h>
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-track-page-table-modifications-in-__apply_to_page_range.patch

