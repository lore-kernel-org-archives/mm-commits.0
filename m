Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437CCC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 15:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiFCPpO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 11:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245610AbiFCPpN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 11:45:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753142FFC3
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 08:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61D2DB8236F
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 15:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027F7C385A9;
        Fri,  3 Jun 2022 15:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654271108;
        bh=1ujxF9YWGrGeWoQCzzJ5AfkdIG26PsFiwBmKUImRKY4=;
        h=Date:To:From:Subject:From;
        b=iK+SE+YHOBrKi4mDnDXGl0RBl+fbfKFeymDXJyzptbBh/vuMyWdyC8k/aR1YfUTik
         i6ruyE5AxoySlqD0ZZgi4YYyOaNzAYAY+xANpV9h0JPw3X2fVfs27MvVngytlAn5I4
         2uMLI6osSQaJQv4/85xZcSnQkIbI9+BexBD9zPd8=
Date:   Fri, 03 Jun 2022 08:45:07 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-drop-oom-code-from-exit_mmap-fix.patch removed from -mm tree
Message-Id: <20220603154508.027F7C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-drop-oom-code-from-exit_mmap-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-oom-code-from-exit_mmap-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-oom-code-from-exit_mmap-fix
Date: Wed Jun  1 03:07:59 PM PDT 2022

fix it for presence of mapletree patchset, per Suren

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mmap.c~mm-drop-oom-code-from-exit_mmap-fix
+++ a/mm/mmap.c
@@ -3232,7 +3232,6 @@ void exit_mmap(struct mm_struct *mm)
 
 	trace_exit_mmap(mm);
 	__mt_destroy(&mm->mm_mt);
-	mm->mmap = NULL;
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
squashfs-implement-readahead-checkpatch-fixes.patch

