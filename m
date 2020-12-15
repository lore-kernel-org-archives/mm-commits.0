Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0572C2BBCD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5B4222B4B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgLODJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgLODJP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:09:15 -0500
Date:   Mon, 14 Dec 2020 19:08:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001703;
        bh=6yeI54W6MW4NXm5Qm1URDF4jYYjXuDrkBSRoDB90qCo=;
        h=From:To:Subject:In-Reply-To:From;
        b=HWXi/1iz412fWsr9aZW5wLy1rYN6nlGUuSQnd7yWUCnEhTAYSoznIWL3iRvLqEeIm
         NukYqrTN3enieXMvx7RlVbKYU2eqqdBbnNAYIxzIpN9iOykLsXf+uIE7XME9C+imFk
         m7IWWcMlokI8+uU1lhCATynzwpPkv6o2DtendmCE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bgeffon@google.com,
        catalin.marinas@arm.com, dan.carpenter@oracle.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, dima@arista.com,
        hughd@google.com, jgg@ziepe.ca, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, mike.kravetz@oracle.com,
        minchan@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, vishal.l.verma@intel.com,
        will@kernel.org
Subject:  [patch 088/200] mremap: check if it's possible to split
 original vma
Message-ID: <20201215030821.oEVfuwJC4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
