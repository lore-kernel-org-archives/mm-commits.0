Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366ECC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbiBVDpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:45:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbiBVDpx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:45:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ACF24BD7
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 517E2CE1292
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81ACC340E8;
        Tue, 22 Feb 2022 03:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645501524;
        bh=Oi6PJRFc4hUVd28Pp9K+f9vaKNsL/6aQfWxUAv3zI7c=;
        h=Date:To:From:Subject:From;
        b=fY8BtY/D5R6uBqJLprCkjht8faFRPyhjap0/P3QCVlO0QEm3YardHG3uo2mmRfCBW
         sx/80fZRC6K4RyYvqcGNX6XwmM5+V7yhbpD17PFTUW6YRtUJsvV29fTqyGvSAd/HJ6
         Fe5a2b7RV7v7IXUcP19o+N5E8aWIGn+YYRgeuj+I=
Date:   Mon, 21 Feb 2022 19:45:24 -0800
To:     mm-commits@vger.kernel.org, xu.xin16@zte.com.cn,
        edumazet@google.com, ebiederm@xmission.com,
        deng.changcheng@zte.com.cn, davem@davemloft.net,
        bsingharora@gmail.com, cgel.zte@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-make-taskstats-available-via-genetlink-per-namespace.patch added to -mm tree
Message-Id: <20220222034524.A81ACC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/taskstats.c: make taskstats available via genetlink per namespace
has been added to the -mm tree.  Its filename is
     kernel-make-taskstats-available-via-genetlink-per-namespace.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-make-taskstats-available-via-genetlink-per-namespace.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-make-taskstats-available-via-genetlink-per-namespace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-make-taskstats-available-via-genetlink-per-namespace.patch

