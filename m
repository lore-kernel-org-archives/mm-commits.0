Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD943B6C1D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439032; cv=none; b=H8ReSsoZ9i5/PAcRmqzcPobKfbToC6V9k4uFkP/Ig6WlYTre5AybzBg2f9g1WncStmuCCcg4BeFzPXmwGVBODQg4hSZxX5KBzLMp5QNmLg5TVq5IDGlpFhSBdKRZedyPsyWE/3aCmvQ918S+FZNnTtHe9ISzP2t8y0acAAOpdN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439032; c=relaxed/simple;
	bh=AyvdQt0M8DmPW0BdGJ8vc+vRXbI90UY0ABQ6D90+Ess=;
	h=Date:To:From:Subject:Message-Id; b=jA+Bu7MvqMBfFNVYgUZ9Nx8xPBM6KDd2cL2kLff3pbgAsGDqZl0brqqRV7AnLI/W+JQ6BqjSaFxokFecXJaJgV2puOZTNUmrTdFDekMqHJnv7lBpYT2s9BGaimyuaZnFXrgWIsgN90jtUNNQ2U3oAuG6KzLg3FJj9FSKNp13Kgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=piOqhIfW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="piOqhIfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D97D1F00893;
	Tue,  2 Jun 2026 22:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439030;
	bh=9gfMW9+h9w6a3fQY8LqgAyaoSkmENXsn3hj6zyD4yUM=;
	h=Date:To:From:Subject;
	b=piOqhIfWv39toC0MzDIXGLWenS3aqMkG+8wdDLr/3bbPDC1eecMwH8QJousKOuL78
	 FDw2wFQa9JI2S+VODCrXf5fVopmjOBKxJrql6V5irONjRpzQnhMs6V+x7nCaWImSyW
	 24TRuDjL06DHRrjHrBXqh22a2Fsd8nlI2fGaBhT8=
Date: Tue, 02 Jun 2026 15:23:49 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-percpu-internalh-optimise-pcpu_chunk-struct-to-save-memory.patch removed from -mm tree
Message-Id: <20260602222350.4D97D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu-internal.h: optimise pcpu_chunk struct to save memory
has been removed from the -mm tree.  Its filename was
     mm-percpu-internalh-optimise-pcpu_chunk-struct-to-save-memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zenghongling <zenghongling@kylinos.cn>
Subject: mm/percpu-internal.h: optimise pcpu_chunk struct to save memory
Date: Mon, 11 May 2026 15:03:09 +0800

Using pahole, we can see that there are some padding holes in the current
pcpu_chunk structure,Adjusting the layout of pcpu_chunk can reduce these
holes,decreasing its size from 192 bytes to 128 bytes and eliminating a
wasted cache line.

With allmodconfig (CONFIG_PERCPU_STATS + NEED_PCPUOBJ_EXT)
Before:
 /* size: 256, cachelines: 4, members: 19 */

After:
 /* size: 192, cachelines: 3, members: 19 */

with NEED_PCPUOBJ_EXT
Before:
struct pcpu_chunk {
        struct list_head           list;                 /*     0    16 */
        int                        free_bytes;           /*    16     4 */
        struct pcpu_block_md       chunk_md;             /*    20    32 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int *        bound_map;            /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        void *                     base_addr __attribute__((__aligned__(64))); /*    64     8 */
        long unsigned int *        alloc_map;            /*    72     8 */
        struct pcpu_block_md *     md_blocks;            /*    80     8 */
        void *                     data;                 /*    88     8 */
        bool                       immutable;            /*    96     1 */
        bool                       isolated;             /*    97     1 */

        /* XXX 2 bytes hole, try to pack */

        int                        start_offset;         /*   100     4 */
        int                        end_offset;           /*   104     4 */

        /* XXX 4 bytes hole, try to pack */

        struct obj_cgroup * *      obj_cgroups;          /*   112     8 */
        int                        nr_pages;             /*   120     4 */
        int                        nr_populated;         /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        int                        nr_empty_pop_pages;   /*   128     4 */

        /* XXX 4 bytes hole, try to pack */

        long unsigned int          populated[];          /*   136     0 */

        /* size: 192, cachelines: 3, members: 17 */
        /* sum members: 122, holes: 4, sum holes: 14 */
        /* padding: 56 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));

After:
struct pcpu_chunk {
	struct list_head           list;                 /*     0    16 */
	int                        free_bytes;           /*    16     4 */
	struct pcpu_block_md       chunk_md;             /*    20    32 */

	/* XXX 4 bytes hole, try to pack */

	long unsigned int *        bound_map;            /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	void *                     base_addr __attribute__((__aligned__(64))); /*    64     8 */
	long unsigned int *        alloc_map;            /*    72     8 */
	struct pcpu_block_md *     md_blocks;            /*    80     8 */
	void *                     data;                 /*    88     8 */
	bool                       immutable;            /*    96     1 */
	bool                       isolated;             /*    97     1 */

	/* XXX 2 bytes hole, try to pack */

	int                        start_offset;         /*   100     4 */
	int                        end_offset;           /*   104     4 */
	int                        nr_pages;             /*   108     4 */
	int                        nr_populated;         /*   112     4 */
	int                        nr_empty_pop_pages;   /*   116     4 */
	struct obj_cgroup * *      obj_cgroups;          /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	long unsigned int          populated[];          /*   128     0 */

	/* size: 128, cachelines: 2, members: 17 */
	/* sum members: 122, holes: 2, sum holes: 6 */
	/* forced alignments: 1 */
} __attribute__((__aligned__(64)));

Link: https://lore.kernel.org/20260511070309.44044-1-zenghongling@kylinos.cn
Signed-off-by: zenghongling <zenghongling@kylinos.cn>
Suggested-by: Dennis Zhou <dennis@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/percpu-internal.h~mm-percpu-internalh-optimise-pcpu_chunk-struct-to-save-memory
+++ a/mm/percpu-internal.h
@@ -77,13 +77,13 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+	int			nr_pages;	/* # of pages served by this chunk */
+	int			nr_populated;	/* # of populated pages */
+	int                     nr_empty_pop_pages; /* # of empty populated pages */
 #ifdef NEED_PCPUOBJ_EXT
 	struct pcpuobj_ext	*obj_exts;	/* vector of object cgroups */
 #endif
 
-	int			nr_pages;	/* # of pages served by this chunk */
-	int			nr_populated;	/* # of populated pages */
-	int                     nr_empty_pop_pages; /* # of empty populated pages */
 	unsigned long		populated[];	/* populated bitmap */
 };
 
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are


