Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E54226CFE
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 01:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772761660; cv=none; b=DoOKR2S6R+P5FG+bLhmMvjuw0zZPBsbxgPh22jZusasGXxDQlTwOnnA02WVibnXdv9lG0Y5Jw/6SRGcLr/OnMZhlh5fSS/HC9cCcMOEakaRMVLE7d3H6hbTBKch3mNnXQVboi5qk6bqRsDSjgO8EGSE1fHeKMBKkTJoQrDVXA78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772761660; c=relaxed/simple;
	bh=oe2URUUYqAJI1ok/3Q+sbD2WqAZjyNGgxlj1VYgq9Nk=;
	h=Date:To:From:Subject:Message-Id; b=uakQV5DHrBDi069m8qJ/rzxWAYxZFiK+7vsVJulWPeea0s50cIV6yPyBBSKRSn43/9FtoRHO6DeJKMr4d7bUWHpv+HTjzue38Iro65RsRdvzxV88CdNVKnc8ipednVLjZmvBMQhKnQyPlqczoN5AoIE99T4G1Kw+tTqWgthwb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mBUiHGPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mBUiHGPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D1EC2BC87;
	Fri,  6 Mar 2026 01:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772761660;
	bh=oe2URUUYqAJI1ok/3Q+sbD2WqAZjyNGgxlj1VYgq9Nk=;
	h=Date:To:From:Subject:From;
	b=mBUiHGPfWL970H1SW6/asj4xl3Imd2dcyyKvT/MeQNhMupNiAz0YDBqHVmKmWeR3/
	 qjkMyVFohvmaHzs5DZSGiqhfmNUF/FsgJjGAaR0o/Zlx1O8lVN/uPuF+nacmM4uyQI
	 25AeZK23n7ryGa8h2gQhZahjHUpxf1dbOy4N0mRs=
Date: Thu, 05 Mar 2026 17:47:39 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,dennis@kernel.org,cl@gentwo.org,zenghongling@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch added to mm-new branch
Message-Id: <20260306014739.F3D1EC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory
has been added to the -mm mm-new branch.  Its filename is
     mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-percpu-internalh-optimise-pcpu_chunk_struct-to-save-memory.patch

