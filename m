Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DAEC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357324AbiCYBbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357319AbiCYBbO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C7E289AF
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:29:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B47E9B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54163C340ED;
        Fri, 25 Mar 2022 01:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171779;
        bh=7moTntyg6RP3zXtioANaPwDNRkOCV8D+ugAX4EIAfzA=;
        h=Date:To:From:Subject:From;
        b=Ul51bzbPIRZi5YiAEs4clpqbAPO/SYndafawNgr6+KpOlBCgmuJV+dfoBlPyiIEJ2
         LOP1TmwyksuIvgxEwU6Oru44/5s8MDeJb5+4EAdnBH6Jw03ojK3ZE0HwhDdPEWY4g8
         pEsp9N3pH5YVgrlPTlONalVm8YRprm0fG1zboDG4=
Date:   Thu, 24 Mar 2022 18:29:38 -0700
To:     mm-commits@vger.kernel.org, anton@tuxera.com,
        mudongliangabcd@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ntfs-add-sanity-check-on-allocation-size.patch removed from -mm tree
Message-Id: <20220325012939.54163C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: add sanity check on allocation size
has been removed from the -mm tree.  Its filename was
     ntfs-add-sanity-check-on-allocation-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dongliang Mu <mudongliangabcd@gmail.com>
Subject: ntfs: add sanity check on allocation size

ntfs_read_inode_mount invokes ntfs_malloc_nofs with zero allocation size. 
It triggers one BUG in the __ntfs_malloc function.

Fix this by adding sanity check on ni->attr_list_size.

Link: https://lkml.kernel.org/r/20220120094914.47736-1-dzm91@hust.edu.cn
Reported-by: syzbot+3c765c5248797356edaa@syzkaller.appspotmail.com
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Acked-by: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ntfs/inode.c~ntfs-add-sanity-check-on-allocation-size
+++ a/fs/ntfs/inode.c
@@ -1881,6 +1881,10 @@ int ntfs_read_inode_mount(struct inode *
 		}
 		/* Now allocate memory for the attribute list. */
 		ni->attr_list_size = (u32)ntfs_attr_size(a);
+		if (!ni->attr_list_size) {
+			ntfs_error(sb, "Attr_list_size is zero");
+			goto put_err_out;
+		}
 		ni->attr_list = ntfs_malloc_nofs(ni->attr_list_size);
 		if (!ni->attr_list) {
 			ntfs_error(sb, "Not enough memory to allocate buffer "
_

Patches currently in -mm which might be from mudongliangabcd@gmail.com are


