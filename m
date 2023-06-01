Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FF0C77B7A
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jun 2023 22:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjFAWVN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Jun 2023 18:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbjFAWVM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Jun 2023 18:21:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92544189
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 15:21:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26A9E64A7A
        for <mm-commits@vger.kernel.org>; Thu,  1 Jun 2023 22:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E2DC433D2;
        Thu,  1 Jun 2023 22:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685658070;
        bh=IXIy5DJa2DnE1UBwN7PLPZ6HoTbrYvU4bMwnQDyPKPo=;
        h=Date:To:From:Subject:From;
        b=pcsVrpTgMSuV4Hc5Yo2yTcVZpoUhgsl5eiseffYv1cMV4Ibx2A85XUC5eKnPJp2/M
         U+DMSBzSXL9zeBGodU83z5tI7XAolELtHGeroaz7tjo6hMNc80+w04G8NV1Q7x/n1e
         Ck4lqmvHPnVJCtTbphwStQqcKlbFFryK4XR2zqJE=
Date:   Thu, 01 Jun 2023 15:21:09 -0700
To:     mm-commits@vger.kernel.org, haifeng.xu@shopee.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-reset_node_present_pages-fix.patch added to mm-unstable branch
Message-Id: <20230601222110.77E2DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mm_initc-remove-reset_node_present_pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-reset_node_present_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-reset_node_present_pages-fix.patch

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
Subject: mm-mm_initc-remove-reset_node_present_pages-fix
Date: Thu Jun  1 03:20:17 PM PDT 2023

fix comment layout

Cc: Haifeng Xu <haifeng.xu@shopee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-reset_node_present_pages-fix
+++ a/mm/mm_init.c
@@ -1523,7 +1523,8 @@ void __ref free_area_init_core_hotplug(s
 		memset(p, 0, sizeof(*p));
 	}
 
-	/* When memory is hot-added, all the memory is in offline state. So
+	/*
+	 * When memory is hot-added, all the memory is in offline state. So
 	 * clear all zones' present_pages and managed_pages because they will
 	 * be updated in online_pages() and offline_pages().
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

zswap-do-not-shrink-if-cgroup-may-not-zswap-fix.patch
zswap-do-not-shrink-if-cgroup-may-not-zswap-fix-fix.patch
mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-mm_initc-remove-reset_node_present_pages-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

