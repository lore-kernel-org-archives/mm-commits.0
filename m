Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C4DC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiCVVuo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiCVVuk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:50:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8508851E43
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 214B361760
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C665C340EC;
        Tue, 22 Mar 2022 21:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985750;
        bh=vGh/cA9ETOpoqUVsqzO3raaf979clIRiwEjeafO+Rhk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=iFla/ExxmqochfChrM+GpP2ZDNZ8/Ih6VEml0O5WqSj53lcViEFLJPCKDoK+SCZ3j
         1OAy+1tIkN0yIZqoh7I9Hv6vBVLi/o+XpFbz3nqBt0c8XAr0VGytOxw4bwhgVsU7xx
         iusNP0Fr64aaJrRwraJxXN8IK4PHVlBkkYNokNvM=
Date:   Tue, 22 Mar 2022 14:49:09 -0700
To:     sj@kernel.org, tangmeng@uniontech.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 210/227] mm/damon: remove unnecessary CONFIG_DAMON option
Message-Id: <20220322214910.7C665C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: tangmeng <tangmeng@uniontech.com>
Subject: mm/damon: remove unnecessary CONFIG_DAMON option

In mm/Makefile has:
obj-$(CONFIG_DAMON) += damon/

So that we don't need 'obj-$(CONFIG_DAMON) :=' in mm/damon/Makefile,
delete it from mm/damon/Makefile.

Link: https://lkml.kernel.org/r/20220221065255.19991-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Makefile~mm-damon-remove-unnecessary-config_damon-option
+++ a/mm/damon/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_DAMON)		:= core.o
+obj-y				:= core.o
 obj-$(CONFIG_DAMON_VADDR)	+= ops-common.o vaddr.o
 obj-$(CONFIG_DAMON_PADDR)	+= ops-common.o paddr.o
 obj-$(CONFIG_DAMON_DBGFS)	+= dbgfs.o
_
