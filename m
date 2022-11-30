Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4875EC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiK3Xii (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:38:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiK3Xih (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:38:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEE82A72E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:38:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146A461E58
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BB4C433D6;
        Wed, 30 Nov 2022 23:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669851515;
        bh=1q1v8tGjwlSaMA/aCIgY2drccx89EXSEl2PVRS87RoU=;
        h=Date:To:From:Subject:From;
        b=DhkMuiXNiiyytnDYMofY8Py2nU/ALG3AwjWBz/nvYzXayrkwC15W1X36zUAEfkZxK
         obWaT9YnSM93GoYW8kbIpFn/POL8aFWttODAphHhwFB7o8Yi9WL5v8PrH+xoNY2NnG
         BRJZ+rkvB7k5r0PMVR3MFLbHeJLYrEHeU77NEb5M=
Date:   Wed, 30 Nov 2022 15:38:34 -0800
To:     mm-commits@vger.kernel.org, xueshuai@linux.alibaba.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        dan.j.williams@intel.com, tony.luck@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch removed from -mm tree
Message-Id: <20221130233835.46BB4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4.patch

This patch was dropped because it was folded into mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
Date: Mon, 31 Oct 2022 13:10:28 -0700

add call to kmsan_unpoison_memory(), per Miaohe Lin

Link: https://lkml.kernel.org/r/20221031201029.102123-2-tony.luck@intel.com
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/highmem.h~mm-hwpoison-try-to-recover-from-copy-on-write-faults-v4
+++ a/include/linux/highmem.h
@@ -329,6 +329,8 @@ static inline int copy_mc_user_highpage(
 	vfrom = kmap_local_page(from);
 	vto = kmap_local_page(to);
 	ret = copy_mc_to_kernel(vto, vfrom, PAGE_SIZE);
+	if (!ret)
+		kmsan_unpoison_memory(page_address(to), PAGE_SIZE);
 	kunmap_local(vto);
 	kunmap_local(vfrom);
 
_

Patches currently in -mm which might be from tony.luck@intel.com are

mm-hwpoison-try-to-recover-from-copy-on-write-faults.patch
mm-hwpoison-when-copy-on-write-hits-poison-take-page-offline.patch

