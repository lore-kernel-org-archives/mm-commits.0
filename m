Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7A5C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D2C207F7
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266295;
	bh=ZL42jaXHTliRCLTtG2v27DqoUrV11ri5AHY0HFAzsOI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MDKeq7XN1XsEhzIITTiGvmeMU5Fzpo3rN8oNKRPDLsHukKt/QBaAOWHK2yMN9lxK9
	 Sd1kvlklGH9aVlq1YfaP9WubrfBxAHFxuJBkVS5nJlyGQlp3sVHqQ0+BpwCpLAUXl8
	 YZMOC4rRThEqBlciscKnQpmVVVALxBR/nE6YbSBU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHLVEz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgHLVEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EDB82078B;
        Wed, 12 Aug 2020 21:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266294;
        bh=ZL42jaXHTliRCLTtG2v27DqoUrV11ri5AHY0HFAzsOI=;
        h=Date:From:To:Subject:From;
        b=H5Lz96lp+QTGLzKqy5VJsUtBxP8ru8ecm/a3UNJ9z2IRxDjQOxh9N/G4xt8pzjuDU
         MC8bh7a4lytAAqswAIBlbrF3/xLoFJLFMz+EbzjNADgYPbfBqVwzgjph+GoCkbThF4
         OJDj4cW6qD+2uMSGVkCXsMP4XAVxmkUNbJmMwTUk=
Date:   Wed, 12 Aug 2020 14:04:54 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, colin.king@canonical.com, dushistov@mail.ru,
        mm-commits@vger.kernel.org
Subject:  [merged]
 fs-ufs-avoid-potential-u32-multiplication-overflow.patch removed from -mm
 tree
Message-ID: <20200812210454.ZEMMKGZNN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: avoid potential u32 multiplication overflow
has been removed from the -mm tree.  Its filename was
     fs-ufs-avoid-potential-u32-multiplication-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


