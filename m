Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49C22C2D0AE
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04ACF22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709317;
	bh=RXQmg2wHxqrq7A598V2CRFw7QiytmMnU+5FQSyYxkHI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BbopdvwH2j7gBNrE4b+UNNU+i6xiTNWVRVCq4fyTgQjAO2F5FmuPQx7XpdBbi+Obt
	 HnltjV9O2/c4I3rUqUTlyMHIj0wOQshRIQ4E4WCI8kEAuuTGZtLWf/xTrKFd4c1MN4
	 2la3G0JCMFDDQ7up4LoC0tnSoilpOS0mQdx+KDxk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728959AbgJNVBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730492AbgJNVBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:47 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85F1022257;
        Wed, 14 Oct 2020 21:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709289;
        bh=RXQmg2wHxqrq7A598V2CRFw7QiytmMnU+5FQSyYxkHI=;
        h=Date:From:To:Subject:From;
        b=mBDScGHrX4RzyrAVBK5f6etCrjpeXZSt/uk+1XO7RrnH+z5pS4QY9ItqJSiWuJJIP
         6Ydpzj0ic1jguinWyIVgE7qmDb3rHOXXf4ezRs2aIglnRJ4m4IFzM7Vbo0YrDzX6SO
         Qp9IqREVz69l/s6Xk0kD7QTORtKOV6ts/14NYx1Q=
Date:   Wed, 14 Oct 2020 14:01:29 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-mmap-use-helper-function-allow=5Fwrite=5Faccess-in?=
 =?US-ASCII?Q?-=5F=5Fremove=5Fshared=5Fvm=5Fstruct.patch?= removed from -mm
 tree
Message-ID: <20201014210129.J2A313dPk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: use helper function allow_write_access() in __remove_shared_vm_struct()
has been removed from the -mm tree.  Its filename was
     mm-mmap-use-helper-function-allow_write_access-in-__remove_shared_vm_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

