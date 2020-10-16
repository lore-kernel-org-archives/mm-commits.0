Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2AEC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86BD02087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816426;
	bh=mAxQLQ3ux7y0A9xcCrK5XRSLZSMB/H6JKeOrydyRUGY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0tHzK/ZZMofuZaAbITqRh0tM33UTYN7T+xdLphZLb18XILAYyMHME8SRXAona4VTx
	 oycWuGo1pbXElhex3IWVKPgvAVradEf76duiWvIxspJ68OitT9dNW2odnIesadoyul
	 C38NXDXkHNVVuN+1xzFf6ag5HJBVbk4ydskpzx5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393917AbgJPCrG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393913AbgJPCrF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FA6208C7;
        Fri, 16 Oct 2020 02:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816424;
        bh=mAxQLQ3ux7y0A9xcCrK5XRSLZSMB/H6JKeOrydyRUGY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ICZNOt4HT/t7yWjNl2l3gylqgS3fTUFBE9dFPKb3YUMQMmmhDN8MBU+iLbG590uON
         syz3swPPuukHTt9X1eGwRiSXF7ju678hPYeHEMAdyuYMRe+UTKUXZk0ks9Y7626ucw
         hkI3HDc6S3/4zO/vkisfeOdZzvDQbCJRzBjDi3EM=
Date:   Thu, 15 Oct 2020 19:47:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 092/156] mm: use helper function
 put_write_access()
Message-ID: <20201016024703.N713x0Y3v%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
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
