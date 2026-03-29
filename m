Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8051C1F5834
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744768; cv=none; b=sMlW1fZpoi74RF5qmLbHVQry2LYmRlc0tvByLGFHp9e2yTVR7HKoxg6n2l7T2pSgkjbw+D9d7GxDvFEYS0F+1bo2LB3z0s34bRkAp403Qx3UHIf4eCfFkUosEN4tYWcqaeFo+U9IkGByT7k7IDPwUIVX36/EkbX1UhRxEIsILSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744768; c=relaxed/simple;
	bh=npHpd3e49Luem0uXSAS5oi229H6wXWoz4HhJMM+6XRk=;
	h=Date:To:From:Subject:Message-Id; b=s2EqprIgKw18jog3tcUWARMvHh9DG8duOMfmkce9MIgIpK9QDsx5xosVAWBBpZbvWnNczxDzZtggfVgDK+z6H1zl4NA33t3JonZF63Ul+ESZv7GZZps+HUVZxDb6s4LvHin+VFMVCgEedFXnFH+G4ve4YcGbnvIhGZ4urAEGHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nDKPhqR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nDKPhqR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF66AC4CEF7;
	Sun, 29 Mar 2026 00:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744768;
	bh=npHpd3e49Luem0uXSAS5oi229H6wXWoz4HhJMM+6XRk=;
	h=Date:To:From:Subject:From;
	b=nDKPhqR1mVS6PPydQ917oeF9HbHFljIkuIHRg6+Xc16uCESybNB3p4MDNU01aDujY
	 S72L7xnsL2sgcR7H2fzZs5hX2VLJguCn39bRTY8eysGOaL+U9WOBIK8sgWODjZwMCH
	 bigM87UepXe5qE928CaYTYBbQ3vtpcfHuEf50gMM=
Date: Sat, 28 Mar 2026 17:39:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch removed from -mm tree
Message-Id: <20260329003927.EF66AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
has been removed from the -mm tree.  Its filename was
     mm-memory-support-vm_mixedmap-in-zap_special_vma_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
Date: Fri, 27 Feb 2026 21:08:47 +0100

There is demand for also zapping page table entries by drivers in
VM_MIXEDMAP VMAs[1].

Nothing really speaks against supporting VM_MIXEDMAP for driver use.  We
just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.

Link: https://lkml.kernel.org/r/20260227200848.114019-17-david@kernel.org
Link: https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com [1]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-support-vm_mixedmap-in-zap_special_vma_range
+++ a/mm/memory.c
@@ -2239,13 +2239,13 @@ void zap_vma_range(struct vm_area_struct
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP.
+ * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	    		!(vma->vm_flags & VM_PFNMAP))
+	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
 		return;
 
 	zap_vma_range(vma, address, size);
_

Patches currently in -mm which might be from david@kernel.org are


