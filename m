Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832479;
	b=OxgxqfAYcIp4pQjv1s5kP0kmq2of4UX6+vCo7jwka3J5nIxPNwytEMYXrlP20PktQM8+
	 nMoYTeNrakRahKG+dY/tFPXahjzPfEpBR6yDGSgtN+d3hgqp/6Ox3JLcYDX+5xQ520Try
	 65MFMAMxQpPHeHPNwIsgW1RSqfZMZJr9XxkjIPorUfyb6XhkB+8Pp9wG0J7kIP6XAEQuc
	 nvG5bZKyfUvn5RnGsCMKFDkf4eALss5n6zxaNVfn3xpFv4J41FWuecNuzu3EZN0lDs0B/
	 oRJ+jRmQxoJ+7uP5NJDWxebTowwvHwEWGgRvFIxJxZ4WFpRMwz9CLpFS+ZEDYOOnPEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832479;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Ygs2gS63nehHpViLH/964ePr7KigD1a218bAO5G2CEw=;
	b=MfkuWfB4bSTHi+/a9DcrLw96q4IqlZJGMPQfptYA0yA8WyRWUEsXHH4dJKh6tt/OAKft
	 s65qTArTdkwQ3NDcRDEGgwPPwPlU17fSn0nGWwkdGr1Sm2dlQgFJ8PrjAsrFCaAU9F4o0
	 OqFGUYX+jdhiIXAmtRF5uZWSUI4u+obOf05OpP+Sywf834XN8Mzka1n1XI2cg8bMu9cKc
	 6UXJNIniIR7IjYNnsumcr/Mp5ahkMr9OsRR9p+hARs4d8VLa/HGz8bPrdE6HTWRjqoUFw
	 61fFXxBBXuhzAeiPw5igh4BDQKCrmDRkP7BM9rbKcjfmMnCF30EQ0hBKjJq8VsuRCCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LMcxwTCF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E35606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LMcxwTCF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F0A1F01825;
	Sat, 24 Oct 2026 09:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832478;
	bh=Ygs2gS63nehHpViLH/964ePr7KigD1a218bAO5G2CEw=;
	h=Date:To:From:Subject;
	b=LMcxwTCFemiQ2+v4yIsbBT7TMmXgnseA6pVhB5FXoDHseLZN44NoWB3uS4EIwbu5D
	 /tZmZYLnnEzAuBFPamQYFF+9jpLWtvxrwy58aZPtQ48upvxQWnjPV/OiIzA+K5yj5V
	 2lZ4PjYv53Tgqz2DtLr2v7h1754d1SwVVJ+zVmgg=
Date: Sat, 24 Oct 2026 02:01:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,ryan.roberts@arm.com,nico.pache@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch removed from -mm tree
Message-Id: <20261024090118.B3F0A1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Wed, 14 Oct 2026 18:11:34 +0100

Patch series "mm/collapse: separate a collapse from its callers", v5.

There is no line between the collapse engine and the callers that ask for
a collapse.  khugepaged.c holds both, and they reach into each other.

 - Sixteen tests through the collapse path read cc->is_khugepaged to work
   out what they are allowed to do, when every one of those decisions was
   made by the caller before it asked.

 - collapse_single_pmd() does both halves of a collapse behind one call.
   Where it gives up mmap_lock between them is buried in the anonymous
   scan on one side and ahead of the file scan on the other.

Start drawing the line.  The caller states what it allows in a policy,
and the collapse code reads the policy instead of asking who called.  The
scan of a PTE table and the collapse that follows get a function each,
with the mmap_lock drop between them in one place.


This patch (of 9):

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Link: https://lore.kernel.org/20261014171145.3292736-1-kas@kernel.org
Link: https://lore.kernel.org/20261014171145.3292736-2-kas@kernel.org
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Assisted-by: LLM
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse
+++ a/mm/khugepaged.c
@@ -3255,7 +3255,6 @@ int madvise_collapse(struct vm_area_stru
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3311,7 +3310,6 @@ out_maybelock:
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
_

Patches currently in -mm which might be from kas@kernel.org are


