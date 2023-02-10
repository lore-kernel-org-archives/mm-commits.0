Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF8FC05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjBJAwq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjBJAwi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:52:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0DE6D8E2
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A78161BA3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7272CC433D2;
        Fri, 10 Feb 2023 00:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990356;
        bh=5HrEAC0MkQAEYsU3QZRBxseUNYjZMLbsVafxF9UuyZw=;
        h=Date:To:From:Subject:From;
        b=juEL+dzlnIllbFE0NHP3l2u7M7W76Bahltgg0vyHlZ9vTZ6y3EUe7pUaBwKDeOFdB
         WVz/Kl6/Y3kCWNhedgC675JV9KURdF+whl61xU0xDQHNm+EESs+quxUcpnf1j/8HrO
         2gAL7+YfqzH491Yp2BDCuRyX8UyqT80SA2al0znY=
Date:   Thu, 09 Feb 2023 16:52:35 -0800
To:     mm-commits@vger.kernel.org, Liam.Howlett@oracle.com,
        Liam.Howlett@Oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch removed from -mm tree
Message-Id: <20230210005236.7272CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mmap: remove preallocation from do_mas_align_munmap()
has been removed from the -mm tree.  Its filename was
     mm-mmap-remove-preallocation-from-do_mas_align_munmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/mmap: remove preallocation from do_mas_align_munmap()
Date: Fri, 20 Jan 2023 11:26:12 -0500

In preparation of passing the vma state through split, the pre-allocation
that occurs before the split has to be moved to after.  Since the
preallocation would then live right next to the store, just call store
instead of preallocating.  This effectively restores the potential error
path of splitting and not munmap'ing which pre-dates the maple tree.

Link: https://lkml.kernel.org/r/20230120162650.984577-12-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/mmap.c~mm-mmap-remove-preallocation-from-do_mas_align_munmap
+++ a/mm/mmap.c
@@ -2329,9 +2329,6 @@ do_mas_align_munmap(struct ma_state *mas
 	mt_init_flags(&mt_detach, MT_FLAGS_LOCK_EXTERN);
 	mt_set_external_lock(&mt_detach, &mm->mmap_lock);
 
-	if (mas_preallocate(mas, GFP_KERNEL))
-		return -ENOMEM;
-
 	mas->last = end - 1;
 	/*
 	 * If we need to split any vma, do it now to save pain later.
@@ -2422,8 +2419,6 @@ do_mas_align_munmap(struct ma_state *mas
 			goto userfaultfd_error;
 	}
 
-	/* Point of no return */
-	mas_set_range(mas, start, end - 1);
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
 	{
@@ -2431,6 +2426,7 @@ do_mas_align_munmap(struct ma_state *mas
 		struct vm_area_struct *vma_mas, *vma_test;
 		int test_count = 0;
 
+		mas_set_range(mas, start, end - 1);
 		rcu_read_lock();
 		vma_test = mas_find(&test, end - 1);
 		mas_for_each(mas, vma_mas, end - 1) {
@@ -2440,10 +2436,13 @@ do_mas_align_munmap(struct ma_state *mas
 		}
 		rcu_read_unlock();
 		BUG_ON(count != test_count);
-		mas_set_range(mas, start, end - 1);
 	}
 #endif
-	mas_store_prealloc(mas, NULL);
+	/* Point of no return */
+	mas_set_range(mas, start, end - 1);
+	if (mas_store_gfp(mas, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
 	mm->map_count -= count;
 	/*
 	 * Do not downgrade mmap_lock if we are next to VM_GROWSDOWN or
@@ -2475,7 +2474,6 @@ end_split_failed:
 	__mt_destroy(&mt_detach);
 start_split_failed:
 map_count_exceeded:
-	mas_destroy(mas);
 	return error;
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


