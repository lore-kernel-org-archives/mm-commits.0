Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D63C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiANWIf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiANWIf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:08:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BF8C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:08:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C853CE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8F3C36AE5;
        Fri, 14 Jan 2022 22:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198111;
        bh=bf5nzAkdJboQbDq4AH0ai7Cxdq7IpRNVo9WD1L1IwZM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=A6hp7MCKMvOG12k34GLQqYtmZwMA7gN/OLnKW0ueQaJ9OrHzoQdZIdncpKOYQP3lD
         djygfMzqq2J5nLOLkGlp0dxFzWHP6jjCM0dkyWdVUaa8yNp0CbFhU2FI3ArNonFk5x
         6i8AM3fwWNlRVMQm/Ngln4Q7fPMAp4iIrMze69cM=
Date:   Fri, 14 Jan 2022 14:08:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 101/146] hugetlbfs: fix off-by-one error in
 hugetlb_vmdelete_list()
Message-ID: <20220114220830.qBW1Hy4MM%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
