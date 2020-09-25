Return-Path: <SRS0=MO2u=DC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4AFC4346E
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C953F20EDD
	for <mm-commits@archiver.kernel.org>; Fri, 25 Sep 2020 02:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601001410;
	bh=cxGR7vpRosRqY5ey9HZlw9vbDY7bVqt70RoXJ96nrIQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=08wBOcHctCFtdfnAUmAV8+GLd/djweaq2+ScnVaxP5nMNrFcfQvm1ODQJuiO1uI4d
	 Nje/5vo2mMIbm5aTHrT9kTM/cdOO/2KhEvmJViHAzSE+ttDDcExFRfoeG55aGZs1bt
	 /EZv4dNdUjheKyoOQ8pF4XoKJXVEepldIGCZ8/3Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgIYCgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:48590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgIYCgu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Sep 2020 22:36:50 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A83D5207C4;
        Fri, 25 Sep 2020 02:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601001409;
        bh=cxGR7vpRosRqY5ey9HZlw9vbDY7bVqt70RoXJ96nrIQ=;
        h=Date:From:To:Subject:From;
        b=W2WLILjJUxcuBjMyR+CWTp/PtkSAfY1UCpPuG2QssKvB0YN5reRgeZvDZPClPA756
         yEPfffX8ZvheXRCK+FG+9z5ChWrQS9QsD1OWSdtjQLG0GfJOh+As5p7syXEHiw2CtJ
         yvQbTBWVnPikfAbycIeZCQJPbEXYrhHlguSWJ5Qk=
Date:   Thu, 24 Sep 2020 19:36:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com
Subject:  + mm-use-helper-function-put_write_access.patch added to
 -mm tree
Message-ID: <20200925023649.TfAoA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use helper function put_write_access()
has been added to the -mm tree.  Its filename is
     mm-use-helper-function-put_write_access.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-helper-function-put_write_access.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-helper-function-put_write_access.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -555,7 +555,7 @@ static __latent_entropy int dup_mmap(str
 
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

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swap-fix-confusing-comment-in-release_pages.patch
mm-memcontrol-correct-the-comment-of-mem_cgroup_iter.patch
mm-page_counter-correct-the-obsolete-func-name-in-the-comment-of-page_counter_try_charge.patch
mm-memcontrol-remove-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
mm-use-helper-function-mapping_allow_writable.patch
mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

