Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF5CC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 17:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiCAR3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 12:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233369AbiCAR3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 12:29:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A54E21BF
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 09:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6EBC61212
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 17:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10073C340EE;
        Tue,  1 Mar 2022 17:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646155739;
        bh=fVMZ8SDZ9y/478J8YccMIigogmGtK7G7YQTUIx3K9AM=;
        h=Date:To:From:Subject:From;
        b=VIZCD8h8yjzVBEo1KvIXJ37Y84YfpzjtP9J1Bvpg6oLR+W8sP19C1DNHP1y5iy4h8
         18v2zPvQLMvdOSVy2FFpG6RLbzix3xqbXPVnCk7OZbRNsPHb4dporoLk+bQ1bIGXws
         bFt7CUbnikS0jg365IOxjXeyue63OIAbli+hWJJo=
Date:   Tue, 01 Mar 2022 09:28:58 -0800
To:     mm-commits@vger.kernel.org, zhangyinan2019@email.szu.edu.cn,
        weizhenliang@huawei.com, sfr@canb.auug.org.au,
        caoyixuan2019@email.szu.edu.cn, yejiajian2018@email.szu.edu.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-page_owner_sortc-fix-comments.patch added to -mm tree
Message-Id: <20220301172859.10073C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix comments
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-fix-comments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-fix-comments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-fix-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Subject: tools/vm/page_owner_sort.c: fix comments

Two adjustments are made:

1. Correct a grammatical error: replace the "what" in "Do the job what
   you want to debug" with "that".

2. Replace "has not been" with "has been" in the description of the -f
   option: According to Commit b1c9ba071e7d ("tools/vm/page_owner_sort.c:
   fix the instructions for use"), the description of the "-f" option is
   "Filter out the information of blocks whose memory has been released."

Link: https://lkml.kernel.org/r/20220301151438.166118-1-yejiajian2018@email.szu.edu.cn
Signed-off-by: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yinan Zhang <zhangyinan2019@email.szu.edu.cn>
Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/vm/page_owner.rst~tools-vm-page_owner_sortc-fix-comments
+++ a/Documentation/vm/page_owner.rst
@@ -78,7 +78,7 @@ Usage
 
 2) Enable page owner: add "page_owner=on" to boot cmdline.
 
-3) Do the job what you want to debug
+3) Do the job that you want to debug.
 
 4) Analyze information from page owner::
 
@@ -126,4 +126,4 @@ Usage
 		-c		Cull by comparing stacktrace instead of total block.
 
 	Filter:
-		-f		Filter out the information of blocks whose memory has not been released.
+		-f		Filter out the information of blocks whose memory has been released.
_

Patches currently in -mm which might be from yejiajian2018@email.szu.edu.cn are

tools-vm-page_owner_sortc-fix-comments.patch
tools-vm-page_owner_sortc-add-a-security-check.patch
tools-vm-page_owner_sortc-support-sorting-by-tgid-and-update-documentation.patch

