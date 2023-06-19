Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6DAEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:27:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjFSX1T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjFSXZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:25:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AAA134
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A6360F32
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1710C433C0;
        Mon, 19 Jun 2023 23:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687217003;
        bh=iFms/6s5YcICN3MwW8ScO/GoAOGq8DpPeG3B3G7XE9s=;
        h=Date:To:From:Subject:From;
        b=TFh3SWGwTcM51GltNyXUrdB69SrF3inpHtO4epSFu5a+7nNJoVs5kmvuRYDMfYm9K
         dGWac5C6pp45c8vsWDHtmpElA6xpb0nzc6QI+PAOGkBdqLFunjd2Q7YiMncjMtkto8
         RxOo5lMGC1QkGbXTwGF5ohXFqX5B59becAUtN2+Y=
Date:   Mon, 19 Jun 2023 16:23:23 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmzone-introduce-folio_migratetype.patch removed from -mm tree
Message-Id: <20230619232323.B1710C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmzone: introduce folio_migratetype()
has been removed from the -mm tree.  Its filename was
     mmzone-introduce-folio_migratetype.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mmzone: introduce folio_migratetype()
Date: Tue, 13 Jun 2023 19:13:09 -0700

Introduce folio_migratetype() as a folio equivalent for
get_pageblock_migratetype().  This function intends to return the
migratetype the folio is located in, hence the name choice.

Link: https://lkml.kernel.org/r/20230614021312.34085-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/mmzone.h~mmzone-introduce-folio_migratetype
+++ a/include/linux/mmzone.h
@@ -105,6 +105,9 @@ extern int page_group_by_mobility_disabl
 #define get_pageblock_migratetype(page)					\
 	get_pfnblock_flags_mask(page, page_to_pfn(page), MIGRATETYPE_MASK)
 
+#define folio_migratetype(folio)				\
+	get_pfnblock_flags_mask(&folio->page, folio_pfn(folio),		\
+			MIGRATETYPE_MASK)
 struct free_area {
 	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

afs-fix-dangling-folio-ref-counts-in-writeback.patch
afs-fix-waiting-for-writeback-then-skipping-folio.patch

