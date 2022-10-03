Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A67AC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJCVac (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJCV35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BEC51A23
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CBFDB815F2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077D7C433D7;
        Mon,  3 Oct 2022 21:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664832169;
        bh=Prb1rhAnNJk0EWHOov8g2jIVOwPuGBCkOGsPb2XcalM=;
        h=Date:To:From:Subject:From;
        b=DGbuuSU+boF7263AmzOkxjJiSYxgVyvvqrr6vy1563jLfGHdPV7tCkq7K0sx6LNCM
         GMyFP/ZtuoB5koj9dUIf2X70oll5HAcpbCmVysCU8uoDHcmkZ5GtWmX0ln3s2DXURy
         EwVm55CbbN9knH8ESXjMRmT0yZW2cgfcMoLmkJhI=
Date:   Mon, 03 Oct 2022 14:22:48 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        ahalaney@redhat.com, zhoujie@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20221003212249.077D7C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init/main.c: remove unnecessary (void*) conversions
has been removed from the -mm tree.  Its filename was
     init-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhou jie <zhoujie@nfschina.com>
Subject: init/main.c: remove unnecessary (void*) conversions
Date: Wed, 28 Sep 2022 09:45:39 +0800

The void pointer object can be directly assigned to different structure
objects, it does not need to be cast.

Link: https://lkml.kernel.org/r/20220928014539.11046-1-zhoujie@nfschina.com
Signed-off-by: Zhou jie <zhoujie@nfschina.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/main.c~init-remove-unnecessary-void-conversions
+++ a/init/main.c
@@ -1237,7 +1237,7 @@ __setup("initcall_blacklist=", initcall_
 static __init_or_module void
 trace_initcall_start_cb(void *data, initcall_t fn)
 {
-	ktime_t *calltime = (ktime_t *)data;
+	ktime_t *calltime = data;
 
 	printk(KERN_DEBUG "calling  %pS @ %i\n", fn, task_pid_nr(current));
 	*calltime = ktime_get();
@@ -1246,7 +1246,7 @@ trace_initcall_start_cb(void *data, init
 static __init_or_module void
 trace_initcall_finish_cb(void *data, initcall_t fn, int ret)
 {
-	ktime_t rettime, *calltime = (ktime_t *)data;
+	ktime_t rettime, *calltime = data;
 
 	rettime = ktime_get();
 	printk(KERN_DEBUG "initcall %pS returned %d after %lld usecs\n",
_

Patches currently in -mm which might be from zhoujie@nfschina.com are


