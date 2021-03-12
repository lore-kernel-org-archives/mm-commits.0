Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE49EC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DBCC64F69
	for <mm-commits@archiver.kernel.org>; Fri, 12 Mar 2021 18:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhCLSjR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Mar 2021 13:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233516AbhCLSiz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Mar 2021 13:38:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F9064DEF;
        Fri, 12 Mar 2021 18:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615574335;
        bh=D0cJByGKd7jPX6dyAn3CMbVywtOBc+H/MjLUN10dzAI=;
        h=Date:From:To:Subject:From;
        b=Lw5Ti3RryZCjTnqeM8cQHl1EFzTfWtIja9z2ZeKO2+8sIh4wKoxugI5AF3O5xxgoO
         AY9tB3pEV/LXWSnvf4DmqYf6+Klu4Z3TnwbWWRZoSsL71FKJFjbzdig0ajJNZRM9RP
         IYZFaQYxSVTo2g1t8cbTOfMKfLgPK5525eyBPkfA=
Date:   Fri, 12 Mar 2021 10:38:54 -0800
From:   akpm@linux-foundation.org
To:     axelrasmussen@google.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 userfaultfd-support-minor-fault-handling-for-shmem-fix.patch added to -mm
 tree
Message-ID: <20210312183854.S9qK4rJMr%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd-support-minor-fault-handling-for-shmem-fix
has been added to the -mm tree.  Its filename is
     userfaultfd-support-minor-fault-handling-for-shmem-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-support-minor-fault-handling-for-shmem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: userfaultfd-support-minor-fault-handling-for-shmem-fix

build fix

Link: https://lkml.kernel.org/r/20210309225830.2988269-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/shmem.c~userfaultfd-support-minor-fault-handling-for-shmem-fix
+++ a/mm/shmem.c
@@ -2359,6 +2359,7 @@ static struct inode *shmem_get_inode(str
 	return inode;
 }
 
+#ifdef CONFIG_USERFAULTFD
 int shmem_mcopy_atomic_pte(struct mm_struct *dst_mm, pmd_t *dst_pmd,
 			   struct vm_area_struct *dst_vma,
 			   unsigned long dst_addr, unsigned long src_addr,
@@ -2492,6 +2493,7 @@ out_unacct_blocks:
 	shmem_inode_unacct_blocks(inode, 1);
 	goto out;
 }
+#endif /* CONFIG_USERFAULTFD */
 
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
_

Patches currently in -mm which might be from axelrasmussen@google.com are

userfaultfd-add-minor-fault-registration-mode.patch
userfaultfd-disable-huge-pmd-sharing-for-minor-registered-vmas.patch
userfaultfd-hugetlbfs-only-compile-uffd-helpers-if-config-enabled.patch
userfaultfd-add-uffdio_continue-ioctl.patch
userfaultfd-update-documentation-to-describe-minor-fault-handling.patch
userfaultfd-selftests-add-test-exercising-minor-fault-handling.patch
userfaultfd-support-minor-fault-handling-for-shmem.patch
userfaultfd-support-minor-fault-handling-for-shmem-fix.patch
userfaultfd-selftests-use-memfd_create-for-shmem-test-type.patch
userfaultfd-selftests-create-alias-mappings-in-the-shmem-test.patch
userfaultfd-selftests-reinitialize-test-context-in-each-test.patch
userfaultfd-selftests-exercise-minor-fault-handling-shmem-support.patch

