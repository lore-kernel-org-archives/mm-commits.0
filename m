Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037788;
	b=RHCmBz+v10eom2iPQ7hKFzsVyVCvE49Btm6OLqIf5fyy5N0xyw8GcVrTekwlJHVxHe24
	 1rRyJ1v2/o/iDlvZHPiGhiT6SPL+eCRXvr0yJc7NBAfJvxbjYIVlYuYDZBA4+RxiB3+AW
	 O8qqVpvo0QPLNuurWfvI2zdqDlsWUMu+X6PSKXm54X3zAn+SdR8Zrs8X39RDb0elwpXgD
	 wG75/pUAjk48nCHHXnaJ7pOtJfD89D6roay2NF3BCkSf0uQ/sT7ZizNPog63a50wzE0R1
	 PZ8tfVdIRhxjGVHRf5+r7F32UDpFz6XRMs7kZwoQHQcP2wSgcbPBR4XB/RhRvl7y9sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037788;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Zzw7F+Dc2UKLeBvLurgnio6+EJe3XGt/CsT3Kzdth0Q=;
	b=3TTiDCJ3Jx2RMEamjUa5qeUfrs6Vq2Z5/hHHpZDXqXvflAfLFADg280D3S6el4s9GaFt
	 BzIPPl25CLFpdudT6m8LpLzpwdNgEHS7m5DrZyFug9PiBHx8dq/4Q9R6cIkcVXyMScTqv
	 aHKLYUUHamLiPrEVq0V+8lIZDAVhj6hNEGwrL9oD+1w262CfGM/MVY9R/2kGPVaenwXlj
	 mN68ydj9DpaQcWn4XIod2Yc9yNXbbWpPxEm1Bk3tyOxUCVGr1vDnZKiF2yE4sPTO57Wu1
	 kQpU/Q/UKdRzPEPzW18pgJ9zYLAtEeEu7iSOaSxT6gYNupIynmtmlq8tcZhb4bs1Hqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ryFTIm5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31A7606A320
	for <mm-commits@vger.kernel.org>; Wed, 18 Nov 2026 21:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ryFTIm5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394AC1F000C4;
	Wed, 18 Nov 2026 21:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795037788;
	bh=Zzw7F+Dc2UKLeBvLurgnio6+EJe3XGt/CsT3Kzdth0Q=;
	h=Date:To:From:Subject;
	b=ryFTIm5n+b0ocni4NFTSiRXKwt9u0/N6Fjj061nkcY6FQZUYBNn29R1MnLKr3pc9T
	 6ic/RWkKLBUDKKFo7c3GrRJnXSaNJT4ID/XWAB3AWulnI64t9cTbQJUr7McXQGyi7q
	 azrfpArAFxyVSXhIjPfvBVcmfwu9g2SU5x9O5A/k=
Date: Wed, 18 Nov 2026 13:36:27 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	liam@infradead.org,jannh@google.com,david@kernel.org,ljs@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch added to mm-hotfixes-unstable branch
Message-Id: <20261118213628.394AC1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: MAINTAINERS: consolidate the memory mapping entries into a VMA entry
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: consolidate the memory mapping entries into a VMA entry
Date: Wed, 18 Nov 2026 18:22:10 +0000

Memory mapping entries were kept in three different sections in order that
those maintaining/reviewing each distinct part would be made responsible
for/cc'd on only those parts.

However this creates confusion as to what files belong to which component,
so simplify things by consolidating them into one.

Expand Suren's maintainership to the entire component, as he is a trusted
and valued member of the VMA kernel team and very much deserving of the
position.

Additionally, drop Suren's core and misc reviewerships in order to focus
upon VMA.

As David is receiving pull requests directly, make him a reviewer, purely
as an administrative change.

Also specify the new tree location in preparation for the tree being
established for next cycle, and remove the link to the not so regularly
updated linux-mm website.

Given that, from next cycle, the tree will sit outside of Andrew's current
process, remove his entry, also purely as an administrative change.

With that said, I'd like to take the opportunity to express gratitude for
Andrew's huge contribution to mm, and for his being both generous and
gracious throughout this period of change in the subsystem.

Link: https://lore.kernel.org/20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Liam R. Howlett (Google) <liam@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>

 MAINTAINERS |   51 ++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

--- a/MAINTAINERS~maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry
+++ a/MAINTAINERS
@@ -17507,7 +17507,6 @@ M:	David Hildenbrand <david@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
-R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17677,7 +17676,6 @@ M:	David Hildenbrand <david@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
-R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17969,30 +17967,37 @@ F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 F:	rust/kernel/page.rs
 
-MEMORY MAPPING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
+MEMORY MANAGEMENT - VMA
 M:	Lorenzo Stoakes <ljs@kernel.org>
+M:	Liam R. Howlett <liam@infradead.org>
+M:	Suren Baghdasaryan <surenb@google.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Pedro Falcato <pfalcato@suse.de>
+R:	David Hildenbrand <david@kernel.org>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/vma.git for-next
 F:	Documentation/core-api/protection-keys.rst
 F:	Documentation/filesystems/mmap_prepare.rst
+F:	Documentation/mm/process_addrs.rst
 F:	Documentation/userspace-api/mseal.rst
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
 F:	include/linux/mman.h
+F:	include/linux/mmap_lock.h
 F:	include/linux/pkeys.h
 F:	include/trace/events/mmap.h
+F:	include/trace/events/mmap_lock.h
+F:	include/uapi/asm-generic/mman-common.h
 F:	include/uapi/linux/mman.h
 F:	mm/char-mem.c
+F:	mm/madvise.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
+F:	mm/mmap_lock.c
 F:	mm/mprotect.c
 F:	mm/mremap.c
 F:	mm/mseal.c
@@ -18006,36 +18011,6 @@ F:	mm/vma_internal.h
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
-MEMORY MAPPING - LOCKING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Shakeel Butt <shakeel.butt@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/mm/process_addrs.rst
-F:	include/linux/mmap_lock.h
-F:	include/trace/events/mmap_lock.h
-F:	mm/mmap_lock.c
-
-MEMORY MAPPING - MADVISE (MEMORY ADVICE)
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	include/uapi/asm-generic/mman-common.h
-F:	mm/madvise.c
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from ljs@kernel.org are

maintainers-remove-myself-from-mm-core-reviewership.patch
maintainers-remove-myself-from-mm-misc-reclaim-reviewership.patch
maintainers-remove-myself-from-mm-rust-reviewerships.patch
credits-add-entry-for-thp-maintenance.patch
maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

