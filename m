Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33537C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E76E2078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266065;
	bh=qKNDJbNmhD8SWaDyRYYTuBIilz3M9cgGDzicuyrKttU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cNSAljHnwuYt/BlzsXE3N/gWdoAcoiCWCaJ/GwM8K92LbA/mWsevQiGEUiaqRYIm9
	 Pljuij8d6YYcTqlzwzWhPnpPTzrHBiYYXPUiC2NgZwyQEBhdrf3pvA0U2n0X7YaYxo
	 4FuxE04P/wNZA0S/AcqqYR1qE2aWKvenry2msOWs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgHLVBE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgHLVBE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:04 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E7A20768;
        Wed, 12 Aug 2020 21:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266063;
        bh=qKNDJbNmhD8SWaDyRYYTuBIilz3M9cgGDzicuyrKttU=;
        h=Date:From:To:Subject:From;
        b=H9ZMljEh5Hjq2vi04xRuLf720Je49aQJ1DbnuGZwBA64DpspUQUFGHwVCAx1iO5C7
         OBq6RdCYK8qnorMHIP5mycC9PA9WlRojWuLqwwyxTxm26tkQ2wmWD2bQ3vQmGb34JL
         qokMvF/Q5HsmCZFLRVkcmmzlJ/jLcGXKsOGEX7MQ=
Date:   Wed, 12 Aug 2020 14:01:02 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, cuibixuan@huawei.com, dennis@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, vbabka@suse.cz
Subject:  [merged]
 percpu-return-number-of-released-bytes-from-pcpu_free_area.patch removed
 from -mm tree
Message-ID: <20200812210102.kFzc6GvKP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: return number of released bytes from pcpu_free_area()
has been removed from the -mm tree.  Its filename was
     percpu-return-number-of-released-bytes-from-pcpu_free_area.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Roman Gushchin <guro@fb.com>
Subject: percpu: return number of released bytes from pcpu_free_area()

Patch series "mm: memcg accounting of percpu memory", v3.

This patchset adds percpu memory accounting to memory cgroups.  It's based
on the rework of the slab controller and reuses concepts and features
introduced for the per-object slab accounting.

Percpu memory is becoming more and more widely used by various subsystems,
and the total amount of memory controlled by the percpu allocator can make
a good part of the total memory.

As an example, bpf maps can consume a lot of percpu memory, and they are
created by a user.  Also, some cgroup internals (e.g.  memory controller
statistics) can be quite large.  On a machine with many CPUs and big
number of cgroups they can consume hundreds of megabytes.

So the lack of memcg accounting is creating a breach in the memory
isolation.  Similar to the slab memory, percpu memory should be accounted
by default.

Percpu allocations by their nature are scattered over multiple pages, so
they can't be tracked on the per-page basis.  So the per-object tracking
introduced by the new slab controller is reused.

The patchset implements charging of percpu allocations, adds memcg-level
statistics, enables accounting for percpu allocations made by memory
cgroup internals and provides some basic tests.

To implement the accounting of percpu memory without a significant memory
and performance overhead the following approach is used: all accounted
allocations are placed into a separate percpu chunk (or chunks).  These
chunks are similar to default chunks, except that they do have an attached
vector of pointers to obj_cgroup objects, which is big enough to save a
pointer for each allocated object.  On the allocation, if the allocation
has to be accounted (__GFP_ACCOUNT is passed, the allocating process
belongs to a non-root memory cgroup, etc), the memory cgroup is getting
charged and if the maximum limit is not exceeded the allocation is
performed using a memcg-aware chunk.  Otherwise -ENOMEM is returned or the
allocation is forced over the limit, depending on gfp (as any other kernel
memory allocation).  The memory cgroup information is saved in the
obj_cgroup vector at the corresponding offset.  On the release time the
memcg information is restored from the vector and the cgroup is getting
uncharged.  Unaccounted allocations (at this point the absolute majority
of all percpu allocations) are performed in the old way, so no additional
overhead is expected.

To avoid pinning dying memory cgroups by outstanding allocations,
obj_cgroup API is used instead of directly saving memory cgroup pointers.=
=20
obj_cgroup is basically a pointer to a memory cgroup with a standalone
reference counter.  The trick is that it can be atomically swapped to
point at the parent cgroup, so that the original memory cgroup can be
released prior to all objects, which has been charged to it.  Because all
charges and statistics are fully recursive, it's perfectly correct to
uncharge the parent cgroup instead.  This scheme is used in the slab
memory accounting, and percpu memory can just follow the scheme.


This patch (of 5):

To implement accounting of percpu memory we need the information about the
size of freed object.  Return it from pcpu_free_area().

Link: http://lkml.kernel.org/r/20200623184515.4132564-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200608230819.832349-1-guro@fb.com
Link: http://lkml.kernel.org/r/20200608230819.832349-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tobin C. Harding <tobin@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
cC: Michal Koutn=C3=BDutny@suse.com>
Cc: Bixuan Cui <cuibixuan@huawei.com>
Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/percpu.c~percpu-return-number-of-released-bytes-from-pcpu_free_area
+++ a/mm/percpu.c
@@ -1211,11 +1211,14 @@ static int pcpu_alloc_area(struct pcpu_c
  *
  * This function determines the size of an allocation to free using
  * the boundary bitmap and clears the allocation map.
+ *
+ * RETURNS:
+ * Number of freed bytes.
  */
-static void pcpu_free_area(struct pcpu_chunk *chunk, int off)
+static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
 {
 	struct pcpu_block_md *chunk_md =3D &chunk->chunk_md;
-	int bit_off, bits, end, oslot;
+	int bit_off, bits, end, oslot, freed;
=20
 	lockdep_assert_held(&pcpu_lock);
 	pcpu_stats_area_dealloc(chunk);
@@ -1230,8 +1233,10 @@ static void pcpu_free_area(struct pcpu_c
 	bits =3D end - bit_off;
 	bitmap_clear(chunk->alloc_map, bit_off, bits);
=20
+	freed =3D bits * PCPU_MIN_ALLOC_SIZE;
+
 	/* update metadata */
-	chunk->free_bytes +=3D bits * PCPU_MIN_ALLOC_SIZE;
+	chunk->free_bytes +=3D freed;
=20
 	/* update first free bit */
 	chunk_md->first_free =3D min(chunk_md->first_free, bit_off);
@@ -1239,6 +1244,8 @@ static void pcpu_free_area(struct pcpu_c
 	pcpu_block_update_hint_free(chunk, bit_off, bits);
=20
 	pcpu_chunk_relocate(chunk, oslot);
+
+	return freed;
 }
=20
 static void pcpu_init_md_block(struct pcpu_block_md *block, int nr_bits)
_

Patches currently in -mm which might be from guro@fb.com are

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

