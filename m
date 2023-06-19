Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A2B0EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjFSXIW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFSXIW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF34F9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:08:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2E4A60F23
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2DBC433C0;
        Mon, 19 Jun 2023 23:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216100;
        bh=p1axAiNCx0GTD2xZw0bJMh2Q6UP/PMAYJ4ZkTYqjVyk=;
        h=Date:To:From:Subject:From;
        b=e2OQG45+MPUrQFC2N7zqkxO8Cz87EurivF+q9GGbP/tZ7z23BudFKpuGd1PaXp7EV
         Bca89mXYewX99kuiOqwQQxb5+1fBoWd5K9fV1DCHSSaqXvoa+zzeK36C9DsrBV/1Z1
         xjwybbNuUmPSULujFbI8gm3DsOh3LezyqOk4U9ts=
Date:   Mon, 19 Jun 2023 16:08:19 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_isolation-write-proper-kerneldoc-fix.patch removed from -mm tree
Message-Id: <20230619230820.3A2DBC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_isolation-write-proper-kerneldoc-fix
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-write-proper-kerneldoc-fix.patch

This patch was dropped because it was folded into mm-page_isolation-write-proper-kerneldoc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_isolation-write-proper-kerneldoc-fix
Date: Fri Jun  9 02:59:37 PM PDT 2023

s/lower/first/, s/upper/last/, per Mike

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-write-proper-kerneldoc-fix
+++ a/mm/page_isolation.c
@@ -482,8 +482,8 @@ failed:
 
 /**
  * start_isolate_page_range() - mark page range MIGRATE_ISOLATE
- * @start_pfn:		The lower PFN of the range to be isolated.
- * @end_pfn:		The upper PFN of the range to be isolated.
+ * @start_pfn:		The first PFN of the range to be isolated.
+ * @end_pfn:		The last PFN of the range to be isolated.
  * @migratetype:	Migrate type to set in error recovery.
  * @flags:		The following flags are allowed (they can be combined in
  *			a bit mask)
@@ -572,8 +572,8 @@ int start_isolate_page_range(unsigned lo
 
 /**
  * undo_isolate_page_range - undo effects of start_isolate_page_range()
- * @start_pfn:		The lower PFN of the isolated range
- * @end_pfn:		The upper PFN of the isolated range
+ * @start_pfn:		The first PFN of the isolated range
+ * @end_pfn:		The last PFN of the isolated range
  * @migratetype:	New migrate type to set on the range
  *
  * This finds every MIGRATE_ISOLATE page block in the given range
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_isolation-write-proper-kerneldoc.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

