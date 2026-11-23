Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415120;
	b=ZOVUsTGyurMl58q2OfoGtUlVA/MXS9YNk0I84EolwDPrvk2GATlD9mc7SO75Y3Vro/Mh
	 aPskEWDpQ0SgqG7LWkSHHHMogG8VEfSRVVBsxb35Jjp6+UGsB2x9k13esTHJnci6k0wla
	 IyPzpbiIv9tgv5BdGdIVMs5RS5fU3+uotbJTIdtfzVHnDj+LqydpBE/PeRZ1S3FOs4jAw
	 oiPHeYbaW3v4UO+eQL2YX9gMdQggnpyJ/xZgckYZu+vaSHnEYRvU3klYuOvcMVwm7H7Ld
	 SE1ASNhYrq6G53K9XFmcXrpsqolq39GJKnuHR4qbPiGIdbuGnIMzdoWm3ccaQ5SLx6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415120;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=KEWB1bPj4Lxhrg8yrNzYVE5Gbaq1Z3832SVQQ7O0i4E=;
	b=py9EFRoyXCChaxECIvvahxjmbV0b/cRnxSG3InAXpIrIP/AOBupcXyKVJ6ki3wAZnrJ7
	 qpvj0QwgC+5mJaZdWNWNCnEyALSRJTBJrozakp+5297iDlO32GCwF/49aN5Oo4K1HlH6V
	 0rBuAb8LFMw6r04L1c4zO6WtEM3npSPaY6z1Jid56uFHss1pL+itx40FQWzD9bFdiaH5Q
	 I39IpbPv7EreGWPuyeu+WiphUHddAIKBW09EN/GqY50AefeZ455gDWuUqWt9jzqHCfH9/
	 Gj7IvaniKc+AGYf6xUsJGH57A3Uzg6ZcyPSp9QsynGSz5NE47oMa9iZyye5hXWbv/0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NekzyAWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD54F606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 06:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NekzyAWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D611D1F000C0;
	Mon, 23 Nov 2026 06:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415120;
	bh=KEWB1bPj4Lxhrg8yrNzYVE5Gbaq1Z3832SVQQ7O0i4E=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=NekzyAWH0UCFJfYU2geDbGAXq4slUq33PTJE1W8yYs+Gh7QoMoRPrYMjy6pRLUuUh
	 1wO18fOjv0gq0mkcr+t/sXFsJNjy2A9t3xxZL/t+uZcI0vo86Glylm7f5CWULSwjm/
	 UUKZjx6t0Y+g4gwA/PjN3lGz07rvFYgJeeQjk1D8=
Date: Sun, 22 Nov 2026 22:25:19 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,
	mhocko@suse.com,liam@infradead.org,jannh@google.com,david@kernel.org,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
Subject: [merged mm-hotfixes-stable] maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch removed from -mm tree
Message-Id: <20261123062519.D611D1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: MAINTAINERS: consolidate the memory mapping entries into a VMA entry
has been removed from the -mm tree.  Its filename was
     maintainers-consolidate-the-memory-mapping-entries-into-a-vma-entry.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://patch.msgid.link/20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Liam R. Howlett (Google) <liam@infradead.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: SJ Park <sj@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
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

mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch

