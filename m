Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC55C88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbjFLUrD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbjFLUqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC9B1998
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE88B6130B
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E934C433EF;
        Mon, 12 Jun 2023 20:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686602666;
        bh=ENZJ7Q0jC8FOFX4fjLjD1F6sWMyWI5TiP59+Y0k5MZk=;
        h=Date:To:From:Subject:From;
        b=c/MRqwX8vXZbuOTn7p1SyeTjNRvsdwhZqVp/6+9uaxMyjIGLIn/d8cmzCGW6TeOw+
         q4qSqtHT8T1AH/N++YCzh9GlRM5iaeQ2IRcCO88cwVMCwOJJchS4/75kCg2SYyvv6y
         aBs2paGVlKi7/hFn9vKejcxJI3HUJbmAomNF3HlI=
Date:   Mon, 12 Jun 2023 13:44:25 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch removed from -mm tree
Message-Id: <20230612204426.4E934C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix
has been removed from the -mm tree.  Its filename was
     mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch

This patch was dropped because it was folded into mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix
Date: Thu May 18 01:41:08 PM PDT 2023

make page_owner_threshold_get() and page_owner_threshold_set() static

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305190358.IEfJNraU-lkp@intel.com/
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_owner.c~mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix
+++ a/mm/page_owner.c
@@ -745,13 +745,13 @@ const struct file_operations page_owner_
 
 unsigned long page_owner_stack_threshold;
 
-int page_owner_threshold_get(void *data, u64 *val)
+static int page_owner_threshold_get(void *data, u64 *val)
 {
 	*val = page_owner_stack_threshold;
 	return 0;
 }
 
-int page_owner_threshold_set(void *data, u64 val)
+static int page_owner_threshold_set(void *data, u64 val)
 {
 	page_owner_stack_threshold = val;
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

