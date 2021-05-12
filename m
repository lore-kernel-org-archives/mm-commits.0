Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCADEC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A426D61439
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhELWkO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 18:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1392572AbhELWe0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 18:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABAEA61406;
        Wed, 12 May 2021 22:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620858797;
        bh=9htrXOgAfnImzpve4QBlXIS/MXOIneLxrqbZRsp5CF8=;
        h=Date:From:To:Subject:From;
        b=I2vNkBustF59ZKVk9pWb6S/HjfIo7OSifEOsDKvQ4C8NHhnineFaZbyq+5iJPGo6y
         7PmK2g+pG2Dy9AVRePZWsDv+4QnbLQrrEraptff34cl95BKCDuU8X+b1AR2b0feP+Z
         yqMmYdBUSfJ81zV6ToCQs1f/VQeaTlAAnZbfWcnk=
Date:   Wed, 12 May 2021 15:33:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + binfmt-remove-in-tree-usage-of-map_executable-fix.patch
 added to -mm tree
Message-ID: <20210512223317.5TNmy7wxA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt-remove-in-tree-usage-of-map_executable-fix
has been added to the -mm tree.  Its filename is
     binfmt-remove-in-tree-usage-of-map_executable-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/binfmt-remove-in-tree-usage-of-map_executable-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/binfmt-remove-in-tree-usage-of-map_executable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: binfmt-remove-in-tree-usage-of-map_executable-fix

fix blooper in fs/binfmt_aout.c. per David

Cc: David Hildenbrand <david@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_aout.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/binfmt_aout.c~binfmt-remove-in-tree-usage-of-map_executable-fix
+++ a/fs/binfmt_aout.c
@@ -222,7 +222,7 @@ static int load_aout_binary(struct linux
 
 		error = vm_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 			PROT_READ | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE;
+			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 			fd_offset);
 
 		if (error != N_TXTADDR(ex))
@@ -230,7 +230,7 @@ static int load_aout_binary(struct linux
 
 		error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
-				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE;
+				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 				fd_offset + ex.a_text);
 		if (error != N_DATADDR(ex))
 			return error;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

