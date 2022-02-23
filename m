Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D2AC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Feb 2022 03:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236858AbiBWDzC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Feb 2022 22:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiBWDzC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Feb 2022 22:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637C66663E
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 19:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F39BF61794
        for <mm-commits@vger.kernel.org>; Wed, 23 Feb 2022 03:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CF0C340E7;
        Wed, 23 Feb 2022 03:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645588474;
        bh=71sqnQGBmPxeydas5pQGQfgtt8rgaeZ+Fsh1+4wXZ0Y=;
        h=Date:To:From:Subject:From;
        b=NMxJn1Ein2WoDkkiePgactpTZ+/j65mcH+elzG3VO0WsrM1A5xFc3RPwCaiJ8UXcA
         dMtLKmge9nLOcyC2lAJ/07zRDby2vZSV5JbrkkgWBxWTYiMv6PvVYpEe0ljN4q0h2U
         oqEEsMMC2MK8yEugo6Yv9TxyW25mbTWfBd4Oih5k=
Date:   Tue, 22 Feb 2022 19:54:33 -0800
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn,
        edumazet@google.com, ebiederm@xmission.com,
        deng.changcheng@zte.com.cn, davem@davemloft.net,
        bsingharora@gmail.com, cgel.zte@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] kernel-make-taskstats-available-via-genetlink-per-namespace.patch removed from -mm tree
Message-Id: <20220223035434.53CF0C340E7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/taskstats.c: make taskstats available via genetlink per namespace
has been removed from the -mm tree.  Its filename was
     kernel-make-taskstats-available-via-genetlink-per-namespace.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: xu xin <cgel.zte@gmail.com>
Subject: kernel/taskstats.c: make taskstats available via genetlink per namespace

Currently, the application getdelays cannot get taskstats in a net
namespace.  The returned error is just like the following:

-sh-4.4# ps -ef | tail -5
root       186     2  0 09:23 ?        00:00:00 [kworker/2:1H]
root       187     2  0 09:23 ?        00:00:00 [kworker/0:2-eve]
root       190   183  0 09:23 ?        00:00:00 -sh
root       198   190  0 09:25 ?        00:00:00 ps -ef
root       199   190  0 09:25 ?        00:00:00 tail -5
-sh-4.4#
-sh-4.4# ./getdelays -d -p 186 -v
print delayacct stats ON
debug on
Error getting family id, errno 0

As more and more applications are deployed in containers like Docker, it
is necessary to support getdelays to be used in net namespace.  Taskstats
is safe for use per namespace as genetlink checks the capability of
namespace message by netlink_ns_capable().

Make taskstats available via genetlink per namespace.

Link: https://lkml.kernel.org/r/20220221032202.1925507-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reported-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/taskstats.c~kernel-make-taskstats-available-via-genetlink-per-namespace
+++ a/kernel/taskstats.c
@@ -664,6 +664,7 @@ static struct genl_family family __ro_af
 	.module		= THIS_MODULE,
 	.ops		= taskstats_ops,
 	.n_ops		= ARRAY_SIZE(taskstats_ops),
+	.netnsok	= true,
 };
 
 /* Needed early in initialization */
_

Patches currently in -mm which might be from cgel.zte@gmail.com are


