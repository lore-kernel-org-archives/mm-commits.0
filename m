Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C114C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCC220792
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595882070;
	bh=nitalBN+aMZ8oRJpUGJePgS7yuovPam86+AlHm+gtl8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ym+WlLVqxlgEE76o6I0VHNgm4qH0cnuD+dJwFwwq0FUy/ptqhe8yTRalukoxlrw+H
	 6+X26fGC3CJo+6zIJtgJYG8mbNRlPrEBodtxZ0VnGumlG06IuVMYPxHB0QYKJgr1Pq
	 ApNCK9/t8ZXSMcCkxFBmB4syrwQJUtiiKPUAuHDo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgG0Uea (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 16:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgG0Ue3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 16:34:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CDE520786;
        Mon, 27 Jul 2020 20:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595882068;
        bh=nitalBN+aMZ8oRJpUGJePgS7yuovPam86+AlHm+gtl8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xBJt4aDFNd5JlC8xq1nC9dSHHhHSbgtfmoBElCTUwGD4+FeLxEFXtTbUYw3yjwc6I
         dzYsEFImy4uEkCca0A0WrHzr+Bcb2kZYpZO85GXTikSThTZ3DIO/q0cPCDZax53Kvc
         E0PN8JGbxQ0WahysK1dVahK2q8gfbIxCWLg2A/3Q=
Date:   Mon, 27 Jul 2020 13:34:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alex.williamson@redhat.com, bmt@zurich.ibm.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, dledford@redhat.com,
        fly@kernel.page, hughd@google.com, jgg@ziepe.ca,
        jglisse@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, rientjes@google.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, yinghan@google.com
Subject:  + mm-util-account_locked_vm-does-not-hold-mmap_lock.patch
 added to -mm tree
Message-ID: <20200727203427.4q1kvBOcr%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, util: account_locked_vm() does not hold mmap_lock
has been added to the -mm tree.  Its filename is
     mm-util-account_locked_vm-does-not-hold-mmap_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-util-account_locked_vm-does-not-hold-mmap_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-util-account_locked_vm-does-not-hold-mmap_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pengfei Li <fly@kernel.page>
Subject: mm, util: account_locked_vm() does not hold mmap_lock

Since mm->locked_vm is already an atomic counter, account_locked_vm()
does not need to hold mmap_lock.

Link: http://lkml.kernel.org/r/20200726080224.205470-2-fly@kernel.page
Signed-off-by: Pengfei Li <fly@kernel.page>
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vfio/vfio_iommu_type1.c |    8 ++------
 mm/util.c                       |   15 +++------------
 2 files changed, 5 insertions(+), 18 deletions(-)

--- a/drivers/vfio/vfio_iommu_type1.c~mm-util-account_locked_vm-does-not-hold-mmap_lock
+++ a/drivers/vfio/vfio_iommu_type1.c
@@ -376,12 +376,8 @@ static int vfio_lock_acct(struct vfio_dm
 	if (!mm)
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = __account_locked_vm(mm, abs(npage), npage > 0,
+					dma->task, dma->lock_cap);
 
 	if (async)
 		mmput(mm);
--- a/mm/util.c~mm-util-account_locked_vm-does-not-hold-mmap_lock
+++ a/mm/util.c
@@ -424,8 +424,7 @@ void arch_pick_mmap_layout(struct mm_str
  * @task:        task used to check RLIMIT_MEMLOCK
  * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
  *
- * Assumes @task and @mm are valid (i.e. at least one reference on each), and
- * that mmap_lock is held as writer.
+ * Assumes @task and @mm are valid (i.e. at least one reference on each).
  *
  * Return:
  * * 0       on success
@@ -437,8 +436,6 @@ int __account_locked_vm(struct mm_struct
 	unsigned long locked_vm, limit;
 	int ret = 0;
 
-	mmap_assert_write_locked(mm);
-
 	locked_vm = atomic64_read(&mm->locked_vm);
 	if (inc) {
 		if (!bypass_rlim) {
@@ -476,17 +473,11 @@ EXPORT_SYMBOL_GPL(__account_locked_vm);
  */
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
 {
-	int ret;
-
 	if (pages == 0 || !mm)
 		return 0;
 
-	mmap_write_lock(mm);
-	ret = __account_locked_vm(mm, pages, inc, current,
-				  capable(CAP_IPC_LOCK));
-	mmap_write_unlock(mm);
-
-	return ret;
+	return __account_locked_vm(mm, pages, inc,
+					current, capable(CAP_IPC_LOCK));
 }
 EXPORT_SYMBOL_GPL(account_locked_vm);
 
_

Patches currently in -mm which might be from fly@kernel.page are

mm-make-mm-locked_vm-an-atomic64-counter.patch
mm-util-account_locked_vm-does-not-hold-mmap_lock.patch

