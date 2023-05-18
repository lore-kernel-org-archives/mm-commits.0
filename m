Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F50EC77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 20:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjERUmb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 16:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjERUma (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 16:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D20EE7F
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 13:42:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADC3E65156
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 20:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2E3C433D2;
        Thu, 18 May 2023 20:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684442547;
        bh=BUHNAfqyxlTMr7F/Ownvdl54n7hoGyXYpkJR8rcVJf0=;
        h=Date:To:From:Subject:From;
        b=k6HD8Q34M9LSuJZL46mbIcXXNabdH20836z9psmVY5Ma56AWJdsowLbpwUf7/VsvM
         GjAuGB5BbHcpjzojbPmE1l3TH++H3ORMEa0553EVtWAkzHXFsoiP137UauVO6UBq6O
         ooP8T5kZkBzQ0Rer/Q6LoIzm7Ix1e8E1RMDJvnPI=
Date:   Thu, 18 May 2023 13:42:26 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de, lkp@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch added to mm-unstable branch
Message-Id: <20230518204227.0F2E3C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch

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

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
maple_tree-add-mas_next_range-and-mas_find_range-interfaces-checkpatch-fixes.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

