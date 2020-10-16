Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B2BC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A812F2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817810;
	bh=mAxQLQ3ux7y0A9xcCrK5XRSLZSMB/H6JKeOrydyRUGY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=f4MbTtg8aHg06YLPjgcdSqkxFNIOBWa6QWcSDkh6HFaKS3Nf0CuZZryn6tEf1sUiz
	 ZMTW2rtGGBNXKXI/F848xkWMOCqRI9c9kpzJqcF9D6I5fvyAAgQuvHT13pjC/J7Pl9
	 dyLhEfmFOP1yigFOS3VN9o508CEIxyjsP2lqhNyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731209AbgJPDKK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgJPDKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57AD520878;
        Fri, 16 Oct 2020 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817809;
        bh=mAxQLQ3ux7y0A9xcCrK5XRSLZSMB/H6JKeOrydyRUGY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R9AlTrfM1EPMAwVzUy2sYwC9/iTHVh8aVoJjukvycldOgt6D4GOQavh6H9VukQxVh
         vPEVqsneMalkbCF9y+gUQ2De2+V39pGVKXtMlxtB5BgqPqbV9HX7Whfu/3vKnNeN+B
         IZXj9OZu4X/ITw/1ZAHh+Gpi6xaEqOLQWnoFT/tE=
Date:   Thu, 15 Oct 2020 20:10:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 092/156] mm: use helper function
 put_write_access()
Message-ID: <20201016031008.Wz0k_eQgP%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: use helper function put_write_access()

In commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), the helper put_write_access()
came with the atomic_dec operation of the i_writecount field.  But it
forgot to use this helper in __vma_link_file() and dup_mmap().

Link: https://lkml.kernel.org/r/20200924115235.5111-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 +-
 mm/mmap.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/fork.c~mm-use-helper-function-put_write_access
+++ a/kernel/fork.c
@@ -556,7 +556,7 @@ static __latent_entropy int dup_mmap(str
 
 			get_file(file);
 			if (tmp->vm_flags & VM_DENYWRITE)
-				atomic_dec(&inode->i_writecount);
+				put_write_access(inode);
 			i_mmap_lock_write(mapping);
 			if (tmp->vm_flags & VM_SHARED)
 				mapping_allow_writable(mapping);
--- a/mm/mmap.c~mm-use-helper-function-put_write_access
+++ a/mm/mmap.c
@@ -619,7 +619,7 @@ static void __vma_link_file(struct vm_ar
 		struct address_space *mapping = file->f_mapping;
 
 		if (vma->vm_flags & VM_DENYWRITE)
-			atomic_dec(&file_inode(file)->i_writecount);
+			put_write_access(file_inode(file));
 		if (vma->vm_flags & VM_SHARED)
 			mapping_allow_writable(mapping);
 
_
