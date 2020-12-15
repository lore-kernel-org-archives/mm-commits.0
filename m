Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5805FC35273
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D60B22D03
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgLOX7B (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgLOXVA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:21:00 -0500
Date:   Tue, 15 Dec 2020 15:19:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074383;
        bh=fPaT1hYvMKqEe8exqwZtP7IDgbypTMv1uo1h5gAsgHY=;
        h=From:To:Subject:From;
        b=df9DwH5U7QqmpZhj6z4rAL+HX4R/SIfHxhm4qkJz7i22oZLMK/E9x+ibaYMX2kTJP
         IHNWARWgKJTf0ZzToI/mmGsLKE2ykHVJrSBCipP8/wSu4J+7FYSDLY4i5q1iqWZuaW
         VRNu50g5yoEecOHNT0Q5sntEiDdCSlwuFr6MgUtg=
From:   akpm@linux-foundation.org
To:     bgeffon@google.com, catalin.marinas@arm.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, dima@arista.com, hughd@google.com,
        jgg@ziepe.ca, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vbabka@suse.cz, viro@zeniv.linux.org.uk,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  [merged]
 mremap-check-if-its-possible-to-split-original-vma.patch removed from -mm
 tree
Message-ID: <20201215231942.8s7ANctDP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mremap: check if it's possible to split original vma
has been removed from the -mm tree.  Its filename was
     mremap-check-if-its-possible-to-split-original-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <dima@arista.com>
Subject: mremap: check if it's possible to split original vma

If original VMA can't be split at the desired address, do_munmap() will
fail and leave both new-copied VMA and old VMA.  De-facto it's
MREMAP_DONTUNMAP behaviour, which is unexpected.

Currently, it may fail such way for hugetlbfs and dax device mappings.

Minimize such unpleasant situations to OOM by checking .may_split() before
attempting to create a VMA copy.

Link: https://lkml.kernel.org/r/20201013013416.390574-6-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mremap-check-if-its-possible-to-split-original-vma
+++ a/mm/mremap.c
@@ -493,7 +493,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long excess = 0;
 	unsigned long hiwater_vm;
 	int split = 0;
-	int err;
+	int err = 0;
 	bool need_rmap_locks;
 
 	/*
@@ -503,6 +503,15 @@ static unsigned long move_vma(struct vm_
 	if (mm->map_count >= sysctl_max_map_count - 3)
 		return -ENOMEM;
 
+	if (vma->vm_ops && vma->vm_ops->may_split) {
+		if (vma->vm_start != old_addr)
+			err = vma->vm_ops->may_split(vma, old_addr);
+		if (!err && vma->vm_end != old_addr + old_len)
+			err = vma->vm_ops->may_split(vma, old_addr + old_len);
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Advise KSM to break any KSM pages in the area to be moved:
 	 * it would be confusing if they were to turn up at the new
_

Patches currently in -mm which might be from dima@arista.com are


