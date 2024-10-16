Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E1C1D279F
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729118111; cv=none; b=m0059IPsqWZy6w0Omgczo1dUZGKywN+Fy7VDJbGRN9Nge2Z4QerrrJnolECT+M7CI07RR91GUAwIpuRln+x+1sc24wPXNYkf+qlEF/i13jBXqf8hjcymzLgSPo69pDu/qzF2W/38Tc08Q4gqoNiG+umvsuyGxgaJDjNJKC8Y47E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729118111; c=relaxed/simple;
	bh=pyyH8rz82n9Uy8sJL+sQcwm+/+iHygnpXujVYpT9Gx0=;
	h=Date:To:From:Subject:Message-Id; b=gg2nnfLfxZKT6/3mn1VPI6tCEy3bsHebDeecoAsGWkNeWLA7ipNmhMVY5IX6uYn6mPAQcpU5BcNad4RgaULyyPhRgeWgPjgDE4XB6UuwQWrzjWhpJ0X9BXfzOtKNVDOgfBPgx0F2Jg//8hItsyVzkpLNCytAGqy5+nie2yTKqyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sMILnbA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sMILnbA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4CFC4CEC5;
	Wed, 16 Oct 2024 22:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729118110;
	bh=pyyH8rz82n9Uy8sJL+sQcwm+/+iHygnpXujVYpT9Gx0=;
	h=Date:To:From:Subject:From;
	b=sMILnbA9vVP0Xn6tWT7YGnzbMK1rYgY/4rZGwYXZoKMEXLEwJ4Oy0FQtrZqJoZd4e
	 hGnPhe11hqto8tKYcZxBFHRBaiW5jHygO3E9QRHUVs1jvpYyZWl0zOv8SajOtzsoL/
	 rov0ubgcjwGQBOVUlm0L3lcjjdckFq8qBj3p/+4o=
Date: Wed, 16 Oct 2024 15:35:09 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@oracle.com,kent.overstreet@linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch added to mm-unstable branch
Message-Id: <20241016223510.7C4CFC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: don't account for number of nodes for HUGE_VMAP allocations
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: vmalloc: don't account for number of nodes for HUGE_VMAP allocations
Date: Wed, 16 Oct 2024 15:24:18 +0300

vmalloc allocations with VM_ALLOW_HUGE_VMAP that do not explicitly specify
node ID will use huge pages only if size_per_node is larger than a huge
page.

Still the actual allocated memory is not distributed between nodes and
there is no advantage in such approach.

On the contrary, BPF allocates SZ_2M * num_possible_nodes() for each new
bpf_prog_pack, while it could do with a single huge page per pack.

Don't account for number of nodes for VM_ALLOW_HUGE_VMAP with NUMA_NO_NODE
and use huge pages whenever the requested allocation size is larger than a
huge page.

Link: https://lkml.kernel.org/r/20241016122424.1655560-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Song Liu <song@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations
+++ a/mm/vmalloc.c
@@ -3779,8 +3779,6 @@ void *__vmalloc_node_range_noprof(unsign
 	}
 
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
-		unsigned long size_per_node;
-
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
 		 * others like modules don't yet expect huge pages in
@@ -3788,13 +3786,10 @@ void *__vmalloc_node_range_noprof(unsign
 		 * supporting them.
 		 */
 
-		size_per_node = size;
-		if (node == NUMA_NO_NODE)
-			size_per_node /= num_online_nodes();
-		if (arch_vmap_pmd_supported(prot) && size_per_node >= PMD_SIZE)
+		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
 			shift = PMD_SHIFT;
 		else
-			shift = arch_vmap_pte_supported_shift(size_per_node);
+			shift = arch_vmap_pte_supported_shift(size);
 
 		align = max(real_align, 1UL << shift);
 		size = ALIGN(real_size, 1UL << shift);
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-kmemleak-fix-typo-in-object_no_scan-comment.patch
mm-vmalloc-group-declarations-depending-on-config_mmu-together.patch
mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch
asm-generic-introduce-text-patchingh.patch
module-prepare-to-handle-rox-allocations-for-text.patch
arch-introduce-set_direct_map_valid_noflush.patch
x86-module-prepare-module-loading-for-rox-allocations-of-text.patch
execmem-add-support-for-cache-of-large-rox-pages.patch
x86-module-enable-rox-caches-for-module-text-on-64-bit.patch

