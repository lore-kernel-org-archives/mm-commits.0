Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C6CC77B7A
	for <mm-commits@archiver.kernel.org>; Wed,  7 Jun 2023 20:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjFGUAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjFGUAU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jun 2023 16:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6A32103;
        Wed,  7 Jun 2023 13:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ABB564346;
        Wed,  7 Jun 2023 20:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4A8C433D2;
        Wed,  7 Jun 2023 20:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686168013;
        bh=yn3j5tAvzQICoFTrDHE6HR3rnA7bGUvGW0u1p1VksSw=;
        h=Date:To:From:Subject:From;
        b=C+SDVMDyPKyncdhuwfwTyRv44i73kd63xQj8cwbMLjOTeuIZJQCJYoXSRIPB2nr0h
         ZFk52Rt7+xkU1vi8AEXexrn7jl+aY94jXfu9hPe43V51wSHO1lUD86YL6VeNqdd6t9
         oNeYUnFP+QYkKX2cSfMMjPbWfC5T9vvyWXyMIHmA=
Date:   Wed, 07 Jun 2023 13:00:13 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        matthias.bgg@gmail.com, jhubbard@nvidia.com, david@redhat.com,
        angelogioacchino.delregno@collabora.com, haibo.li@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-gup_test-fix-ioctl-fail-for-compat-task.patch removed from -mm tree
Message-Id: <20230607200013.AB4A8C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup_test: fix ioctl fail for compat task
has been removed from the -mm tree.  Its filename was
     mm-gup_test-fix-ioctl-fail-for-compat-task.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haibo Li <haibo.li@mediatek.com>
Subject: mm/gup_test: fix ioctl fail for compat task
Date: Fri, 26 May 2023 10:21:25 +0800

When tools/testing/selftests/mm/gup_test.c is compiled as 32bit, then run
on arm64 kernel, it reports "ioctl: Inappropriate ioctl for device".

Fix it by filling compat_ioctl in gup_test_fops

Link: https://lkml.kernel.org/r/20230526022125.175728-1-haibo.li@mediatek.com
Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Acked-by: David Hildenbrand <david@redhat.com>
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


