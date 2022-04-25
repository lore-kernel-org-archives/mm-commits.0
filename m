Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4A4C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 23:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiDZACj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 20:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238982AbiDZACi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 20:02:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E36120130
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 16:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5356EB81BA9
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 23:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE4C385A4;
        Mon, 25 Apr 2022 23:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650931163;
        bh=l/SoGaonfjfr4vmRpaOmzb0riaUrBpHhz3+nwHclbME=;
        h=Date:To:From:Subject:From;
        b=qvt0RcP5sCXCek+Uv2Tv6m8E+upfGFDiW4/XMKQvNeDhdW46vfArqSIiCfN95V3J8
         ldeO0FeQjYifeTV0hkCm29QBI5s3bjkrscSJdzbtV4UNxoAnI1UqjmS35fQy/AK7Sx
         4jXSLs7FJxMoqXQ+N+94Zxnke3584X9HJkGfIyQg=
Date:   Mon, 25 Apr 2022 16:59:22 -0700
To:     mm-commits@vger.kernel.org, zhengyongjun3@huawei.com,
        yajun.deng@linux.dev, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch removed from -mm tree
Message-Id: <20220425235923.17CE4C385A4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: decnet: use time_is_before_jiffies() instead of open coding it
has been removed from the -mm tree.  Its filename was
     net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Wang Qing <wangqing@vivo.com>
Subject: net: decnet: use time_is_before_jiffies() instead of open coding it

Use the helper function time_is_{before,after}_jiffies() to improve code
readability.

Link: https://lkml.kernel.org/r/1650621172-66967-11-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Zheng Yongjun <zhengyongjun3@huawei.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/decnet/dn_route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/decnet/dn_route.c~net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it
+++ a/net/decnet/dn_route.c
@@ -70,6 +70,7 @@
 #include <linux/rcupdate.h>
 #include <linux/times.h>
 #include <linux/export.h>
+#include <linux/jiffies.h>
 #include <asm/errno.h>
 #include <net/net_namespace.h>
 #include <net/netlink.h>
@@ -201,7 +202,7 @@ static void dn_dst_check_expire(struct t
 		}
 		spin_unlock(&dn_rt_hash_table[i].lock);
 
-		if ((jiffies - now) > 0)
+		if (time_is_before_jiffies(now))
 			break;
 	}
 
_

Patches currently in -mm which might be from wangqing@vivo.com are


