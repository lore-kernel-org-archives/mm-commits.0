Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEC1ECAAD3
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 20:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiIIUdZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 16:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiIIUcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 16:32:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EA9109D0D
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 13:32:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 649AFB82521
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 20:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E9CC433C1;
        Fri,  9 Sep 2022 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662755555;
        bh=U+1paBqKWckAzUTKd5fLD7M8YtKZXCxK/1e5/qAHbUw=;
        h=Date:To:From:Subject:From;
        b=vMDtDtS/bPNZc3gfduodyBdEWTr20zKrHMgCa5qlGfpqwYCtaMpj3vM4/s3JrHKKx
         Deo5IS+ktxhYTY3cM5sxTrzLbIwYjLuzbLsm+AHAtdVlGxfFbzMIRlLtaHJIpNPDb0
         EoDnRFMqw0qEzckXeftHAqiigomnOSddxnk7TJ38=
Date:   Fri, 09 Sep 2022 13:32:34 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        vitaly.wool@konsulko.com, sjenning@redhat.com, nathan@kernel.org,
        konrad.wilk@oracle.com, hch@lst.de, ddstreet@ieee.org,
        liushixin2@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-zswap-skip-confusing-print-info.patch removed from -mm tree
Message-Id: <20220909203234.F3E9CC433C1@smtp.kernel.org>
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
Date: Mon, 29 Aug 2022 21:23:02 +0800

It's confusing when we disable zswap while zswap init failed or has no
pool.  If no change required, just return directly.

Link: https://lkml.kernel.org/r/20220829132302.3367054-7-liushixin2@huawei.com
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

mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch
mm-thp-remove-redundant-config_transparent_hugepage.patch
mm-kmemleak-make-create_object-return-void.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch
mm-memcontrol-use-kstrtobool-for-swapaccount-param-parsing.patch

