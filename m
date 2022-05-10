Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86AEC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiEJEZE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236388AbiEJEXN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:23:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36C71CD248
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A74EB81AF1
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7B4C385A6;
        Tue, 10 May 2022 04:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156278;
        bh=GG1GVjZ0qFzKgtNz+yMAkOqgm+zSyZCa+WpMurO+mm0=;
        h=Date:To:From:Subject:From;
        b=Y5cVI6I+vIwl3vKFGHgXPZhu8FHmlORPGmIMVSrHALxY8UEqMhTy1bApChJLzv/7l
         FaP0HAgGC+KLakply/GVayCZ7L9ldNeKSpOjumIP46Xh/MtHyI3f1F+mm08jGEJZZs
         qxAF5lxd9e8cmVZROCENeLZRzBI4chXiCwj4d+/g=
Date:   Mon, 09 May 2022 21:17:57 -0700
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com.cn,
        thomas.orgis@uni-hamburg.de, ismael@iodev.co.uk,
        ebiederm@xmission.com, bsingharora@gmail.com, xu.xin16@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-make-taskstats-available-from-all-net-namespaces.patch removed from -mm tree
Message-Id: <20220510041758.0E7B4C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel: make taskstats available from all net namespaces
has been removed from the -mm tree.  Its filename was
     kernel-make-taskstats-available-from-all-net-namespaces.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

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


