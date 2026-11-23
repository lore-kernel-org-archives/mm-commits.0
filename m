Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795459849;
	b=N/bscZomeqmUERYb6/vAHCmLeSOS1KXl0HeqHkVbGtFmmmHgcOo8K1emi3xI52TI2NuX
	 tmUKoR2WM3+b/+xxDsq48FUGhia+5RiQ4ipUSmmAo2tPJ4TrSCPxHLxl3gJW/Wp6nB3ti
	 K90WjI+k3EXA9bwJzeJD3eibP1Cfq6eO7vR93GPk2kma3ItGf1U1k2CEoCgHS1GcvJfDO
	 YNg2Z7Okwj1kk4eKwb4KS5S7SU0h1rdvDWhzs8Chz6oQvJCRxmAFs7XAdwKYO+L86+0a3
	 OpBIqhOkeG/r7Hu6cN3M/wMrqHmQTT9lpnf7S+/3OYSlgD5/qFgAeEMvtbELonrAh/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795459849;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=9DxXihB4lts3JwRneHlu+aLlZwEWZsg+BxouZl7qLdg=;
	b=CodYoc0uc7+GLEL5A2/SZjTtGNFxmeFmVtsxTfCxRExbOjPPZYRMDHkFwCXuFiJaei5K
	 UTjOhVdSen5ik760lHnzcrHMBjsItgJA6/l3y8oTzb0WOxMn/0MVaXOQaTRp/8Gyh04xh
	 5etB1F8p2ZcsZU9OJbFrZFHj4euL0xKC4Biey/krUouxvjX8flbJlfCtUU8YkBvxghju9
	 z2KnVlTjQUoPbt+vIKvCJWm2hz7FSMCretxw5KaN7mi8q9+peUIefJ4sHdKYJYlV+qYGV
	 TYB3pI2ssuVyttOhqO/JRJL4MCSYgJ30LpJPVo3DJay/reMRgE59dStNikqmuHxZsmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZEZmnjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7928B606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 18:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FZEZmnjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD771F000D1;
	Mon, 23 Nov 2026 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459848;
	bh=9DxXihB4lts3JwRneHlu+aLlZwEWZsg+BxouZl7qLdg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FZEZmnjla98dQjax1gQJgWuD9z/vXdCxGfc6qNXuyNTPOcjX/vKb4CGcA7ZmYRlhN
	 5vWxkGnub1Snqbfw0GfQ1SDNfJy6cSE23GSiEId5JRvCuh7lHNKMLFujlKUNuDEHVu
	 nqnsPkzIm53/04wOz5fYjAuDFJykDWUDOhX+FPd3suElWgYSLwf1uYDmRhq10HufMZ
	 Oc0s9K4f7aA14x6gIsYFjMAKcelnlsreAfBX/N4sU0hfrA6Jorzfw9jidQhQ0Vt8CK
	 9EVECFexb7A6DbgxmkjXncEjMgRL4s4LK0mjzBSpgrvJWNBcXmZtZny6uNU1A/PHa2
	 Mc+gENAvbK1WA==
Message-ID: <16e3b64f-1f12-4f4c-862c-056c7acbdb3e@kernel.org>
Date: Mon, 23 Nov 2026 19:50:44 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <a2b9c99e-b5d3-428a-9b9f-0761b352dbfd@kernel.org>
 <20261123103453.953259f94d3c5a0fae1c50c6@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261123103453.953259f94d3c5a0fae1c50c6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/26 19:34, Andrew Morton wrote:
> On Mon, 23 Nov 2026 18:33:36 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:
>>
>>   include/linux/alloc_tag.h
>>
>> between the commit:
>>
>>   dbbc5a3d50f9 mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT
>>
>> from the page_alloc/page_alloc/for-next branch and the commit:
>>
>>   2cc623f19566 mm/vmscan: move vmscan tracepoints to a local header
>>
>> from the akpm/mm-unstable branch.
>>
>> The conflict doesn't make any sense, because we're really touching something very unrelated.
>> It's likely a merge config problem on my end.
>>
>> I resolved the conflicts manually for now and shall investigate:

Scrap the above, it's more complicated. I managed to confuse myself ... and I
learned just the hard way the limitations of git rerere :)

The following would be the right email:

----------

Hi,

today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:

  mm/vmscan.c

between the commits:

  dbbc5a3d50f9 mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT

from the page_alloc/page_alloc/for-next branch and the commit:

  2cc623f19566 mm/vmscan: move vmscan tracepoints to a local header
  b87fab0ca9ce mm/vmscan: move struct scan_control to a dedicated header

from the akpm/mm-unstable branch.

I resolved the conflicts manually:


diff --git a/mm/vmscan.c b/mm/vmscan.c
index e94d58aa2626..672b339c7bc5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -72,122 +72,7 @@
 #include "swap.h"

 #define CREATE_TRACE_POINTS
-<<<<<<< HEAD
-#include <trace/events/vmscan.h>
-
-struct scan_control {
-     /* How many pages shrink_list() should reclaim */
-     unsigned long nr_to_reclaim;
-
-     /*
-      * Nodemask of nodes allowed by the caller. If NULL, all nodes
-      * are scanned.
-      */
-     const nodemask_t *nodemask;
-
-     /*
-      * The memory cgroup that hit its limit and as a result is the
-      * primary target of this reclaim invocation.
-      */
-     struct mem_cgroup *target_mem_cgroup;
-
-     /*
-      * Scan pressure balancing between anon and file LRUs
-      */
-     unsigned long   anon_cost;
-     unsigned long   file_cost;
-
-     /* Swappiness value for proactive reclaim. Always use sc_swappiness()! */
-     int *proactive_swappiness;
-
-     /* Can active folios be deactivated as part of reclaim? */
-#define DEACTIVATE_ANON 1
-#define DEACTIVATE_FILE 2
-     unsigned int may_deactivate:2;
-     unsigned int force_deactivate:1;
-     unsigned int skipped_deactivate:1;
-
-     /* zone_reclaim_mode, boost reclaim */
-     unsigned int may_writepage:1;
-
-     /* zone_reclaim_mode */
-     unsigned int may_unmap:1;
-
-     /* zone_reclaim_mode, boost reclaim, cgroup restrictions */
-     unsigned int may_swap:1;
-
-     /* Not allow cache_trim_mode to be turned on as part of reclaim? */
-     unsigned int no_cache_trim_mode:1;
-
-     /* Has cache_trim_mode failed at least once? */
-     unsigned int cache_trim_mode_failed:1;
-
-     /* Proactive reclaim invoked by userspace */
-     unsigned int proactive:1;
-
-     /*
-      * Cgroup memory below memory.low is protected as long as we
-      * don't threaten to OOM. If any cgroup is reclaimed at
-      * reduced force or passed over entirely due to its memory.low
-      * setting (memcg_low_skipped), and nothing is reclaimed as a
-      * result, then go back for one more cycle that reclaims the protected
-      * memory (memcg_low_reclaim) to avert OOM.
-      */
-     unsigned int memcg_low_reclaim:1;
-     unsigned int memcg_low_skipped:1;
-
-     /* Shared cgroup tree walk failed, rescan the whole tree */
-     unsigned int memcg_full_walk:1;
-
-     unsigned int hibernation_mode:1;
-
-     /* One of the zones is ready for compaction */
-     unsigned int compaction_ready:1;
-
-     /* The allocation may not steal from other migratetypes' blocks */
-     unsigned int nofragment:1;
-
-     /* There is easily reclaimable cold cache in the current node */
-     unsigned int cache_trim_mode:1;
-
-     /* The file folios on the current node are dangerously low */
-     unsigned int file_is_tiny:1;
-
-     /* Always discard instead of demoting to lower tier memory */
-     unsigned int no_demotion:1;
-
-     /* Allocation order */
-     s8 order;
-
-     /* Scan (total_size >> priority) pages at once */
-     s8 priority;
-
-     /* The highest zone to isolate folios for reclaim from */
-     s8 reclaim_idx;
-
-     /* This context's GFP mask */
-     gfp_t gfp_mask;
-
-     /* Incremented by the number of inactive pages that were scanned */
-     unsigned long nr_scanned;
-
-     /* Number of pages freed so far during a call to shrink_zones() */
-     unsigned long nr_reclaimed;
-
-     struct {
-             unsigned int dirty;
-             unsigned int congested;
-             unsigned int writeback;
-             unsigned int immediate;
-             unsigned int taken;
-     } nr;
-
-     /* for recording the reclaimed slab by now */
-     struct reclaim_state reclaim_state;
-};
-=======
 #include "trace_vmscan.h"
->>>>>>> akpm/mm-unstable

 #ifdef ARCH_HAS_PREFETCHW
 static inline void prefetchw_prev_lru_folio(struct folio *folio,
diff --git a/mm/vmscan.h b/mm/vmscan.h
index c2cea36289f3..6a8f5981235f 100644
--- a/mm/vmscan.h
+++ b/mm/vmscan.h
@@ -77,6 +77,9 @@ struct scan_control {
      /* One of the zones is ready for compaction */
      unsigned int compaction_ready:1;

+     /* The allocation may not steal from other migratetypes' blocks */
+     unsigned int nofragment:1;
+
      /* There is easily reclaimable cold cache in the current node */
      unsigned int cache_trim_mode:1;

---


> 
> Ridong's series "mm/vmscan: move tracepoints to mm/ and add MGLRU
> tracepoints" is large and contains a lot of optional code movement.

Yes, the move to vmscan.h is the real problem.

> 
> So I think at this time we should drop it and ask Ridong for a much
> smaller and tighter patch[set] which just adds those MGLRU tracepoints.
> wdyt?

It's a good learning experience on my end ;) I don't care carrying the fixup
forward.

We'll just have to let Linus know about it.

Later, for changes that go through my tree (PULL requests from other components
to me), I can just fix that up when merging and nobody will ever now.

-- 
Cheers,

David
