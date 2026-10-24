Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832501;
	b=ZUWqYjTrY5SugttCmaQzJ6u9bFQe87RR2T+P5c2ubnJmgM3tGaeHjOC1zDEYnRQRmrko
	 IFLa5R24Iw/4myxsdGlsw7PDaxralRXbWfxefVSQ4dz7wGRxZnbLYs692ixxLxIEkwJLW
	 a41Xz9J5eoi0bHfRND7MCE8OMDZc+w8t2LcmNTLOO6gUOEacJJFl8QfoB7rSenRgyNzlV
	 +pWTd/ijVunFM0hdoGVVmt8Skxrok9Km9LrBIiWArp6hLeLutX1yDo5lzyRLtJpbqwLZF
	 4CAvPobUy/F+etZsgMwGPUkHeCS8LHzOjYduJbhR73TjnLa2BO/QoYZKHZycbvnJOKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832501;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=4sWD1vyIwN3tAxumMIbAH0g2DWGSfisa4PVHqIiMTiU=;
	b=HrVW+ulAoNRGLAPg9P0kagibD7b4QV+tXJcb1takAK4IkoeJaWmWfiXVpWGZYsbRuerk
	 ir+s1OcCBxIp8XkaEuldp09wqTbSrKu+uPEzwldqPhyDgVV1GA180/pji5CLPnFkN1lQV
	 NuSU1r2/9e7YLsCmTaSyYzZQmujLMzgAjaJcwI82rqlNe8zvNIt+slKUAeEtR9IOeYGUm
	 oxvoBLydkBC5+3cHY3DIz218xF2OEugP51fZCktcj4MBENG9tYSIcufrB2/V0Dg0A8IfT
	 eRyzXwlzfaaDzHlsqblm/2z7hHiOuprGjLrjCcN3C81i9C8xvgy0OrRQhaF66XhQdIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2FjfArkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ABB606A31A;
	Sat, 24 Oct 2026 09:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=2FjfArkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB1D1F01828;
	Sat, 24 Oct 2026 09:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832501;
	bh=4sWD1vyIwN3tAxumMIbAH0g2DWGSfisa4PVHqIiMTiU=;
	h=Date:To:From:Subject;
	b=2FjfArkf3GIvjDv+klO8pgNMPQVStlx2E2ERM/bV9pnG2Abmq34K11WvbRxHIsOd7
	 NvDd1pxCnqO7FaIn8facEPm3J3yyCyNM8eTdCeUnU71hRSSD5IsEiRf41JHJVPvmoJ
	 j4RlYEUhq1tK5UaHjx0Tweq50iTpD4WMDFvten1c=
Date: Sat, 24 Oct 2026 02:01:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch removed from -mm tree
Message-Id: <20261024090141.6BB1D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/mlock: use a long for the page count in mlock_fixup()
has been removed from the -mm tree.  Its filename was
     mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: mm/mlock: use a long for the page count in mlock_fixup()
Date: Wed, 14 Oct 2026 09:13:58 -0400

mlock_fixup() adjusts mm->locked_vm, an unsigned long, by the number of
pages whose VM_LOCKED state it changes, but computes that number in an
int:

	int nr_pages;
	...
	nr_pages = (end - start) >> PAGE_SHIFT;
	...
	mm->locked_vm += nr_pages;

When a single VMA range of 2^31 pages (8 TiB with 4 KiB pages) or more
is locked or unlocked, the count is truncated to 32 bits and then
sign-extended, so locked_vm is changed by the wrong amount, while
munmap(), mremap() and the other paths that maintain locked_vm use the
full unsigned long page count.

Such a range is reachable on 64-bit architectures with a 47-bit or
larger user address space (x86_64, arm64 with 48-bit VA, riscv64 Sv48)
by a task with CAP_IPC_LOCK or a raised RLIMIT_MEMLOCK, which do_mlock()
checks against the full untruncated length.  It costs nothing with
MAP_NORESERVE and MLOCK_ONFAULT/MCL_ONFAULT, since then no page is
populated.  On x86_64, after

	p = mmap(NULL, 8UL << 40, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
	mlock2(p, 8UL << 40, MLOCK_ONFAULT);

VmLck in /proc/self/status reads 18446744065119617024 kB instead of
8589934592 kB; munmap() of the region then subtracts the true size and
leaves VmLck at 18446744056529682432 kB instead of 0.  With 16 TiB,
locked_vm is not changed at all, VmLck stays 0 kB, and after the task
drops CAP_IPC_LOCK or lowers RLIMIT_MEMLOCK, mlock(), mmap(MAP_LOCKED)
and the other mlock_future_ok() and account_locked_vm() users enforce
RLIMIT_MEMLOCK against that count, so they let the task lock memory
beyond its limit (or, in the 8 TiB case, refuse every further lock).
The error persists for the life of the mm; unlocking the range in pieces
skews it further.  The wrong count is per-mm accounting only: it does
not change which pages are locked.

The int has been there since before git history (the variable was named
"pages" until it was renamed in 2.6.28); every other updater of
locked_vm uses an unsigned long or long count.  Make nr_pages a long,
which holds the page count of any user range and its negation, so the
existing sign handling is unchanged.

Found by formal verification of mm/mlock.c against the kernel binary.

Link: https://lore.kernel.org/20261014131358.780240-1-nickolai@csail.mit.edu
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Assisted-by: LLM
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mlock.c~mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup
+++ a/mm/mlock.c
@@ -457,7 +457,7 @@ static int mlock_fixup(struct vma_iterat
 {
 	const vma_flags_t old_vma_flags = vma->flags;
 	struct mm_struct *mm = vma->vm_mm;
-	int nr_pages;
+	long nr_pages;
 	int ret = 0;
 
 	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

