Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08244ECAAD3
	for <mm-commits@archiver.kernel.org>; Sun,  4 Sep 2022 18:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiIDSWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 4 Sep 2022 14:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIDSWq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 4 Sep 2022 14:22:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0A12F017
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 11:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 329E5B80D5A
        for <mm-commits@vger.kernel.org>; Sun,  4 Sep 2022 18:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A04C433C1;
        Sun,  4 Sep 2022 18:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662315762;
        bh=08kMWDW6ID0zE3DO0yPHSeAXdfcHcUSi2+UBHLqrYJY=;
        h=Date:To:From:Subject:From;
        b=t5BOCMp0akW5P8qsFy12dM4aas+P5YZFeKu0b+rJfiwOojeY2cWM7WbK8/op7Y1WD
         qHS+lcJYkVCceqqfcpR4kSlzIrdBmRz5H4YsXY3gV6g/MiTzKfZAZbOnytTTYPFYSE
         jr/Aib6s/m+dzPnGIvGvYXvtPAwLprVP6VZAEUvo=
Date:   Sun, 04 Sep 2022 11:22:41 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        mcgrof@kernel.org, akpm@linux-foudation.org, wuchi.zero@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + latencytop-use-the-last-element-of-latency_record-of-system.patch added to mm-nonmm-unstable branch
Message-Id: <20220904182242.C9A04C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: latencytop: use the last element of latency_record of system
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     latencytop-use-the-last-element-of-latency_record-of-system.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/latencytop-use-the-last-element-of-latency_record-of-system.patch

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
From: wuchi <wuchi.zero@gmail.com>
Subject: latencytop: use the last element of latency_record of system
Date: Sat, 3 Sep 2022 21:52:33 +0800

In account_global_scheduler_latency(), when we don't find the matching
latency_record we try to select one which is unused in
latency_record[MAXLR], but the condition will skip the last one.

if (i >= MAXLR-1)

Fix that.

Link: https://lkml.kernel.org/r/20220903135233.5225-1-wuchi.zero@gmail.com
Signed-off-by: wuchi <wuchi.zero@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foudation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/latencytop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/latencytop.c~latencytop-use-the-last-element-of-latency_record-of-system
+++ a/kernel/latencytop.c
@@ -112,7 +112,7 @@ static void __sched
 account_global_scheduler_latency(struct task_struct *tsk,
 				 struct latency_record *lat)
 {
-	int firstnonnull = MAXLR + 1;
+	int firstnonnull = MAXLR;
 	int i;
 
 	/* skip kernel threads for now */
@@ -150,7 +150,7 @@ account_global_scheduler_latency(struct
 	}
 
 	i = firstnonnull;
-	if (i >= MAXLR - 1)
+	if (i >= MAXLR)
 		return;
 
 	/* Allocted a new one: */
_

Patches currently in -mm which might be from wuchi.zero@gmail.com are

lib-debugobjects-fix-stat-count-and-optimize-debug_objects_mem_init.patch
initramfs-mask-my_inptr-as-__initdata.patch
profile-simplify-redundant-code-in-profile_setup.patch
latencytop-use-the-last-element-of-latency_record-of-system.patch

