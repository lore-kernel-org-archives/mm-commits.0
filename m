Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA12C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiLAAGc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:06:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiLAAEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:04:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F75E90743
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27181B81D81
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE01C43470;
        Thu,  1 Dec 2022 00:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852916;
        bh=NbkmYNQALowPCXBaBKaQy0861dYtQlSBI5gUyVc6P6M=;
        h=Date:To:From:Subject:From;
        b=AnL0zDzLibV2PWnnBl6Ec5UvibEFYQed75owSXA1t8Qc+zE4FWaWfSDXhdhttexnw
         VQ5qk0+Rb2q6dcnNqBFsUBDhzSyVRiak9VDI9pFuhaZ2xc9pRdeJ86Xf2e/v9ziR9K
         RnEex1yERhUuIGWIFWqarPPvfAwerdwFFKHkIBAU=
Date:   Wed, 30 Nov 2022 16:01:56 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-inode-remove-unnecessary-void-conversions.patch removed from -mm tree
Message-Id: <20221201000156.CCE01C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: inode: remove unnecessary (void*) conversions
has been removed from the -mm tree.  Its filename was
     hugetlbfs-inode-remove-unnecessary-void-conversions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: hugetlbfs: inode: remove unnecessary (void*) conversions
Date: Mon, 7 Nov 2022 09:56:59 +0800

The ei pointer does not need to cast the type.

Link: https://lkml.kernel.org/r/20221107015659.3221-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-inode-remove-unnecessary-void-conversions
+++ a/fs/hugetlbfs/inode.c
@@ -1279,7 +1279,7 @@ static const struct address_space_operat
 
 static void init_once(void *foo)
 {
-	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
+	struct hugetlbfs_inode_info *ei = foo;
 
 	inode_init_once(&ei->vfs_inode);
 }
_

Patches currently in -mm which might be from zeming@nfschina.com are


