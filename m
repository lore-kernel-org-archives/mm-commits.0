Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0789C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A165361CED
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhF2Ab3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232170AbhF2AbZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A8C461CED;
        Tue, 29 Jun 2021 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926538;
        bh=0rx3zOgSYXfBURJDmx+yWB90H1FGCjaGzVdb4GgoKHE=;
        h=Date:From:To:Subject:From;
        b=V+TAWYHK/sU/5gt3mjCSqPuBZ6rE1CH7cCzjLYCZZ9cB0dWAjad7Wol4qPrszQPZ+
         9ZdNX4AKx7LdtdEmlm55JhweFJZ0MFF8/qlGBLWOY8zMmaq/QQR/RDzWRanpvQbXUT
         +SipGnQpUrSbnjXSIKmbDiCsZ7Kw4l1L6TE6JjE4=
Date:   Mon, 28 Jun 2021 17:28:58 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 binfmt-remove-in-tree-usage-of-map_executable-fix.patch removed from -mm
 tree
Message-ID: <20210629002858.VW_KZLlt5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt-remove-in-tree-usage-of-map_executable-fix
has been removed from the -mm tree.  Its filename was
     binfmt-remove-in-tree-usage-of-map_executable-fix.patch

This patch was dropped because it was folded into binfmt-remove-in-tree-usage-of-map_executable.patch

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

binfmt-remove-in-tree-usage-of-map_executable.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
kernel-cgroup-cgroupc-dont-export-cgroup_get_e_css-twice.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

