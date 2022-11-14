Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920BAC43219
	for <mm-commits@archiver.kernel.org>; Mon, 14 Nov 2022 21:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbiKNVno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Nov 2022 16:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbiKNVnm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2022 16:43:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1E710B50
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 13:43:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22D8961447
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2022 21:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759E2C433C1;
        Mon, 14 Nov 2022 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668462220;
        bh=NrCfnV/Bodv3VA389+f504OhqHqHhCrcXdxXzLurfww=;
        h=Date:To:From:Subject:From;
        b=WVX4VQ6M/+M79LsLE7g8BjK8nW8BeHejVhMbWhJ/UMeSlVeyhj0eRpMGC8DsyGtFE
         HmOJsd4gOizzHeR9WTljgskpWDvwuVnJU4RQJCDTgbAZgTw99kKaCNUPxjQQHt2WBn
         QfYpmxoT2r0t3PT4QBNdXiydWGLQ0sLdDXIMsStw=
Date:   Mon, 14 Nov 2022 13:43:39 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        syzbot+83b4134621b7c326d950@syzkaller.appspotmail.com,
        mhocko@suse.com, manfred@colorfullife.com, linmiaohe@huawei.com,
        ebiederm@xmission.com, doug.nelson@intel.com,
        alexander.mikhalitsyn@virtuozzo.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-shm-call-underlying-open-close-vm_ops.patch added to mm-hotfixes-unstable branch
Message-Id: <20221114214340.759E2C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm: call underlying open/close vm_ops
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ipc-shm-call-underlying-open-close-vm_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-shm-call-underlying-open-close-vm_ops.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: ipc/shm: call underlying open/close vm_ops
Date: Mon, 14 Nov 2022 13:00:18 -0800

Shared memory segments can be created that are backed by hugetlb pages. 
When this happens, the vmas associated with any mappings (shmat) are
marked VM_HUGETLB, yet the vm_ops for such mappings are provided by
ipc/shm (shm_vm_ops).  There is a mechanism to call the underlying hugetlb
vm_ops, and this is done for most operations.  However, it is not done for
open and close.

This was not an issue until the introduction of the hugetlb vma_lock. 
This lock structure is pointed to by vm_private_data and the open/close
vm_ops help maintain this structure.  The special hugetlb routine called
at fork took care of structure updates at fork time.  However,
vma_splitting is not properly handled for ipc shared memory mappings
backed by hugetlb pages.  This can result in a "kernel NULL pointer
dereference" BUG or use after free as two vmas point to the same lock
structure.

Update the shm open and close routines to always call the underlying open
and close routines.

Link: https://lkml.kernel.org/r/20221114210018.49346-1-mike.kravetz@oracle.com
Fixes: 8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Doug Nelson <doug.nelson@intel.com>
Reported-by: <syzbot+83b4134621b7c326d950@syzkaller.appspotmail.com>
Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/ipc/shm.c~ipc-shm-call-underlying-open-close-vm_ops
+++ a/ipc/shm.c
@@ -275,10 +275,8 @@ static inline void shm_rmid(struct shmid
 }
 
 
-static int __shm_open(struct vm_area_struct *vma)
+static int __shm_open(struct shm_file_data *sfd)
 {
-	struct file *file = vma->vm_file;
-	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 
 	shp = shm_lock(sfd->ns, sfd->id);
@@ -302,7 +300,15 @@ static int __shm_open(struct vm_area_str
 /* This is called by fork, once for every shm attach. */
 static void shm_open(struct vm_area_struct *vma)
 {
-	int err = __shm_open(vma);
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+	int err;
+
+	/* Always call underlying open if present */
+	if (sfd->vm_ops->open)
+		sfd->vm_ops->open(vma);
+
+	err = __shm_open(sfd);
 	/*
 	 * We raced in the idr lookup or with shm_destroy().
 	 * Either way, the ID is busted.
@@ -359,10 +365,8 @@ static bool shm_may_destroy(struct shmid
  * The descriptor has already been removed from the current->mm->mmap list
  * and will later be kfree()d.
  */
-static void shm_close(struct vm_area_struct *vma)
+static void __shm_close(struct shm_file_data *sfd)
 {
-	struct file *file = vma->vm_file;
-	struct shm_file_data *sfd = shm_file_data(file);
 	struct shmid_kernel *shp;
 	struct ipc_namespace *ns = sfd->ns;
 
@@ -388,6 +392,18 @@ done:
 	up_write(&shm_ids(ns).rwsem);
 }
 
+static void shm_close(struct vm_area_struct *vma)
+{
+	struct file *file = vma->vm_file;
+	struct shm_file_data *sfd = shm_file_data(file);
+
+	/* Always call underlying close if present */
+	if (sfd->vm_ops->close)
+		sfd->vm_ops->close(vma);
+
+	__shm_close(sfd);
+}
+
 /* Called with ns->shm_ids(ns).rwsem locked */
 static int shm_try_destroy_orphaned(int id, void *p, void *data)
 {
@@ -583,13 +599,13 @@ static int shm_mmap(struct file *file, s
 	 * IPC ID that was removed, and possibly even reused by another shm
 	 * segment already.  Propagate this case as an error to caller.
 	 */
-	ret = __shm_open(vma);
+	ret = __shm_open(sfd);
 	if (ret)
 		return ret;
 
 	ret = call_mmap(sfd->file, vma);
 	if (ret) {
-		shm_close(vma);
+		__shm_close(sfd);
 		return ret;
 	}
 	sfd->vm_ops = vma->vm_ops;
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

madvise-use-zap_page_range_single-for-madvise-dontneed.patch
hugetlb-remove-duplicate-mmu-notifications.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
ipc-shm-call-underlying-open-close-vm_ops.patch
selftests-vm-update-hugetlb-madvise.patch

