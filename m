Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D8DC7EE23
	for <mm-commits@archiver.kernel.org>; Wed, 31 May 2023 22:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjEaWZe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 May 2023 18:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjEaWZe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 May 2023 18:25:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC4C9D
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 15:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6309063EFB
        for <mm-commits@vger.kernel.org>; Wed, 31 May 2023 22:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36ACC433D2;
        Wed, 31 May 2023 22:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685571931;
        bh=nV2FKBU6Wv31/xdVFU1jQl26mSkPqU/e9bfM+S1ZWQo=;
        h=Date:To:From:Subject:From;
        b=hMKI22GbIFPJJ/ebLsZDwML43MJYjZ63EsS4XcrOzHulhCbi8zc67qYROl+TeaWKH
         S+MYKl4mj3aLD2bu2Zm8kmFPZ4XfGhFEqAdKd5RT2L56r6oUxwxXMXOZ8CtmJFcSE/
         uSWnmcN6DHjvKnHMXF86ZiHh4FMJRKUNY0X5ViX4=
Date:   Wed, 31 May 2023 15:25:31 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-multiple-zpools-support-fix.patch added to mm-unstable branch
Message-Id: <20230531222531.B36ACC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zswap-multiple-zpools-support-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-multiple-zpools-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-multiple-zpools-support-fix.patch

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
Subject: mm-zswap-multiple-zpools-support-fix
Date: Wed May 31 03:24:44 PM PDT 2023

fix Kconfig text, per Yu Zhao

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-zswap-multiple-zpools-support-fix
+++ a/mm/Kconfig
@@ -64,7 +64,7 @@ config ZSWAP_NR_ZPOOLS_ORDER
 	default 0
 	depends on ZSWAP
 	help
-	  This options determines the number of zpools to use for zswap, it
+	  This option determines the number of zpools to use for zswap, it
 	  will be 1 << CONFIG_ZSWAP_NR_ZPOOLS_ORDER.
 
 	  Having multiple zpools helps with concurrency and lock contention
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
mm-zswap-multiple-zpools-support-fix.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

