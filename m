Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A3DC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447A064EFA
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhBYT16 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:27:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234234AbhBYTZi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:25:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942F064F72;
        Thu, 25 Feb 2021 19:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280487;
        bh=Vv5Zp5PcWrEGLrWUy571CJIrJbqUoGb7ntwr/kxV4qY=;
        h=Date:From:To:Subject:From;
        b=EaSp6OTckyMhoZpa8U1E5CefXFere2jEg6/i5FieXq4uX/kJfW5w/icVwUv5ev3Ta
         BSt0uNWLwaAuMIPq/U7hS5qBEFqgC1ZRHi1fCa3J0xCwC5/pfWdDmy6ijKu3dDyDAt
         Upkwysdkhl0L4I74nmt2cgQBNmnqlaI5R6ewh2WU=
Date:   Thu, 25 Feb 2021 11:14:47 -0800
From:   akpm@linux-foundation.org
To:     ahuang12@lenovo.com, david@redhat.com, jrdr.linux@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-mmap-remove-unnecessary-local-variable.patch
 removed from -mm tree
Message-ID: <20210225191447.hu3f6d1S-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: remove unnecessary local variable
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-unnecessary-local-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Adrian Huang <ahuang12@lenovo.com>
Subject: mm/mmap.c: remove unnecessary local variable

The local variable 'retval' is assigned just for once in __do_sys_brk(),
and the function returns the value of the local variable right after the
assignment.  Remove unnecessary assignment and local variable declaration.

Link: https://lkml.kernel.org/r/20201222103249.30683-1-adrianhuang0701@gmail.com
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-unnecessary-local-variable
+++ a/mm/mmap.c
@@ -189,7 +189,6 @@ static int do_brk_flags(unsigned long ad
 		struct list_head *uf);
 SYSCALL_DEFINE1(brk, unsigned long, brk)
 {
-	unsigned long retval;
 	unsigned long newbrk, oldbrk, origbrk;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *next;
@@ -281,9 +280,8 @@ success:
 	return brk;
 
 out:
-	retval = origbrk;
 	mmap_write_unlock(mm);
-	return retval;
+	return origbrk;
 }
 
 static inline unsigned long vma_compute_gap(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from ahuang12@lenovo.com are


