Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC6628DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489808; cv=none; b=vAhI4pAOcpHvHx9RAJMV/hMP9SxRi/Mpi7LTthrDAB4U2O0tjLhS4XHyeCMTWBphPPx4VGMZDPov3P8BoeaLnQxr4ZSnVQirlim2TScommTRRjCVWGG8fd2C7ykjzuTnR3x8wt7bF1JKEGfiWVaJK/kt3kNI7+C2P+I7es2aKVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489808; c=relaxed/simple;
	bh=Qd3UoNw0EDeCO2LY1sNv7Tw/kWp11l8ztG/elT8a9CA=;
	h=Date:To:From:Subject:Message-Id; b=OCTDfM7ack6crz0PoLs42Y7kWcwJXmZYfRvOGD9nyloB1qAadLl8yiPR8+Y5yJo6ETfD3IJxUFJ04ioDELW3G9zb6qY8Jj5ztQRX593UM5CLrT5i1ETo/KQ6qSOU0p0989CrzyVU2CjlNSpD3on/0HhL6H7znq1wwIxtkT2Xi1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L5F+rubf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L5F+rubf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DEEC4CEE7;
	Sun, 21 Sep 2025 21:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489808;
	bh=Qd3UoNw0EDeCO2LY1sNv7Tw/kWp11l8ztG/elT8a9CA=;
	h=Date:To:From:Subject:From;
	b=L5F+rubf/wsJUk9gv7m+n0nOQ5zQ9yimf8WNS1qnMgn6Hsdt4P441KsZBRFCsEcok
	 +beYjvXg/kr+r9vdJJXlSNO6INu0leoZSBOETdo8wSG+3lDEXJrm8Knppr2oMXgCGi
	 L2F4p4aapKYYc1sIqEt1BMusedd1Hrzo4IJWrf0M=
Date: Sun, 21 Sep 2025 14:23:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yishaih@nvidia.com,will@kernel.org,vbabka@suse.cz,ulf.hansson@linaro.org,tursulin@ursulin.net,tsbogend@alpha.franken.de,torvalds@linux-foundation.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,surenb@google.com,sj@kernel.org,shuah@kernel.org,shameerali.kolothum.thodi@huawei.com,rppt@kernel.org,rodrigo.vivi@intel.com,robin.murphy@arm.com,richard.weiyang@gmail.com,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,osalvador@suse.de,oakad@yahoo.com,npiggin@gmail.com,muchun.song@linux.dev,m.szyprowski@samsung.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maximlevitsky@gmail.com,martin.petersen@oracle.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lars.persson@axis.com,kevin.tian@intel.com,kernel@xen0n.name,joonas.lahtinen@linux.intel.com,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jesper.nilsson@axis.com,jason@zx2c4.com,jani.nikula@linux.intel.com,james.bottomley@HansenPartnership.com,jackmanb@google.com,herbert@gondor.apana.org.au,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,dlemoal@kernel.org,dgilbert@interlog.com,dennis@kernel.org,davem@davemloft.net,cl@gentwo.org,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,cassel@kernel.org,bvanassche@acm.org,brett.creeley@amd.com,bp@alien8.de,borntraeger@linux.ibm.com,axboe@kernel.dk,asml.silence@gmail.com,aou@eecs.berkeley.edu,andreas@gaisler.com,alex.williamson@redhat.com,alex@ghiti.fr,alexandru.elisei@arm.com,airlied@gmail.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-stop-making-sparsemem_vmemmap-user-selectable.patch removed from -mm tree
Message-Id: <20250921212327.E6DEEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: stop making SPARSEMEM_VMEMMAP user-selectable
has been removed from the -mm tree.  Its filename was
     mm-stop-making-sparsemem_vmemmap-user-selectable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: stop making SPARSEMEM_VMEMMAP user-selectable
Date: Mon, 1 Sep 2025 17:03:22 +0200

Patch series "mm: remove nth_page()", v2.

As discussed recently with Linus, nth_page() is just nasty and we would
like to remove it.

To recap, the reason we currently need nth_page() within a folio is
because on some kernel configs (SPARSEMEM without SPARSEMEM_VMEMMAP), the
memmap is allocated per memory section.

While buddy allocations cannot cross memory section boundaries, hugetlb
and dax folios can.

So crossing a memory section means that "page++" could do the wrong thing.
Instead, nth_page() on these problematic configs always goes from
page->pfn, to the go from (++pfn)->page, which is rather nasty.

Likely, many people have no idea when nth_page() is required and when it
might be dropped.

We refer to such problematic PFN ranges and "non-contiguous pages".  If we
only deal with "contiguous pages", there is not need for nth_page().

Besides that "obvious" folio case, we might end up using nth_page() within
CMA allocations (again, could span memory sections), and in one corner
case (kfence) when processing memblock allocations (again, could span
memory sections).

So let's handle all that, add sanity checks, and remove nth_page().

Patch #1 -> #5   : stop making SPARSEMEM_VMEMMAP user-selectable + cleanups
Patch #6 -> #13  : disallow folios to have non-contiguous pages
Patch #14 -> #20 : remove nth_page() usage within folios
Patch #22        : disallow CMA allocations of non-contiguous pages
Patch #23 -> #33 : sanity+check + remove nth_page() usage within SG entry
Patch #34        : sanity-check + remove nth_page() usage in
                   unpin_user_page_range_dirty_lock()
Patch #35        : remove nth_page() in kfence
Patch #36        : adjust stale comment regarding nth_page
Patch #37        : mm: remove nth_page()

A lot of this is inspired from the discussion at [1] between Linus, Jason
and me, so cudos to them.


This patch (of 37):

In an ideal world, we wouldn't have to deal with SPARSEMEM without
SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
considered too costly and consequently not supported.

However, if an architecture does support SPARSEMEM with SPARSEMEM_VMEMMAP,
let's forbid the user to disable VMEMMAP: just like we already do for
arm64, s390 and x86.

So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
SPARSEMEM_VMEMMAP.

This implies that the option to not use SPARSEMEM_VMEMMAP will now be gone
for loongarch, powerpc, riscv and sparc.  All architectures only enable
SPARSEMEM_VMEMMAP with 64bit support, so there should not really be a big
downside to using the VMEMMAP (quite the contrary).

This is a preparation for not supporting

(1) folio sizes that exceed a single memory section

(2) CMA allocations of non-contiguous page ranges

in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we want to limit
possible impact as much as possible (e.g., gigantic hugetlb page
allocations suddenly fails).

Link: https://lkml.kernel.org/r/20250901150359.867252-1-david@redhat.com
Link: https://lkml.kernel.org/r/20250901150359.867252-2-david@redhat.com
Link: https://lore.kernel.org/all/CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com/T/#u [1]
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Alex Willamson <alex.williamson@redhat.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brett Creeley <brett.creeley@amd.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: Damien Le Maol <dlemoal@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Maxim Levitky <maximlevitsky@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Niklas Cassel <cassel@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/Kconfig~mm-stop-making-sparsemem_vmemmap-user-selectable
+++ a/mm/Kconfig
@@ -412,9 +412,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 	bool
 
 config SPARSEMEM_VMEMMAP
-	bool "Sparse Memory virtual memmap"
+	def_bool y
 	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
-	default y
 	help
 	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	  pfn_to_page and page_to_pfn operations.  This is the most
_

Patches currently in -mm which might be from david@redhat.com are


