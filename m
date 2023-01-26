Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B46C54E94
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 01:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjAZBY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Jan 2023 20:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbjAZBYw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2023 20:24:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F38D180
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2023 17:24:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C329ECE224F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 01:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFECCC433EF;
        Thu, 26 Jan 2023 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674696288;
        bh=m4a2Nl0GPZSiLGh45bYBbogBlOJV3qgTjy83pz2PLPY=;
        h=Date:To:From:Subject:From;
        b=wH6WM4ZJzT31z4u92o+M1FoSMT/8rKZF8PyuvJurd+C4N4a0PzwSpvGY7VI4d2hr9
         dHnqsbr/Oz2piX7P29NzxvSuAaGXmGyhSsXf1b0XwgstIEFCFB8zfpS2D/w6BTrQSK
         wAgKp3ds7X6pcdVGKNzkqRwu4c5iJSqrBgy95dR4=
Date:   Wed, 25 Jan 2023 17:24:47 -0800
To:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        senozhatsky@chromium.org, minchan@kernel.org, kbusch@kernel.org,
        ira.weiny@intel.com, hch@lst.de, dave.jiang@intel.com,
        dan.j.williams@intel.com, axboe@kernel.dk,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-the-swap_readpage-return-value-fix.patch added to mm-unstable branch
Message-Id: <20230126012447.DFECCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-the-swap_readpage-return-value-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-the-swap_readpage-return-value-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-the-swap_readpage-return-value-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-remove-the-swap_readpage-return-value-fix
Date: Wed Jan 25 05:23:19 PM PST 2023

fix void-returning swap_readpage() stub, per Keith

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/swap.h~mm-remove-the-swap_readpage-return-value-fix
+++ a/mm/swap.h
@@ -66,7 +66,6 @@ struct swap_iocb;
 static inline void swap_readpage(struct page *page, bool do_poll,
 		struct swap_iocb **plug)
 {
-	return 0;
 }
 static inline void swap_write_unplug(struct swap_iocb *sio)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-mremap-fix-mremap-expanding-for-vmas-with-vm_ops-close-checkpatch-fixes.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch

