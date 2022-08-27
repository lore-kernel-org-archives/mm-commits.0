Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82BEBECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 01:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345132AbiH0Bm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Aug 2022 21:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiH0Bmw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 Aug 2022 21:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B937AEC4CE
        for <mm-commits@vger.kernel.org>; Fri, 26 Aug 2022 18:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 345F7B83115
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 01:42:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7033C433B5;
        Sat, 27 Aug 2022 01:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661564568;
        bh=6QRrQV3/nwSidHeBt6+IZRxdnLog8CCm/o58NWqWHx4=;
        h=Date:To:From:Subject:From;
        b=xr6rZY1SKbm0TANDTSVuu+X5SBdFephEoS3Lm2ymxPPZ/b8bbiulKPhgaUooiN6zD
         IVjCgwObGIUPj51TlZQmPWb8QJwnUzdfN03DZfsFrP523LDvLDSxpWiyeqPD+/1/Ho
         P5yv/lPWnVlpydfOPIWP+lzQLlvDWmffo4Yn2Guk=
Date:   Fri, 26 Aug 2022 18:42:48 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        sjenning@redhat.com, ddstreet@ieee.org, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-zswap-skip-confusing-print-info.patch removed from -mm tree
Message-Id: <20220827014248.C7033C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/zswap: skip confusing print info
has been removed from the -mm tree.  Its filename was
     mm-zswap-skip-confusing-print-info.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/zswap: skip confusing print info
Date: Thu, 25 Aug 2022 22:20:37 +0800

It's confusing when we disable zswap while zswap is init failed or has no
pool.  If no change required, just return directly.

Link: https://lkml.kernel.org/r/20220825142037.3214152-4-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
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

bootmem-remove-the-vmemmap-pages-from-kmemleak-in-put_page_bootmem.patch

