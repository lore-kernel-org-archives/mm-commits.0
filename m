Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993B2C0015E
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jul 2023 20:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbjG0UIE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jul 2023 16:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjG0UHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2023 16:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A41D2D73;
        Thu, 27 Jul 2023 13:07:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DB5961F33;
        Thu, 27 Jul 2023 20:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841FAC433C9;
        Thu, 27 Jul 2023 20:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690488467;
        bh=blPfT2CLFccZ7c6S8lGzpT4AG58Myp+Y2Ve6VodSZ2w=;
        h=Date:To:From:Subject:From;
        b=evItStF7h13itikACMYrzkA3W/3URoUoA/Tl4olySVtvdekPOAkNoItCGOrdyj0mu
         zYNEohFLtLyJIOJ0RHjLRTNVUiVsRDHNqR/zzgLxn2yskoeLWArWH6v3yeTJMb7EfK
         VbMYxX75tm+E2c3stOke3Vz+P/IBqQo/dSO4jSHM=
Date:   Thu, 27 Jul 2023 13:07:46 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        stable@vger.kernel.org, jannh@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-lock-vma-in-dup_anon_vma-before-setting-anon_vma.patch removed from -mm tree
Message-Id: <20230727200747.841FAC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: lock VMA in dup_anon_vma() before setting ->anon_vma
has been removed from the -mm tree.  Its filename was
     mm-lock-vma-in-dup_anon_vma-before-setting-anon_vma.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm: lock VMA in dup_anon_vma() before setting ->anon_vma
Date: Fri, 21 Jul 2023 05:46:43 +0200

When VMAs are merged, dup_anon_vma() is called with `dst` pointing to the
VMA that is being expanded to cover the area previously occupied by
another VMA.  This currently happens while `dst` is not write-locked.

This means that, in the `src->anon_vma && !dst->anon_vma` case, as soon as
the assignment `dst->anon_vma = src->anon_vma` has happened, concurrent
page faults can happen on `dst` under the per-VMA lock.  This is already
icky in itself, since such page faults can now install pages into `dst`
that are attached to an `anon_vma` that is not yet tied back to the
`anon_vma` with an `anon_vma_chain`.  But if `anon_vma_clone()` fails due
to an out-of-memory error, things get much worse: `anon_vma_clone()` then
reverts `dst->anon_vma` back to NULL, and `dst` remains completely
unconnected to the `anon_vma`, even though we can have pages in the area
covered by `dst` that point to the `anon_vma`.

This means the `anon_vma` of such pages can be freed while the pages are
still mapped into userspace, which leads to UAF when a helper like
folio_lock_anon_vma_read() tries to look up the anon_vma of such a page.

This theoretically is a security bug, but I believe it is really hard to
actually trigger as an unprivileged user because it requires that you can
make an order-0 GFP_KERNEL allocation fail, and the page allocator tries
pretty hard to prevent that.

I think doing the vma_start_write() call inside dup_anon_vma() is the most
straightforward fix for now.

For a kernel-assisted reproducer, see the notes section of the patch mail.

Link: https://lkml.kernel.org/r/20230721034643.616851-1-jannh@google.com
Fixes: 5e31275cc997 ("mm: add per-VMA lock and helper functions to control it")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mmap.c~mm-lock-vma-in-dup_anon_vma-before-setting-anon_vma
+++ a/mm/mmap.c
@@ -615,6 +615,7 @@ static inline int dup_anon_vma(struct vm
 	 * anon pages imported.
 	 */
 	if (src->anon_vma && !dst->anon_vma) {
+		vma_start_write(dst);
 		dst->anon_vma = src->anon_vma;
 		return anon_vma_clone(dst, src);
 	}
_

Patches currently in -mm which might be from jannh@google.com are

mm-dont-drop-vma-locks-in-mm_drop_all_locks.patch

