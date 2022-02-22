Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E56EC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 02:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbiBVCug (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 21:50:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiBVCug (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 21:50:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98AC25C70
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 18:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45FBF6150B
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93935C340E9;
        Tue, 22 Feb 2022 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645498209;
        bh=5/l+7O+t9ybvBFum2uMV54NbyOLdo54YMclEU5GIJa4=;
        h=Date:To:From:Subject:From;
        b=VAkee/AV3rrV+T87IcftODCt0eY6GisFvaYMarhEt4sHKCJF7/Cnfqmro65+O85kP
         4YsOUJCLDVOVk35sSgArzosTkxl0ekKNhR1y9oEOAiOsAZ+tfok595fahr5tl/d0LU
         TO9xw76CNboQ2EDOqXUHYFatGC7OyUN4JzPa2q0I=
Date:   Mon, 21 Feb 2022 18:50:09 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org, tangmeng@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-unnecessary-config_damon-option.patch added to -mm tree
Message-Id: <20220222025009.93935C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary CONFIG_DAMON option
has been added to the -mm tree.  Its filename is
     mm-damon-remove-unnecessary-config_damon-option.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-unnecessary-config_damon-option.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-unnecessary-config_damon-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: tangmeng <tangmeng@uniontech.com>
Subject: mm/damon: remove unnecessary CONFIG_DAMON option

In mm/Makefile has:
obj-$(CONFIG_DAMON) += damon/

So that we don't need 'obj-$(CONFIG_DAMON) :=' in mm/damon/Makefile,
delete it from mm/demon/Makefile.

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
mm-kfence-remove-unnecessary-config_kfence-option.patch
mm-damon-remove-unnecessary-config_damon-option.patch

