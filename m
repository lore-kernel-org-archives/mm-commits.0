Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9C6C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiDZACZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiDZACX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE09113C89
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ACD1615BB
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99018C385A7;
        Mon, 25 Apr 2022 23:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931157;
        bh=iXhw3dSpL9n0gQlFW5xiclCFnDINgcM/PT0iUwydylk=;
        h=Date:To:From:Subject:From;
        b=N68M4SOVQLyIiwWWWkOZXN1W7FE54WKbWykRu/BtCSydqI6sHs393z19SYxbCBQS1
         VufZPCTIHsasbm7wFzouAQurcdG5vKiSeVJHdNhDxQtagZUX33/aViThNwIw8llLkF
         3SmCOOk2WEvElvykdr730weRuEuz0Oo+23S//T7s=
Date:   Mon, 25 Apr 2022 16:59:16 -0700
To:     mm-commits@vger.kernel.org, xiang.ye@intel.com,
        srinivas.pandruvada@linux.intel.com, srinivas.pandruvada@intel.com,
        jikos@kernel.org, even.xu@intel.com, benjamin.tissoires@redhat.com,
        wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235917.99018C385A7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hid: use time_is_after_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: hid: use time_is_after_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-5-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Even Xu <even.xu@intel.com>
Cc: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
Cc: Ye Xiang <xiang.ye@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/intel-ish-hid/ipc/ipc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/intel-ish-hid/ipc/ipc.c~hid-use-time_is_after_jiffies-instead-of-open-coding-it
+++ a/drivers/hid/intel-ish-hid/ipc/ipc.c
@@ -578,7 +578,7 @@ static void _ish_sync_fw_clock(struct is
 	static unsigned long	prev_sync;
 	uint64_t	usec;
 
-	if (prev_sync && jiffies - prev_sync < 20 * HZ)
+	if (prev_sync && time_is_after_jiffies(prev_sync + 20 * HZ))
 		return;
 
 	prev_sync = jiffies;
_

Patches currently in -mm which might be from wangqing@vivo.com are

md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

