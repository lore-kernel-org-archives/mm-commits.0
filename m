Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E51C5EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjFSX0V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjFSXY2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5381519B6
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:23:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 279D060F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:23:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CD7C433C8;
        Mon, 19 Jun 2023 23:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216980;
        bh=Uy9B69SdsjaE+8kpkTR8LsMIjVeftoRcBlwtxb/GJ0U=;
        h=Date:To:From:Subject:From;
        b=CXplDNXCgthUJfoEHyqPKanEgVsTvPc7dz5NoODEuSb4uy8cC9ZeA6YbE9AftmK9c
         YNqLvlXEkoeB9vWOoYtuHzRFrZ+2nMwMiisYmN0OTlxv6jDUVXhP7VL7vMs0o0eV1T
         krwJuSnLgrsNMJZiqeY2otCNAqj1ah4PvY4L1Fvc=
Date:   Mon, 19 Jun 2023 16:23:00 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        shakeelb@google.com, Liam.Howlett@oracle.com, dennis@kernel.org,
        dave.hansen@intel.com, dan.j.williams@intel.com, yu.ma@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch removed from -mm tree
Message-Id: <20230619232300.81CD7C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: percpu-internal/pcpu_chunk: re-layout pcpu_chunk structure to reduce false sharing
has been removed from the -mm tree.  Its filename was
     percpu-internal-pcpu_chunk-re-layout-pcpu_chunk-structure-to-reduce-false-sharing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

The pcpu_chunk struct is a backing data structure per chunk, so the
additional memory should not be dramatic.  A chunk covers ballpark
between 64kb and 512kb memory depending on some config and boot time
stuff, so I believe the additional memory used here is nominal at best.

Working the #s on my desktop:
Percpu:            58624 kB
28 cores -> ~2.1MB of percpu memory.
At say ~128KB per chunk -> 33 chunks, generously 40 chunks.
Adding alignment might bump the chunk size ~64 bytes, so in total ~2KB
of overhead?

I believe we can do a little better to avoid eating that full padding,
so likely less than that.

[dennis@kernel.org: changelog details]
Link: https://lkml.kernel.org/r/20230610030730.110074-1-yu.ma@intel.com
Signed-off-by: Yu Ma <yu.ma@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
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


