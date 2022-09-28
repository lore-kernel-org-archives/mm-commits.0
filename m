Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C04C54EE9
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 15:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiI1PBY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiI1PBJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 11:01:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4769618E1C
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 08:01:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB6FDB820C5
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 15:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD8FC433D6;
        Wed, 28 Sep 2022 15:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664377262;
        bh=GEdNaM5DdCQTkh9Hfa0oU3VOu+l1qyGW10wGHkXVbI0=;
        h=Date:To:From:Subject:From;
        b=B4D01nars5drnR9+EMr5S4CQGmXZktRCpmiZ2nI7S8eV2GKBLLYSmdrp6GHyhFN3U
         Arv5aq0i2zQBrXhatkk5jrp4Lz/xWOcx+V0bOhi8WhGVaD+buAR5Lj3uOy2e3Z/yTV
         nv8DME/7OVwjV9ETMQkmOUV7n4s3zQSHMC/3qbmU=
Date:   Wed, 28 Sep 2022 08:00:54 -0700
To:     mm-commits@vger.kernel.org, zhoujie@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + init-remove-unnecessary-void-conversions.patch added to mm-nonmm-unstable branch
Message-Id: <20220928150102.5DD8FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: remove unnecessary (void*) conversions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-remove-unnecessary-void-conversions.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Zhou jie <zhoujie@nfschina.com>
Subject: init/main.c: remove unnecessary (void*) conversions
Date: Wed, 28 Sep 2022 09:45:39 +0800

The void pointer object can be directly assigned to different structure
objects, it does not need to be cast.

Link: https://lkml.kernel.org/r/20220928014539.11046-1-zhoujie@nfschina.com
Signed-off-by: Zhou jie <zhoujie@nfschina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/init/main.c~init-remove-unnecessary-void-conversions
+++ a/init/main.c
@@ -1248,7 +1248,7 @@ __setup("initcall_blacklist=", initcall_
 static __init_or_module void
 trace_initcall_start_cb(void *data, initcall_t fn)
 {
-	ktime_t *calltime = (ktime_t *)data;
+	ktime_t *calltime = data;
 
 	printk(KERN_DEBUG "calling  %pS @ %i\n", fn, task_pid_nr(current));
 	*calltime = ktime_get();
@@ -1257,7 +1257,7 @@ trace_initcall_start_cb(void *data, init
 static __init_or_module void
 trace_initcall_finish_cb(void *data, initcall_t fn, int ret)
 {
-	ktime_t rettime, *calltime = (ktime_t *)data;
+	ktime_t rettime, *calltime = data;
 
 	rettime = ktime_get();
 	printk(KERN_DEBUG "initcall %pS returned %d after %lld usecs\n",
_

Patches currently in -mm which might be from zhoujie@nfschina.com are

init-remove-unnecessary-void-conversions.patch

