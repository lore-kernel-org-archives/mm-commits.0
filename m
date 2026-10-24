Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832350;
	b=mCMkiUDHBPDeM7puYSfN5+5+0NVsw3GoLmX0k3QFVB+qbpD+DelwYHnNRYDrP1bX+S6t
	 nSkH7iwTmNLwLnFhJtMRbhmvZdsSjwe7QSFJbSKbIAHrEqZuuOdQYOtZCedoJ5x7lvR7T
	 qUVoItIOPOEWH14GYaWZt596iJRCrYfjncD7g8bHJ700aEIGeD9AvDcZd3mBqBJLN4pHT
	 1JdQvuH0GP1HpF1/JsPxA4eKkcGiq7oOM/zHbTCj1TaiUhibYRH/aXtPhY80qW7MHUULL
	 PMkoBpE9hvPwQsMemEoi4hMjAruSaIYlROjwGYRHVZho/RRC+q6uUaPLZKxYXk2Xk0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832350;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=F10QTamX4UWdDNJ4eVwBQod6ppbYJuWkbE5nX8JBEmo=;
	b=DzaTeKtLJiRXSIFos2dt6XVZ+zXD1Y/MK15vK1LbCjfT2uNX3pqHpKblWC+nPU9le4Sv
	 lc4Xw4QRRdZMcK04DJYbyPLsDNjuf8nOpUXQfTQjc5Wjj+WcMgZWBa/MNAxJWNF4FpkjU
	 YstjvxHCdwbX3mw3YtYUrCE3l4rha7jy2S7YKFz9iZzYl2lKDsd3C3hgJI2SNJXw9H5ej
	 5H6P+a4wmnYqN+LaSCAtQZav6ml6h3LzMTODk58kbBj9+UyPLutBgrLx/ZKdM1X3vhkPP
	 utV9HCZJkbdZKo7SqgINlggs3EHURhPFkZPJGs08H8IiWz1ksVrUM9ExHv+HadN2JHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cGoBxhea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00426606A31A;
	Sat, 24 Oct 2026 08:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cGoBxhea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD98D1F01828;
	Sat, 24 Oct 2026 08:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832349;
	bh=F10QTamX4UWdDNJ4eVwBQod6ppbYJuWkbE5nX8JBEmo=;
	h=Date:To:From:Subject;
	b=cGoBxheacieLthK/D4XrZECDO3A0ne+VN28nsvR+BdE3cu/ywO0X34Dz46zvMp7q0
	 34x+op7s01/5BtSc9xuBqdb6C/aGSQ7UotDsUNn9Jl9QWEF4U4n/shn6xk8TjlRLXK
	 kM/gYHGc4Dlh6JDKdzdSedWUcNMTkxgZZ1LMB+t8=
Date: Sat, 24 Oct 2026 01:59:09 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,riel@redhat.com,ngocthang2710.1999@gmail.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,benh@kernel.crashing.org,a.p.zijlstra@chello.nl,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch removed from -mm tree
Message-Id: <20261024085909.BD98D1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
has been removed from the -mm tree.  Its filename was
     mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: disallow ioremap'ing ordinary RAM in generic_access_phys()
Date: Tue, 13 Oct 2026 13:41:24 +0200

generic_access_phys() can end up getting called on CoW PFNMAP mappings,
resulting in it trying to ioremap anonymous folios, which especially
the x86 code doesn't enjoy, and which is in general just odd/wrong.

E.g., with a CoW mapping of a PCI BAR:

ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

But more generically, we should disallow access to anything that looks
like ordinary RAM in the system: including allocating memory (e.g.,
alloc_pages) and mapping them in a VM_PFNMAP.

For pages with an online memmap, allow only pages marked as reserved
(PageReserved). This also includes memblock allocations, however,
distinguishing them from other MMIO is tricky, and nobody should really
be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
do not care about).

So only allow access if there is no online memmap, or if the pages are
marked reserved. Reject other pages with -EINVAL.

Note that, just like other pfn_to_online_page() users, we won't care about
concurrent memory offlining; mapping memory that can concurrently get
offlined is highly dubious.

Link: https://lore.kernel.org/20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org
Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>
---

 mm/memory.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/memory.c~mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys
+++ a/mm/memory.c
@@ -7129,6 +7129,7 @@ int generic_access_phys(struct vm_area_s
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
 	void __iomem *maddr;
+	struct page *page;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
@@ -7143,6 +7144,19 @@ int generic_access_phys(struct vm_area_s
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
+
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(args.pfn);
+	if (page && !PageReserved(page)) {
+		follow_pfnmap_end(&args);
+		return -EINVAL;
+	}
+
 	prot = args.pgprot;
 	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
 	writable = args.writable;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

