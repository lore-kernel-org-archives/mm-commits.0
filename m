Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D2CC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 23:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiKOXCM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 18:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238691AbiKOXCE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 18:02:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8432F2C664
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 15:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2506FB81B91
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 23:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA1BC433D6;
        Tue, 15 Nov 2022 23:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668553320;
        bh=+RMzbpdWEFsdy4RY5i9NQ+QqYNzVuo7Z+62iWcmli+g=;
        h=Date:To:From:Subject:From;
        b=qTJVMzxc7v/4nIePU4mYh2idV3Mra6/LZ1T2YRHOcsHRymwbcWdR0/D8UzNHPnvW8
         IwPnIX6W3s5NqUa2onr1CaKf/YSB77b9S6SGl7JmKj5zi6S+eWx4gSyq4XBzX6Aya9
         d0xaItBi4xIafPAKbFuPpYFr2VdO22U16c9thZ+k=
Date:   Tue, 15 Nov 2022 15:02:00 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, zeming@nfschina.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlbfs-inode-remove-unnecessary-void-conversions.patch added to mm-unstable branch
Message-Id: <20221115230200.BDA1BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: inode: remove unnecessary (void*) conversions
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlbfs-inode-remove-unnecessary-void-conversions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlbfs-inode-remove-unnecessary-void-conversions.patch

This patch will later appear in the mm-unstable branch at
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

hugetlbfs-inode-remove-unnecessary-void-conversions.patch

