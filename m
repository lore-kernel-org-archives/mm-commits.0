Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D58C88CB7
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbjFLUq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjFLUqq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:46:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FCA1996
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B23A062026
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1116EC433D2;
        Mon, 12 Jun 2023 20:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686602624;
        bh=y+s2qs3gwE0c66oWyzwLJsoLd35YapzXWLi137JuJaU=;
        h=Date:To:From:Subject:From;
        b=E9yyY3/cU9wxs5u3GxwLwCStF/lBgi1SdOSZ3QYnA/+WSBKMiI43u5D6E7MB35OzC
         qns8ExhOHUby38xMTw7KcsqUpIMQHra3bHq0kLK2mu5dZG7aQNQZ048Ea6x86zXz4t
         te/8pW75Lq4REywGnTIU/rASAMXnoIynrX54F3vY=
Date:   Mon, 12 Jun 2023 13:43:43 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch removed from -mm tree
Message-Id: <20230612204344.1116EC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch

This patch was dropped because it was folded into mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
Date: Wed May 17 12:58:14 PM PDT 2023

build fix

include/linux/stackdepot.h:116:26: error: declaration of 'struct seq_file' will not be visible outside of this function

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202305171411.iw7APiY8-lkp@intel.com/
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/stackdepot.h~mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix
+++ a/include/linux/stackdepot.h
@@ -25,6 +25,7 @@
 #include <linux/gfp.h>
 
 typedef u32 depot_stack_handle_t;
+struct seq_file;
 
 /*
  * Number of bits in the handle that stack depot doesn't use. Users may store
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch

