Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C48FC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbiDZACV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiDZACV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A850120112
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCC3C615BB
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31987C385A7;
        Mon, 25 Apr 2022 23:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931154;
        bh=dTrSBi6gxyzfeJ0HksjETvybIS/xrgGdv2OeGAlZ/Es=;
        h=Date:To:From:Subject:From;
        b=GpqImJtq83yIKDyKGGCLAmlG64Lec+G/f8HR44XQ8VSoEg7g67Do7E7mrJokp7PFz
         kX2l4val46U4aGDVgL5Vk4ZEv8T3w+eHb+1q8R0jOrbrNR3SjnlgUw4UGbX+JOpo+k
         mg4LS1hh3gk+X/5kHHPw5imdc2sD8VS5iUqObXsY=
Date:   Mon, 25 Apr 2022 16:59:13 -0700
To:     mm-commits@vger.kernel.org, roger.pau@citrix.com, axboe@kernel.dk,
        wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235914.31987C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: block: xen: use time_is_before_eq_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: block: xen: use time_is_before_eq_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-2-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: "Roger Pau Monné" <roger.pau@citrix.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/xen-blkback/blkback.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/xen-blkback/blkback.c~block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it
+++ a/drivers/block/xen-blkback/blkback.c
@@ -42,6 +42,7 @@
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/bitmap.h>
+#include <linux/jiffies.h>
 
 #include <xen/events.h>
 #include <xen/page.h>
@@ -134,8 +135,8 @@ module_param(log_stats, int, 0644);
 
 static inline bool persistent_gnt_timeout(struct persistent_gnt *persistent_gnt)
 {
-	return pgrant_timeout && (jiffies - persistent_gnt->last_used >=
-			HZ * pgrant_timeout);
+	return pgrant_timeout && time_is_before_eq_jiffies(
+			persistent_gnt->last_used + HZ * pgrant_timeout);
 }
 
 #define vaddr(page) ((unsigned long)pfn_to_kaddr(page_to_pfn(page)))
_

Patches currently in -mm which might be from wangqing@vivo.com are

gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch
hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

