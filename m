Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA5233F383
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775087911; cv=none; b=hlBnHKOi/WL/G6Bqgurbcn42lbxUf8QlteGKAcITOuMTyTtsILrzwGIy5OJu8e6kyR2mc2lrCWrMsHRu6YU6YVJ97sYMXG1bTPS4cDDe/EveKin1GLw//c5urBJcGw5M2tlIbaa/hzZux5y+UIGEn/8IufU2Vx7id14hGirAJ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775087911; c=relaxed/simple;
	bh=K0VcogqtQed+3y9PROAc0BelFFxV7bzYlfE40JC18E4=;
	h=Date:To:From:Subject:Message-Id; b=d9dPLyZiYcDntNCjJPJ/IMmcTERSh7qW/jnnCmv18tju90KrAvbqjiF4yA1KsyMQR/8JVJb7KsF68CCgsqLl25Vvkh2Buoi79pqHk2lj/q0zzGx/us5s/M28VsHvMI2HjR1sdVkzQTb1d6zhnry+PlbWrwBsR4TWAECg9I7OeFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VAI9N7KG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VAI9N7KG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5F7C116C6;
	Wed,  1 Apr 2026 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775087910;
	bh=K0VcogqtQed+3y9PROAc0BelFFxV7bzYlfE40JC18E4=;
	h=Date:To:From:Subject:From;
	b=VAI9N7KG+kKhRGUwcn99X1r5M+3E4fBWTKl76xfo/iLWqfdukVc63hmo3QKldbAUo
	 d7Syaf5kdre4P239mlFKAIQ+12iuLMMFQckyqQNGIgDpnSrSBfgnQczkvSPqHE6LYH
	 iLsD3zLinj1t6iWl3rxZ57+PQXr8bPAOGyPiXIkY=
Date: Wed, 01 Apr 2026 16:58:29 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch removed from -mm tree
Message-Id: <20260401235830.6A5F7C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
has been removed from the -mm tree.  Its filename was
     mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: zenghongling <zenghongling@kylinos.cn>
Subject: mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
Date: Thu, 5 Mar 2026 15:30:43 +0800

The pcpu_chunk_struct has a hole of 4 bytes and pushes the struct to three
cachelines.  Relocating the three booleans upwards allows for the struct
to only use two cachelines.

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
        int                        nr_empty_pop_pages;   /*   108     4 */
        struct obj_cgroup * *      obj_cgroups;          /*   112     8 */
        int                        nr_pages;             /*   120     4 */
        int                        nr_populated;         /*   124     4 */
        /* --- cacheline 2 boundary (128 bytes) --- */
        long unsigned int          populated[];          /*   128     0 */

        /* size: 128, cachelines: 2, members: 17 */
        /* sum members: 122, holes: 2, sum holes: 6 */
        /* forced alignments: 1 */
} __attribute__((__aligned__(64)));

Link: https://lkml.kernel.org/r/20260305073043.571691-1-zenghongling@kylinos.cn
Signed-off-by: zenghongling <zenghongling@kylinos.cn>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/percpu-internal.h~mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory
+++ a/mm/percpu-internal.h
@@ -77,13 +77,13 @@ struct pcpu_chunk {
 	int			end_offset;	/* additional area required to
 						   have the region end page
 						   aligned */
+	int                     nr_empty_pop_pages; /* # of empty populated pages */
 #ifdef NEED_PCPUOBJ_EXT
 	struct pcpuobj_ext	*obj_exts;	/* vector of object cgroups */
 #endif
 
 	int			nr_pages;	/* # of pages served by this chunk */
 	int			nr_populated;	/* # of populated pages */
-	int                     nr_empty_pop_pages; /* # of empty populated pages */
 	unsigned long		populated[];	/* populated bitmap */
 };
 
_

Patches currently in -mm which might be from zenghongling@kylinos.cn are


