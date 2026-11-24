Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537128;
	b=Tbn8c+eGkIsTo8+JX0Vbf5n4P8s2tjuH00MaHlx8RzchHiFqSdo7BfiUoulagUy+/OqS
	 +4b9/hv/aobMsqxS51c0t8T4CBPaPDVBvPVDz79qe7tnSShjp6fQrkHdx/IlkajU+7a45
	 7B1YOLqs7vcBBKF7NDWtlCoFH8T5LfAg0VzbsORDB12NNiEZH2bGCYCk/04cpdYCsToza
	 c5PM39whOH+6DD3vv9rfvEiBXs3PZyfQpAVRFxQ5azhsMrv1rOt0tayDR5vnhQEy15iG8
	 3jrs3Z47NcDpny5VFpmCd4X8Fi6GuPEJVsw1J4hZl4vMVcUnPGlsD9EDajUPw5WLRwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537128;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=ujMTuwPOsmr1whJF+yqRvOV96KTaU05Y6dPCwFRLQMs=;
	b=ds/S9f7xKUwWxUWA/aebqbykd3s6dQyzmvb7WmOimA2TqNewVHZ16tk+B9/7OHM5JLV7
	 I+I0O8yXH49df+8fe7f2ogJXoPR80Nw0R+JsJyYtwwZ2J51Ze3uoXzNLRXFcIB0VbZKAm
	 /DIDZB12rKhcSDsf61/a3t6/bCfiqmvYzYMLVBda8CHNgumAlDV17MPeUNu9OpZ+vI/7C
	 A+3V1mA3jybIKj+AnRh1hXw2r7sbkntL3Ea+ECjNHkD86HU9tEq6CLamQhBRFcwgFBFqv
	 bSDeC2BS6W9ukobrLcyHj2M7+B4d+/9HKss3B0hCScI+3Kj3I+gJcllL53JJkcpbMFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yjUiG9uA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DC3606A326;
	Tue, 24 Nov 2026 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=yjUiG9uA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0691F000D4;
	Tue, 24 Nov 2026 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795537128;
	bh=ujMTuwPOsmr1whJF+yqRvOV96KTaU05Y6dPCwFRLQMs=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=yjUiG9uABcG5/WVN7CU7nmnxBVAR8rh+AeleR2fTNlZt2khdUKrUs6M+WPghDGsNL
	 9Rt3ZwfvBF4yNjTfGOz0bOkJCmYEB/KvwzEmQq8dmTJ3cSQ1fzytSBCzWTGCBWtxnD
	 QKgRzjrIKJpBisoyElYP+k+lvbfyqHy04nRn0yjo=
Date: Tue, 24 Nov 2026 08:18:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yu-cheng.yu@intel.com,
	ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,
	usama.arif@linux.dev,tj@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,rientjes@google.com,
	rick.p.edgecombe@intel.com,pfalcato@suse.de,peng.fan@nxp.com,
	nphamcs@gmail.com,mhocko@suse.com,matthew.brost@intel.com,mason@kernel.org,
	liam@infradead.org,kasong@tencent.com,kas@kernel.org,joshua.hahnjy@gmail.com,
	jglisse@redhat.com,jbacik@fb.com,jannh@google.com,jack@suse.cz,
	hannes@cmpxchg.org,gourry@gourry.net,dennisszhou@gmail.com,dennis@kernel.org,
	david@kernel.org,dave.hansen@linux.intel.com,cl@gentwo.org,
	chris@chrisdown.name,byungchul@sk.com,broonie@kernel.org,bp@alien8.de,
	balbirs@nvidia.com,apopple@nvidia.com,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org>
Subject: + percpu-search-the-whole-reserved-chunk.patch added to mm-unstable branch
Message-Id: <20261124161848.2C0691F000D4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: percpu: search the whole reserved chunk
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-search-the-whole-reserved-chunk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-search-the-whole-reserved-chunk.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: percpu: search the whole reserved chunk
Date: Fri, 13 Nov 2026 21:45:30 +0000

Loading a module with static percpu data can fail with -ENOMEM even
though the reserved chunk has a free area that fits the data.

pcpu_find_block_fit() does not scan the allocation bitmap, rather it
tests the request against hints, starting with the contig_hint of the
chunk, which describes its largest free area. If that area is too small
once aligned, the search gives up even if a smaller free area fits.

Consider:

    request:      256 bytes, aligned to 256 bytes
    contig_hint:  260 bytes, starts 4 bytes after a 256-byte boundary,
                  so 8 bytes remain after alignment
    also free:    256 bytes, starts on a 256-byte boundary

Ordinarily this is fine as the allocator moves on to the next chunk or
creates a new one, but the static percpu data of modules can only come
from the reserved chunk.

Fix this by searching the allocation bitmap of the reserved chunk
directly rather than using hints.

Link: https://patch.msgid.link/20261113-mason-migrate-et-al-fixes-v2-12-50a2ed382b61@kernel.org
Fixes: 13f966373f92 ("percpu: skip chunks if the alloc does not fit in the contig hint")
Fixes: b4c2116cfae6 ("percpu: update pcpu_find_block_fit to use an iterator")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Yu, Yu-cheng <yu-cheng.yu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Mark Brown <broonie@kernel.org>
Cc: Dennis Zhou (Facebook) <dennisszhou@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: <stable@vger.kernel.org>

 mm/percpu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/percpu.c~percpu-search-the-whole-reserved-chunk
+++ a/mm/percpu.c
@@ -1778,8 +1778,11 @@ void __percpu *pcpu_alloc_noprof(size_t
 	if (reserved && pcpu_reserved_chunk) {
 		chunk = pcpu_reserved_chunk;
 
-		off = pcpu_find_block_fit(chunk, bits, bit_align, is_atomic);
-		if (off < 0) {
+		/* No other chunk to fall back on, so don't rely on hints. */
+		off = bitmap_find_next_zero_area(chunk->alloc_map,
+						 pcpu_chunk_map_bits(chunk), 0,
+						 bits, bit_align - 1);
+		if (off >= pcpu_chunk_map_bits(chunk)) {
 			err = "alloc from reserved chunk failed";
 			goto fail_unlock;
 		}
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch

