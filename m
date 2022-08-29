Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F576ECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 19:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiH2T5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 15:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiH2T5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 15:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB9D8B2FD
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 12:57:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E61960F54
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 19:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60247C433D6;
        Mon, 29 Aug 2022 19:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661803025;
        bh=6kFO5qLtc/yWvFSyG7QuvfJHonPuFfQ17N6x/I8b+F0=;
        h=Date:To:From:Subject:From;
        b=hMchtl1FDKfd0uSLBS1xuILP3bKDTB8juTTCr8+v5jzCbccX9boBohRuewlns1LEe
         C+lAaweAODqLqahPGKq2f63MoP09y+jIZygAYEBzFQtxl/6HOjpScbu2b/h/gsvatv
         x+lAjdMr+YWukln/3lQJOy/9K4cmtFYNyeZD3GbM=
Date:   Mon, 29 Aug 2022 12:57:04 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-skip-confusing-print-info.patch removed from -mm tree
Message-Id: <20220829195705.60247C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: skip confusing print info
has been removed from the -mm tree.  Its filename was
     mm-zswap-skip-confusing-print-info.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: skip confusing print info
Date: Sat, 27 Aug 2022 18:46:00 +0800

It's confusing when we disable zswap while zswap is init failed or has no
pool.  If no change required, just return directly.

Link: https://lkml.kernel.org/r/20220827104600.1813214-6-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/zswap.c~mm-zswap-skip-confusing-print-info
+++ a/mm/zswap.c
@@ -886,6 +886,15 @@ static int zswap_zpool_param_set(const c
 static int zswap_enabled_param_set(const char *val,
 				   const struct kernel_param *kp)
 {
+	bool res;
+
+	if (kstrtobool(val, &res))
+		return -EINVAL;
+
+	/* no change required */
+	if (res == *(bool *)kp->arg)
+		return 0;
+
 	if (system_state == SYSTEM_RUNNING) {
 		mutex_lock(&zswap_init_lock);
 		if (zswap_setup()) {
_

Patches currently in -mm which might be from liushixin2@huawei.com are


