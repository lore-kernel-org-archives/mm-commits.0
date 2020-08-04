Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3466C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 01:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCC0120781
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 01:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596504233;
	bh=lJVYdrufqKPBr+9gzhZw9B1pn65INIZqRV5+UteYZSM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qwVDyUWTkcMbN87aPiO0GI642gLi74TuEECkQXL2lTOfQrTfNSRdtS+JH8/ihqWk0
	 kTG6nPp+VfYvYtYlGho/1x32/bH787W6K+SNnLZfPhzz9h6IHjBd83iWgLnUNseqEv
	 aJ0BS+R7WmclxVTC6r42ihAcM3L1isNqTI6EjzD4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728931AbgHDBXx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 21:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHDBXx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 21:23:53 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03BE22076E;
        Tue,  4 Aug 2020 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596504232;
        bh=lJVYdrufqKPBr+9gzhZw9B1pn65INIZqRV5+UteYZSM=;
        h=Date:From:To:Subject:From;
        b=TBLxzihJUqM2toMbw31sTWYAsTiMEsBkhpVvzcsGhziRJogz+pOU/VVlGm7eAQvdu
         NMfsWRncn0tU5pDnQIv5K7WFuDTypg8iaGs72erpcNg9mtNYbQZkL3+H6SAufYTSQ9
         mU1g0l68kwRTazT/EiwcnHDAUqLz0ysKmnU1Qvz4=
Date:   Mon, 03 Aug 2020 18:23:51 -0700
From:   akpm@linux-foundation.org
To:     alex.williamson@redhat.com, bmt@zurich.ibm.com, cohuck@redhat.com,
        daniel.m.jordan@oracle.com, dbueso@suse.de, dledford@redhat.com,
        fly@kernel.page, hughd@google.com, jgg@ziepe.ca,
        jglisse@redhat.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, ldufour@linux.ibm.com,
        Liam.Howlett@oracle.com, mm-commits@vger.kernel.org,
        peterz@infradead.org, rientjes@google.com, vbabka@suse.cz,
        walken@google.com, willy@infradead.org, yinghan@google.com
Subject:  [withdrawn]
 mm-util-account_locked_vm-does-not-hold-mmap_lock.patch removed from -mm
 tree
Message-ID: <20200804012351.2EpST1zEU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, util: account_locked_vm() does not hold mmap_lock
has been removed from the -mm tree.  Its filename was
     mm-util-account_locked_vm-does-not-hold-mmap_lock.patch

This patch was dropped because it was withdrawn

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


