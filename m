Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8060CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 20:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244902AbiESU6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 16:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242402AbiESU6v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 16:58:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E4AEC334
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 13:58:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 609F561CE1
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 20:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BFCC385AA;
        Thu, 19 May 2022 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652993929;
        bh=e0fwILUjCbDL76C+i1doJ3FgWToaAQtqDJXbBZ5Kt1g=;
        h=Date:To:From:Subject:From;
        b=pdYT1UNb44Ni2lFeuKPMobqerSAe5OkoiXY3Bsk/pg9xZBTMY2reuU8475e/xiREw
         8eDN4eFT/2bJN0pEvcYZbNufSOsTxXnxQgk7IjYHUJgXjdFb2wR5+4aYh3My9DMv/O
         yjoUokFVbdS3wgGT8vfVgl/hgi9Hi5dz98Tm2jSM=
Date:   Thu, 19 May 2022 13:58:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch removed from -mm tree
Message-Id: <20220519205849.B9BFCC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-swap-fix-the-comment-of-get_kernel_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-the-comment-of-get_kernel_pages-fix.patch

This patch was dropped because it was folded into mm-swap-fix-the-comment-of-get_kernel_pages.patch

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
Cc: Oscar Salvador <osalvador@suse.de>
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

mm-swap-fix-the-comment-of-get_kernel_pages.patch
tmpfs-fix-undefined-behaviour-in-shmem_reconfigure-fix.patch
mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
kexec_file-drop-weak-attribute-from-arch_kexec_apply_relocations-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

