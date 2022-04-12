Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA60FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiDLXTl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiDLXTb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:19:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293328FE47
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:07:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1AC961CB3
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 21:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238FDC385A5;
        Tue, 12 Apr 2022 21:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649798976;
        bh=abWHa3tXDjB6qys0Elvvw2D83OUAUqjHeeGlV2teoO4=;
        h=Date:To:From:Subject:From;
        b=W1vl9VmTR0+Mk9sBznPd6qcUpU3mdauTXeGEgXtyoBb/V0e9LJMMZ3CFUUaJD9Tgl
         oIDTWQZUm0yzGPcwW4v970Xwp0ITTBmtYubJp0LFUBxygXOJeZe4UukhaIAP1Wgnq4
         985IyyhysXnbBzKei51DJGTbeLN6IKw0hHaEgIJM=
Date:   Tue, 12 Apr 2022 14:29:35 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        thomas.orgis@uni-hamburg.de, ismael@iodev.co.uk,
        ebiederm@xmission.com, bsingharora@gmail.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-make-taskstats-available-from-all-net-namespaces.patch added to -mm tree
Message-Id: <20220412212936.238FDC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: make taskstats available from all net namespaces
has been added to the -mm tree.  Its filename is
     kernel-make-taskstats-available-from-all-net-namespaces.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-make-taskstats-available-from-all-net-namespaces.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-make-taskstats-available-from-all-net-namespaces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: kernel: make taskstats available from all net namespaces

If getdelays runs in a non-init network namespace, it will fail in getting
delayacct stats even if it has privilege of root user, which seems to be
not very reasonable.  We can simply reproduce this by executing commands:

	unshare -n
	getdelays -d -p <pid>

I don't think net namespace should be an obstacle to the normal execution
of getdelay function.  So let's make it available from all net namespaces.

Link: https://lkml.kernel.org/r/20220412071946.2532318-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ismael Luceno <ismael@iodev.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/kernel/taskstats.c~kernel-make-taskstats-available-from-all-net-namespaces
+++ a/kernel/taskstats.c
@@ -688,6 +688,7 @@ static struct genl_family family __ro_af
 	.module		= THIS_MODULE,
 	.ops		= taskstats_ops,
 	.n_ops		= ARRAY_SIZE(taskstats_ops),
+	.netnsok	= true,
 };
 
 /* Needed early in initialization */
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are

ksm-count-ksm-merging-pages-for-each-process.patch
kernel-make-taskstats-available-from-all-net-namespaces.patch

