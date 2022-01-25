Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B7CC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 06:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242167AbiAYGz2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 01:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377574AbiAYGwr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 01:52:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EDBC06F8D1
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 21:24:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 529D8CE16D0
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 05:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1902C340E0;
        Tue, 25 Jan 2022 05:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643088287;
        bh=ZF1+Zgw+gX78Hys6jwiJCdb3b6MVKySrL0QSnWRJZVY=;
        h=Date:From:To:Subject:From;
        b=rd6ODlWSWmuPfdfoKjoymVjuur3hvM5rzM7svMbxZD0cYmN2CxuTqZOaPTfbCQu5R
         5KCefwOdw2SM6Xq+4aw4UuVM195vKrEE5wqeU2VyrpeSwgIR55cdofw9/UfRgHtYck
         b+nuB+8D9us0KpDpjpR2yo0K5WwwTkUVpsuJHu6g=
Date:   Mon, 24 Jan 2022 21:24:47 -0800
From:   akpm@linux-foundation.org
To:     anton@tuxera.com, mm-commits@vger.kernel.org,
        mudongliangabcd@gmail.com
Subject:  + ntfs-add-sanity-check-on-allocation-size.patch added to
 -mm tree
Message-ID: <20220125052447.BHOp0tpNs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs: add sanity check on allocation size
has been added to the -mm tree.  Its filename is
     ntfs-add-sanity-check-on-allocation-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-add-sanity-check-on-allocation-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-add-sanity-check-on-allocation-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-add-sanity-check-on-allocation-size.patch

