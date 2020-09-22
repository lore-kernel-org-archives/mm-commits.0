Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46DEC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2D32311C
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600796753;
	bh=PbZpJE7Jq8kEZrycGpGgY8fYrRX7nefH2SsyfCq5auc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zLO7pmcLx10NZ4K0nPJ9T7UYm+i8nyOKGmgeRiImasAnYZ1pGsiLe24gw+16CbsWP
	 0OYThGxIoYfB6Cdq3GH62xrfBwwqzPPkmXwDeWNIH4lGhjYSlBzmtFg+UVEbCMyYOx
	 SfrHoKsLx2N2Rl4+eD41RK8m8QrrKDUqRW3+hv/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgIVRpx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:45:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbgIVRpw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:45:52 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1534F206F4;
        Tue, 22 Sep 2020 17:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796752;
        bh=PbZpJE7Jq8kEZrycGpGgY8fYrRX7nefH2SsyfCq5auc=;
        h=Date:From:To:Subject:From;
        b=2reUWtZVjeqSjjaWYG6DQUnpm9hHhLpAn8ohkw/E+qzTMhrQw4K8Iy/F6oAFhcVpV
         P5Vq2UPkapks5G+wCGEfN5etGDtZQOd4e+O423x3ktu4y4GPGRHhEeS6gZhEqIByX2
         xYQSbOIe/o3QOWt/+qOktJ9jH4Abd/g6Ry9WbE1s=
Date:   Tue, 22 Sep 2020 10:45:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com
Subject:  +
 =?us-ascii?Q?mm-mmap-use-helper-function-allow=5Fwrite=5Faccess-in?=
 =?us-ascii?Q?-=5F=5Fremove=5Fshared=5Fvm=5Fstruct.patch?= added to -mm
 tree
Message-ID: <20200922174551.qQEft%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use helper function allow_write_access() in __remove_shared_vm_struct()
has been added to the -mm tree.  Its filename is
     mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch

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
Subject: mm/mmap.c: use helper function allow_write_access() in __remove_shared_vm_struct()

In commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), the helper allow_write_access
came with the atomic_inc operation of the i_writecount field in the func
__remove_shared_vm_struct().  But it forgot to use this helper function.

Link: https://lkml.kernel.org/r/20200921115814.39680-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct
+++ a/mm/mmap.c
@@ -143,7 +143,7 @@ static void __remove_shared_vm_struct(st
 		struct file *file, struct address_space *mapping)
 {
 	if (vma->vm_flags & VM_DENYWRITE)
-		atomic_inc(&file_inode(file)->i_writecount);
+		allow_write_access(file);
 	if (vma->vm_flags & VM_SHARED)
 		mapping_unmap_writable(mapping);
 
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
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

