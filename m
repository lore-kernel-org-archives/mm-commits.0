Return-Path: <SRS0=g5V1=BD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD56EC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94DB42070B
	for <mm-commits@archiver.kernel.org>; Fri, 24 Jul 2020 23:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595633895;
	bh=MfqXerlTWmruPnCjXD44JMzM+C6e1M6Dp6HE1y9ZH/c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LVy+0UMG5vfawZMACc8jwxM9I+ucJeuAnyer19oYCk1lZ5euu2biqv3Xff/Aj9f4T
	 US0yXVcfLyqXxjGQEoO4lLYaVSHZ6qzE6lovEq8gCsZAEZExqJznGfvc7HX2PbwR7V
	 6+Hi4V8o4oTPdwcdHxTs0oUdZfVCL7hkTRp1O2M8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGXXiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Jul 2020 19:38:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgGXXiO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 24 Jul 2020 19:38:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A79A4206E3;
        Fri, 24 Jul 2020 23:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595633893;
        bh=MfqXerlTWmruPnCjXD44JMzM+C6e1M6Dp6HE1y9ZH/c=;
        h=Date:From:To:Subject:From;
        b=cMQcevUePRWtujJqVE3aQaeQM3JejDUOgOY/urhMMuUht6uvn94Lm95h0QJfihz1X
         MRVRGSrDzPDSYcVPCg1WlY/7tJyRFixF40tny9JO2H9IoHZxSRwQToSOf5h6K3/cLH
         NLtbkcJ61CfTymPebv/n7TjXytn1QKqQL9O//Tdg=
Date:   Fri, 24 Jul 2020 16:38:13 -0700
From:   akpm@linux-foundation.org
To:     jannh@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        stable@vger.kernel.org, vbabka@suse.cz, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-close-race-between-munmap-and-expand_upwards-downwards.patch removed
 from -mm tree
Message-ID: <20200724233813.pdqrWibid%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: close race between munmap() and expand_upwards()/downwards()
has been removed from the -mm tree.  Its filename was
     mm-close-race-between-munmap-and-expand_upwards-downwards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/mmap.c: close race between munmap() and expand_upwards()/downwards()

VMA with VM_GROWSDOWN or VM_GROWSUP flag set can change their size under
mmap_read_lock().  It can lead to race with __do_munmap():

	Thread A			Thread B
__do_munmap()
  detach_vmas_to_be_unmapped()
  mmap_write_downgrade()
				expand_downwards()
				  vma->vm_start = address;
				  // The VMA now overlaps with
				  // VMAs detached by the Thread A
				// page fault populates expanded part
				// of the VMA
  unmap_region()
    // Zaps pagetables partly
    // populated by Thread B

Similar race exists for expand_upwards().

The fix is to avoid downgrading mmap_lock in __do_munmap() if detached
VMAs are next to VM_GROWSDOWN or VM_GROWSUP VMA.

[akpm@linux-foundation.org: s/mmap_sem/mmap_lock/ in comment]
Link: http://lkml.kernel.org/r/20200709105309.42495-1-kirill.shutemov@linux.intel.com
Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>	[4.20+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-close-race-between-munmap-and-expand_upwards-downwards
+++ a/mm/mmap.c
@@ -2620,7 +2620,7 @@ static void unmap_region(struct mm_struc
  * Create a list of vma's touched by the unmap, removing them from the mm's
  * vma list as we go..
  */
-static void
+static bool
 detach_vmas_to_be_unmapped(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct vm_area_struct *prev, unsigned long end)
 {
@@ -2645,6 +2645,17 @@ detach_vmas_to_be_unmapped(struct mm_str
 
 	/* Kill the cache */
 	vmacache_invalidate(mm);
+
+	/*
+	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
+	 * VM_GROWSUP VMA. Such VMAs can change their size under
+	 * down_read(mmap_lock) and collide with the VMA we are about to unmap.
+	 */
+	if (vma && (vma->vm_flags & VM_GROWSDOWN))
+		return false;
+	if (prev && (prev->vm_flags & VM_GROWSUP))
+		return false;
+	return true;
 }
 
 /*
@@ -2825,7 +2836,8 @@ int __do_munmap(struct mm_struct *mm, un
 	}
 
 	/* Detach vmas from rbtree */
-	detach_vmas_to_be_unmapped(mm, vma, prev, end);
+	if (!detach_vmas_to_be_unmapped(mm, vma, prev, end))
+		downgrade = false;
 
 	if (downgrade)
 		mmap_write_downgrade(mm);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


