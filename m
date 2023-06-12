Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46BC7C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjFLVno (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbjFLVnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C466118
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C84E62E99
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC109C433D2;
        Mon, 12 Jun 2023 21:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686606221;
        bh=ic+l2I5W3x/vpAdClb+UA8S/MxrGD8JJACUm+qULebY=;
        h=Date:To:From:Subject:From;
        b=vn3rTJflgLGvoZo/0gTkrr/NsIaGvQsAsxMu0yVWj5rwI1FirA3b0Nsl5exxDWdMC
         lEyOA2eFR3ZgE+2dN9io49wOwcxqFac1ZsG+baS9arivjSs9Pg9IRWI5aMFdNS7rmu
         fMXlV0exH0q7PFLthgpFTHu8Mg9a5RoFrjLg65pU=
Date:   Mon, 12 Jun 2023 14:43:40 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        shakeelb@google.com, Liam.Howlett@oracle.com, dennis@kernel.org,
        dave.hansen@intel.com, dan.j.williams@intel.com, yu.ma@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch added to mm-unstable branch
Message-Id: <20230612214340.DC109C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu-internal/pcpu_chunk: re-layout pcpu_chunk structure to reduce false sharing
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch

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
From: Yu Ma <yu.ma@intel.com>
Subject: percpu-internal/pcpu_chunk: re-layout pcpu_chunk structure to reduce false sharing
Date: Fri, 9 Jun 2023 23:07:30 -0400

When running UnixBench/Execl throughput case, false sharing is observed
due to frequent read on base_addr and write on free_bytes, chunk_md.

UnixBench/Execl represents a class of workload where bash scripts are
spawned frequently to do some short jobs.  It will do system call on execl
frequently, and execl will call mm_init to initialize mm_struct of the
process.  mm_init will call __percpu_counter_init for percpu_counters
initialization.  Then pcpu_alloc is called to read the base_addr of
pcpu_chunk for memory allocation.  Inside pcpu_alloc, it will call
pcpu_alloc_area to allocate memory from a specified chunk.  This function
will update "free_bytes" and "chunk_md" to record the rest free bytes and
other meta data for this chunk.  Correspondingly, pcpu_free_area will also
update these 2 members when free memory.

Call trace from perf is as below:
+   57.15%  0.01%  execl   [kernel.kallsyms] [k] __percpu_counter_init
+   57.13%  0.91%  execl   [kernel.kallsyms] [k] pcpu_alloc
-   55.27% 54.51%  execl   [kernel.kallsyms] [k] osq_lock
   - 53.54% 0x654278696e552f34
        main
        __execve
        entry_SYSCALL_64_after_hwframe
        do_syscall_64
        __x64_sys_execve
        do_execveat_common.isra.47
        alloc_bprm
        mm_init
        __percpu_counter_init
        pcpu_alloc
      - __mutex_lock.isra.17

In current pcpu_chunk layout, `base_addr' is in the same cache line with
`free_bytes' and `chunk_md', and `base_addr' is at the last 8 bytes.  This
patch moves `bound_map' up to `base_addr', to let `base_addr' locate in a
new cacheline.

With this change, on Intel Sapphire Rapids 112C/224T platform, based on
v6.4-rc4, the 160 parallel score improves by 24%.

Link: https://lkml.kernel.org/r/20230610030730.110074-1-yu.ma@intel.com
Signed-off-by: Yu Ma <yu.ma@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/percpu-internal.h~percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing
+++ a/mm/percpu-internal.h
@@ -41,10 +41,17 @@ struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
 	int			free_bytes;	/* free bytes in the chunk */
 	struct pcpu_block_md	chunk_md;
-	void			*base_addr;	/* base address of this chunk */
+	unsigned long		*bound_map;	/* boundary map */
+
+	/*
+	 * base_addr is the base address of this chunk.
+	 * To reduce false sharing, current layout is optimized to make sure
+	 * base_addr locate in the different cacheline with free_bytes and
+	 * chunk_md.
+	 */
+	void			*base_addr ____cacheline_aligned_in_smp;
 
 	unsigned long		*alloc_map;	/* allocation map */
-	unsigned long		*bound_map;	/* boundary map */
 	struct pcpu_block_md	*md_blocks;	/* metadata blocks */
 
 	void			*data;		/* chunk data */
_

Patches currently in -mm which might be from yu.ma@intel.com are

percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch

