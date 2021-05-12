Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A89BC433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D444C61073
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 22:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhELWjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 18:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1391738AbhELVbJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 17:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E47261106;
        Wed, 12 May 2021 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620854993;
        bh=9tS4WeX5GmWsOriPzI/Xqxi6GEY3bMO31/MQBPuY1Wk=;
        h=Date:From:To:Subject:From;
        b=X4j1t9Y9YxTpKN7DnJIn+fTeklTcBgJdtM+oTbhPqrIWZ0jPem+idnWLu9dA94/L6
         W50d3G9ObcCkKAWzCSbBfTV4YeF3Ib0B5A7qixtbIEdCNz6SVUZwhZcKG1h3ASRi+S
         /1r+6LQaUIEvveFW6N545WoMojTwYx8XvB2C4N0Q=
Date:   Wed, 12 May 2021 14:29:52 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  + binfmt-remove-in-tree-usage-of-map_executable-fix.patch
 added to -mm tree
Message-ID: <20210512212952.NMwm3J6ej%akpm@linux-foundation.org>
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

 fs/binfmt_aout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_aout.c~binfmt-remove-in-tree-usage-of-map_executable-fix
+++ a/fs/binfmt_aout.c
@@ -222,7 +222,7 @@ static int load_aout_binary(struct linux
 
 		error = vm_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
 			PROT_READ | PROT_EXEC,
-			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE;
+			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE,
 			fd_offset);
 
 		if (error != N_TXTADDR(ex))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-improve-mprotectrw-efficiency-on-pages-referenced-once-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch

