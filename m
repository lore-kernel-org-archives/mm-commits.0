Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B35C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiLAALg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiLAAKh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:10:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8B88DFE1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C705261E5B
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4D2C433D6;
        Thu,  1 Dec 2022 00:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852996;
        bh=WeZc8gHVyNr8Ta7PsLiGbvJ6MFTF71skayjsdAIV0fQ=;
        h=Date:To:From:Subject:From;
        b=AYHaaMmHrR2robzSzSBugSva4NXNR1jTWMmqkXCOJ7EBTjbEGAQ73fRphHTPiOTLd
         2DUcPr/iBrmUDccf1B/1VeQ96qS1tBsFxgRO5mMzMYjMaELTyC6kK81wI4RVUZnZaT
         MKQoSP8vFAk73W500wJAxYmZT4ToFBdGdlek64pY=
Date:   Wed, 30 Nov 2022 16:03:15 -0800
To:     mm-commits@vger.kernel.org, yang.yang29@zte.com,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch removed from -mm tree
Message-Id: <20221201000315.EF4D2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmscan: use sysfs_emit() to instead of scnprintf()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xu Panda <xu.panda@zte.com.cn>
Subject: mm: vmscan: use sysfs_emit() to instead of scnprintf()
Date: Thu, 24 Nov 2022 19:29:01 +0800 (CST)

Replace open-coded snprintf() with sysfs_emit() to simplify the code.

Link: https://lkml.kernel.org/r/202211241929015476424@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-use-sysfs_emit-to-instead-of-scnprintf
+++ a/mm/vmscan.c
@@ -5407,7 +5407,7 @@ static ssize_t show_enabled(struct kobje
 	if (arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG))
 		caps |= BIT(LRU_GEN_NONLEAF_YOUNG);
 
-	return snprintf(buf, PAGE_SIZE, "0x%04x\n", caps);
+	return sysfs_emit(buf, "0x%04x\n", caps);
 }
 
 /* see Documentation/admin-guide/mm/multigen_lru.rst for details */
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

relay-use-strscpy-is-more-robust-and-safer.patch

