Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62FFFC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 17 May 2022 23:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiEQXkH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 May 2022 19:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiEQXkG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2022 19:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFF453B4D
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 16:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7866140B
        for <mm-commits@vger.kernel.org>; Tue, 17 May 2022 23:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93BAC385B8;
        Tue, 17 May 2022 23:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652830804;
        bh=9/TUA06D4iC7Jxb9Z6jlZu0V5p+IZ9mX7VWPc+nsbqI=;
        h=Date:To:From:Subject:From;
        b=1eyZwz+8KqWV+EG0qDZyQu3UHxo8uI0PbhzL9cthKk6ALBBBuKZ/uFoQWbN2Bp5Ih
         lfnvsgd0JFq8U+UFll/g3LFyYOgjBW0ML6Lf5IlGPhvjZ4uFHDcEkLB2sYxNyoYS7W
         kPR5knTK5p/bMhngRWlKpbLUGiKvah7+zcjX40sY=
Date:   Tue, 17 May 2022 16:40:04 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch added to mm-unstable branch
Message-Id: <20220517234004.C93BAC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-the-comment-of-get_kernel_pages-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-fix-the-comment-of-get_kernel_pages-fix
Date: Tue May 17 04:36:31 PM PDT 2022

s/nr_pages/nr_segs/ also, per David, reflow comment

Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swap.c~mm-swap-fix-the-comment-of-get_kernel_pages-fix
+++ a/mm/swap.c
@@ -166,10 +166,10 @@ EXPORT_SYMBOL(put_pages_list);
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_segs long.
  *
- * Returns number of pages pinned. This may be fewer than the number
- * requested. If nr_pages is 0 or negative, returns 0. If no pages
- * were pinned, returns 0. Each page returned must be released with
- * a put_page() call when it is finished with.
+ * Returns number of pages pinned. This may be fewer than the number requested.
+ * If nr_segs is 0 or negative, returns 0.  If no pages were pinned, returns 0.
+ * Each page returned must be released with a put_page() call when it is
+ * finished with.
  */
 int get_kernel_pages(const struct kvec *kiov, int nr_segs, int write,
 		struct page **pages)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-swap-avoid-calling-swp_swap_info-when-try-to-check-swp_stable_writes-fix.patch
mm-swap-add-helper-swap_offset_available-fix.patch
mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

