Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4F5C7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 16:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjEZQwU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 May 2023 12:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjEZQwU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 May 2023 12:52:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD6DA3;
        Fri, 26 May 2023 09:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA6165185;
        Fri, 26 May 2023 16:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B146C433D2;
        Fri, 26 May 2023 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685119938;
        bh=zGWYEk1x3qBf2AwDvK7N90Iujjg9aatNtD8+Vfbxqjg=;
        h=Date:To:From:Subject:From;
        b=jGcMP5CD6y+F8PzTAPIJ6rIOACQU4UNPVx0nJZnLxmPx1Ro9cvxFM4C0Zvnd0ihPx
         JCYBX0eX3rCD1BBM4SloQjmQc/5IrWBZEWEz+jvkHYQzLnLkRcXRdL6fKWtrqkzfqa
         bTgoufjFVOV6IUi1HRoCPR/+R1g+HmBT5UNKW324=
Date:   Fri, 26 May 2023 09:52:17 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matthias.bgg@gmail.com, jhubbard@nvidia.com,
        angelogioacchino.delregno@collabora.com, haibo.li@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup_test-fix-ioctl-fail-for-compat-task.patch added to mm-hotfixes-unstable branch
Message-Id: <20230526165218.4B146C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup_test: fix ioctl fail for compat task
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-gup_test-fix-ioctl-fail-for-compat-task.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup_test-fix-ioctl-fail-for-compat-task.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Haibo Li <haibo.li@mediatek.com>
Subject: mm/gup_test: fix ioctl fail for compat task
Date: Fri, 26 May 2023 10:21:25 +0800

When tools/testing/selftests/mm/gup_test.c is compiled as 32bit, then run
on arm64 kernel, it reports "ioctl: Inappropriate ioctl for device".

Fix it by filling compat_ioctl in gup_test_fops

Link: https://lkml.kernel.org/r/20230526022125.175728-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup_test.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/gup_test.c~mm-gup_test-fix-ioctl-fail-for-compat-task
+++ a/mm/gup_test.c
@@ -381,6 +381,7 @@ static int gup_test_release(struct inode
 static const struct file_operations gup_test_fops = {
 	.open = nonseekable_open,
 	.unlocked_ioctl = gup_test_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = gup_test_release,
 };
 
_

Patches currently in -mm which might be from haibo.li@mediatek.com are

mm-gup_test-fix-ioctl-fail-for-compat-task.patch

