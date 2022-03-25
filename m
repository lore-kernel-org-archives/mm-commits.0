Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950ECC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357440AbiCYBgR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357442AbiCYBfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0EDD28984
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60C26B82727
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F87C340EE;
        Fri, 25 Mar 2022 01:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172001;
        bh=fMDCorVoQGrgboqiOK7nODTsKVujVRZ6yriWkxmrJ6U=;
        h=Date:To:From:Subject:From;
        b=CAhRulGSll1E08Ae5zRUFqdFZWJZiRtGRAQJbAEXrgl0L9IzboTENe52fSqFxUbq9
         KSIHCYe0XD1uP1+bPTSocmw0G0G28ss8hjwObX1w00lRCKd2Xw9qWlyNnPb4XHEfyt
         wpdFAdM4Z650oRgcTQhHWxiOKZZCRABRXR8XCfd8=
Date:   Thu, 24 Mar 2022 18:33:20 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, tangmeng@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-remove-unnecessary-config_damon-option.patch removed from -mm tree
Message-Id: <20220325013320.F2F87C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary CONFIG_DAMON option
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unnecessary-config_damon-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from tangmeng@uniontech.com are

mm-kasan-remove-unnecessary-config_kasan-option.patch

