Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B92FC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjBJA4e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjBJAzL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174C66F21E
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8FA3B82396
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB47C433EF;
        Fri, 10 Feb 2023 00:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990448;
        bh=2RpTJ0Nwyvn2KXwqsQ3yCKZ7VhiRXFeuN91AWUlG6dM=;
        h=Date:To:From:Subject:From;
        b=fBC7R+rIX2XbcQ8FfEJZ/EIZwOWcfoLpayMYEClSBZgh54S2boioJDzdQ2sqrut91
         HN68napO+aOgrLT0H7r+yiyCJ/P73IBbHtt/++K+jwbVgBx5r6833Bj5rjFFsJx+e6
         Ll/XmWTDkyatmLNBN1QBQcacz2hfTdLCKx+FLa/A=
Date:   Thu, 09 Feb 2023 16:54:08 -0800
To:     mm-commits@vger.kernel.org, mhocko@suse.com, 42.hyeyoo@gmail.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch removed from -mm tree
Message-Id: <20230210005408.7DB47C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: introduce vm_flags_reset_once to replace WRITE_ONCE vm_flags updates
has been removed from the -mm tree.  Its filename was
     mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: introduce vm_flags_reset_once to replace WRITE_ONCE vm_flags updates
Date: Tue, 31 Jan 2023 16:01:16 -0800

Provide vm_flags_reset_once() and replace the vm_flags updates which used
WRITE_ONCE() to prevent compiler optimizations.

Link: https://lkml.kernel.org/r/20230201000116.1333160-1-surenb@google.com
Fixes: 0cce31a0aa0e ("mm: replace vma->vm_flags direct modifications with modifier calls")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    7 +++++++
 mm/mlock.c         |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates
+++ a/include/linux/mm.h
@@ -642,6 +642,13 @@ static inline void vm_flags_reset(struct
 	vm_flags_init(vma, flags);
 }
 
+static inline void vm_flags_reset_once(struct vm_area_struct *vma,
+				       vm_flags_t flags)
+{
+	mmap_assert_write_locked(vma->vm_mm);
+	WRITE_ONCE(ACCESS_PRIVATE(vma, __vm_flags), flags);
+}
+
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
--- a/mm/mlock.c~mm-introduce-vm_flags_reset_once-to-replace-write_once-vm_flags-updates
+++ a/mm/mlock.c
@@ -380,7 +380,7 @@ static void mlock_vma_pages_range(struct
 	 */
 	if (newflags & VM_LOCKED)
 		newflags |= VM_IO;
-	vm_flags_reset(vma, newflags);
+	vm_flags_reset_once(vma, newflags);
 
 	lru_add_drain();
 	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
@@ -388,7 +388,7 @@ static void mlock_vma_pages_range(struct
 
 	if (newflags & VM_IO) {
 		newflags &= ~VM_IO;
-		vm_flags_reset(vma, newflags);
+		vm_flags_reset_once(vma, newflags);
 	}
 }
 
_

Patches currently in -mm which might be from surenb@google.com are


