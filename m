Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8526AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Apr 2022 21:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiDVVhk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Apr 2022 17:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiDVVhi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2022 17:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDA9400EF8
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 13:38:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE3261CE4
        for <mm-commits@vger.kernel.org>; Fri, 22 Apr 2022 20:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13F2C385A0;
        Fri, 22 Apr 2022 20:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650659854;
        bh=mpZyTKfA35U3WzcEzUbh4d2AuwNpYG9XFxNt4b03vbM=;
        h=Date:To:From:Subject:From;
        b=qYvfLxVmd5aw/4P/hnCghSKWTBFOYyTYj/ri02UDLYgFAYWWlSEQ8R8300AhlAP0n
         Y0/C4rBB5Qt+IB1UyLDd6Cc3KUyZ80mc5+fn334EAigTEhjbr+3fQ5R24Qn/tvNrNR
         hKnTI6GNZTvbpCruJq4bvLx96pmCRAIuCgrcrBPI=
Date:   Fri, 22 Apr 2022 13:37:34 -0700
To:     mm-commits@vger.kernel.org, zhengyongjun3@huawei.com,
        yajun.deng@linux.dev, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, wangqing@vivo.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch added to -mm tree
Message-Id: <20220422203734.A13F2C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: net: decnet: use time_is_before_jiffies() instead of open coding it
has been added to the -mm tree.  Its filename is
     net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

block-xen-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
gpu-drm-i915-use-time_is_after_jiffies-instead-of-open-coding-it.patch
gpu-drm-radeon-use-time_is_before_jiffies-instead-of-open-coding-it.patch
hid-use-time_is_after_jiffies-instead-of-open-coding-it.patch
md-use-time_is_before_eq_jiffies-instead-of-open-coding-it.patch
net-wireless-marvell-use-time_is_before_jiffies-instead-of-open-coding-it.patch
scsi-bfa-use-time_is_before_jiffies-instead-of-open-coding-it.patch
timekeeping-use-time_is_before_jiffies-instead-of-open-coding-it.patch
net-decnet-use-time_is_before_jiffies-instead-of-open-coding-it.patch

