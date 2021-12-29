Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF318C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 29 Dec 2021 23:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhL2X3S (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 29 Dec 2021 18:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbhL2X3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Dec 2021 18:29:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E7C061574
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 15:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6477D61579
        for <mm-commits@vger.kernel.org>; Wed, 29 Dec 2021 23:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FC4C36AE9;
        Wed, 29 Dec 2021 23:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640820556;
        bh=RkV5uw1MM3GMuAFnSquFPPByVhhWllbv4qORr7zpKl4=;
        h=Date:From:To:Subject:From;
        b=gkdmS7HL6u+5BxclLqItuH85CipNBoSwBUoTdAGBvRsOTP1CoxM2ctpVScqqd4B+k
         JutUQhZHEhIGiab6Byt2rImG6A6NyP7tdzXoM5fvSSDKukQQz0Y5Ol4XwQbrXqxnMU
         V0FyyOsImXv/VVAdnGoK/bDjw+90m+4hMAc5j3KM=
Date:   Wed, 29 Dec 2021 15:29:17 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, pbonzini@redhat.com,
        mike.kravetz@oracle.com, seanjc@google.com
Subject:  +
 hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list.patch added to -mm
 tree
Message-ID: <20211229232917.sZcTc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()
has been added to the -mm tree.  Its filename is
     hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sean Christopherson <seanjc@google.com>
Subject: hugetlbfs: fix off-by-one error in hugetlb_vmdelete_list()

Pass "end - 1" instead of "end" when walking the interval tree in
hugetlb_vmdelete_list() to fix an inclusive vs.  exclusive bug.  The two
callers that pass a non-zero "end" treat it as exclusive, whereas the
interval tree iterator expects an inclusive "last".  E.g.  punching a hole
in a file that precisely matches the size of a single hugepage, with a vma
starting right on the boundary, will result in unmap_hugepage_range()
being called twice, with the second call having start==end.

The off-by-one error doesn't cause functional problems as
__unmap_hugepage_range() turns into a massive nop due to short-circuiting
its for-loop on "address < end".  But, the mmu_notifier invocations to
invalid_range_{start,end}() are passed a bogus zero-sized range, which may
be unexpected behavior for secondary MMUs.

The bug was exposed by commit ed922739c919 ("KVM: Use interval tree to do
fast hva lookup in memslots"), currently queued in the KVM tree for 5.17,
which added a WARN to detect ranges with start==end.

Link: https://lkml.kernel.org/r/20211228234257.1926057-1-seanjc@google.com
Fixes: 1bfad99ab425 ("hugetlbfs: hugetlb_vmtruncate_list() needs to take a range to delete")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reported-by: syzbot+4e697fe80a31aa7efe21@syzkaller.appspotmail.com
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list
+++ a/fs/hugetlbfs/inode.c
@@ -409,10 +409,11 @@ hugetlb_vmdelete_list(struct rb_root_cac
 	struct vm_area_struct *vma;
 
 	/*
-	 * end == 0 indicates that the entire range after
-	 * start should be unmapped.
+	 * end == 0 indicates that the entire range after start should be
+	 * unmapped.  Note, end is exclusive, whereas the interval tree takes
+	 * an inclusive "last".
 	 */
-	vma_interval_tree_foreach(vma, root, start, end ? end : ULONG_MAX) {
+	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
 		unsigned long v_offset;
 		unsigned long v_end;
 
_

Patches currently in -mm which might be from seanjc@google.com are

hugetlbfs-fix-off-by-one-error-in-hugetlb_vmdelete_list.patch

