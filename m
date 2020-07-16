Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC55C433E2
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D332071B
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 00:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594860132;
	bh=pXYWeFmAhUqKs3WFhgza1Et7LRBB6HzUBNYGRCiNV/k=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=nL1YkXTBS70e/AjqP7sMhACH1I708cA1w+jupmmAMEw3/xfsUX0ANFU0FS+5txQDF
	 dgAMV2faDKGfJpLd5Ykma4MDvsFAm3wPaWW6vbeFSQQ0up2/Zodefv6ak5C7MiG68b
	 BbQsxLQa20RgwHNJPjrtSInQqvH4oEUanuhYQ4PE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGPAmM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Jul 2020 20:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgGPAmM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 15 Jul 2020 20:42:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96A3420714;
        Thu, 16 Jul 2020 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594860131;
        bh=pXYWeFmAhUqKs3WFhgza1Et7LRBB6HzUBNYGRCiNV/k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aY/vmBxEw5jwBTLj0NAOPKj///aMXhNqXPVhjexCYi3aKSKrrYkWCbQHyGBu80tYi
         6sM0G7CvM+jgcBS2B+VxAoX2ANksIMJYg+oUKuGfzQUDRyH76QlsFOjo8MGQSTXkXy
         5zDC/PQfn2k7H4XbOXtx926JgeJl6UdsEm67tq3c=
Date:   Wed, 15 Jul 2020 17:42:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, colin.king@canonical.com, dushistov@mail.ru,
        mm-commits@vger.kernel.org
Subject:  +
 fs-ufs-avoid-potential-u32-multiplication-overflow.patch added to -mm tree
Message-ID: <20200716004211.1DVoeJ9oB%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: avoid potential u32 multiplication overflow
has been added to the -mm tree.  Its filename is
     fs-ufs-avoid-potential-u32-multiplication-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-avoid-potential-u32-multiplication-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-avoid-potential-u32-multiplication-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: fs/ufs: avoid potential u32 multiplication overflow

The 64 bit ino is being compared to the product of two u32 values,
however, the multiplication is being performed using a 32 bit multiply so
there is a potential of an overflow.  To be fully safe, cast uspi->s_ncg
to a u64 to ensure a 64 bit multiplication occurs to avoid any chance of
overflow.

Addresses-Coverity: ("Unintentional integer overflow")
Link: http://lkml.kernel.org/r/20200715170355.1081713-1-colin.king@canonical.com
Fixes: f3e2a520f5fb ("ufs: NFS support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ufs/super.c~fs-ufs-avoid-potential-u32-multiplication-overflow
+++ a/fs/ufs/super.c
@@ -101,7 +101,7 @@ static struct inode *ufs_nfs_get_inode(s
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
 	struct inode *inode;
 
-	if (ino < UFS_ROOTINO || ino > uspi->s_ncg * uspi->s_ipg)
+	if (ino < UFS_ROOTINO || ino > (u64)uspi->s_ncg * uspi->s_ipg)
 		return ERR_PTR(-ESTALE);
 
 	inode = ufs_iget(sb, ino);
_

Patches currently in -mm which might be from colin.king@canonical.com are

fs-ufs-avoid-potential-u32-multiplication-overflow.patch

