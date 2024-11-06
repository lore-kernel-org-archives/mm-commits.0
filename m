Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE0B161328;
	Wed,  6 Nov 2024 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854841; cv=none; b=tVhOoAx0MLjq2cX8+H3s6RxlXWxbw8zNa6hXDhE/IPgfgbfl1hS7p0SvpXWYyZaVyGw9otDx6GcmnOF53C1TTY8E5i0U3fkeLcLJYw/dOaE0ZnqTkCk5rsYFXuhHeWL3zJMwNejQiUbzInykI4vSALRAB9kV4Ke4NMOk8B9rmbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854841; c=relaxed/simple;
	bh=Fg8s/oQOXMwS0Rt6yEnmLf2yyoISnsCpXz6JumG2d48=;
	h=Date:To:From:Subject:Message-Id; b=nMtHBJhc86TtUq5vHFR9meZXEBCMcI207ERk2/tRn7InibkdHvIMurfwNUcLehfqV7+EtsXQXChi8M95DAQ5eVMF3DlyLPZ6lLU6TOXQJp3F+dSm6N9fq01jumOZCtJLuetlXiEC5jW6dcaGZ9+KW8cjALLx/dvGKUgHO5eiIIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m68ECJw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m68ECJw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30089C4CED2;
	Wed,  6 Nov 2024 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854841;
	bh=Fg8s/oQOXMwS0Rt6yEnmLf2yyoISnsCpXz6JumG2d48=;
	h=Date:To:From:Subject:From;
	b=m68ECJw47S0HKV8HL9JtlWjnv8z8H6cTzohhGMmi1tIuXeoHlhN7MyZ1kWNHxxq5D
	 6UArBXXO9y16hz68XuKgtcgCaJL96Y7XqF7K3sc9LrljxEcnVfkuyg8r0KOJ84H3XR
	 X9XAQZmqCkdTGijHIGdXbQXEnMdL4C9BALXQ0dLE=
Date: Tue, 05 Nov 2024 17:00:40 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,urezki@gmail.com,tsbogend@alpha.franken.de,tglx@linutronix.de,surenb@google.com,song@kernel.org,shorne@gmail.com,rostedt@goodmis.org,richard@nod.at,peterz@infradead.org,palmer@dabbelt.com,oleg@redhat.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mhiramat@kernel.org,mcgrof@kernel.org,mattst88@gmail.com,mark.rutland@arm.com,luto@kernel.org,linux@armlinux.org.uk,Liam.Howlett@Oracle.com,kent.overstreet@linux.dev,kdevops@lists.linux.dev,johannes@sipsolutions.net,jcmvbkbc@gmail.com,hch@lst.de,guoren@kernel.org,glaubitz@physik.fu-berlin.de,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,bcain@quicinc.com,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch removed from -mm tree
Message-Id: <20241106010041.30089C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmalloc: don't account for number of nodes for HUGE_VMAP allocations
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-dont-account-for-number-of-nodes-for-huge_vmap-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm: vmalloc: don't account for number of nodes for HUGE_VMAP allocations
Date: Wed, 23 Oct 2024 19:27:05 +0300

vmalloc allocations with VM_ALLOW_HUGE_VMAP that do not explicitly specify
node ID will use huge pages only if size_per_node is larger than a huge
page.

Still the actual allocated memory is not distributed between nodes and
there is no advantage in such approach.  On the contrary, BPF allocates
SZ_2M * num_possible_nodes() for each new bpf_prog_pack, while it could do
with a single huge page per pack.

Don't account for number of nodes for VM_ALLOW_HUGE_VMAP with NUMA_NO_NODE
and use huge pages whenever the requested allocation size is larger than a
huge page.

Link: https://lkml.kernel.org/r/20241023162711.2579610-3-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Tested-by: kdevops <kdevops@lists.linux.dev>
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
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
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


