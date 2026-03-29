Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401121CAA7D
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744747; cv=none; b=GakY1KGvpfynEpPDe8dzNwcTYv2HeyyF6nGu3o9gOaGrHCJcxQftMdZ/dI+R2fa13tQAIGWoF2Ye4SAmlE4R7g7bPnSlJUolyFuWuOnIkBIEiKSOmMVHWk3c+FchevuU8wG5GjJnGzto1uiL/9xg3TEiXDyiD7wFDU4lFLphr64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744747; c=relaxed/simple;
	bh=F8NgOrXE8bvDqY5fP955de0S0yqb5JXObKyovqVrR1g=;
	h=Date:To:From:Subject:Message-Id; b=DxXKNeQ8I9DexqoVM50BlvJ0yvfJm5w5Pf40vwBHU/KuKpO2AgmeL6rXnCR7KKuwdVllzocjArQHG7Xt2IT+6oGscl5OubXU5Mcxm5UjLJuXcp9DNXc0dWTI1DiM4kKEzOYXhjK17S+OLhtNqcNbFv1Hx3rmlJ3JevRV0GXRXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lLC9xBWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lLC9xBWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA707C4CEF7;
	Sun, 29 Mar 2026 00:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744746;
	bh=F8NgOrXE8bvDqY5fP955de0S0yqb5JXObKyovqVrR1g=;
	h=Date:To:From:Subject:From;
	b=lLC9xBWewhoxBwJ1GGUuJ3maZQ2QxiQfhiH41xYwchyQosm9DcIWhEYg4AQyrx/qB
	 jR2+zoyrEMrP4HKgfDKCZOw2iGpq/JTMATN+UTEOcEeoWl1/0Vy7N2N6GBkzWMZ1Pb
	 NvVCH3G9UMJ4B+JovFK4su1xup1XVUJvWSOa57qQ=
Date: Sat, 28 Mar 2026 17:39:06 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch removed from -mm tree
Message-Id: <20260329003906.BA707C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: use MMU_NOTIFY_CLEAR in __oom_reap_task_mm()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/oom_kill: use MMU_NOTIFY_CLEAR in __oom_reap_task_mm()
Date: Fri, 27 Feb 2026 21:08:36 +0100

In commit 7269f999934b ("mm/mmu_notifier: use correct mmu_notifier events
for each invalidation") we converted all MMU_NOTIFY_UNMAP to
MMU_NOTIFY_CLEAR, except the ones that actually perform munmap() or
mremap() as documented.

__oom_reap_task_mm() behaves much more like MADV_DONTNEED.  So use
MMU_NOTIFY_CLEAR as well.

This is a preparation for further changes.

Link: https://lkml.kernel.org/r/20260227200848.114019-6-david@kernel.org
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

 mm/oom_kill.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/oom_kill.c~mm-oom_kill-use-mmu_notify_clear-in-__oom_reap_task_mm
+++ a/mm/oom_kill.c
@@ -551,7 +551,7 @@ static bool __oom_reap_task_mm(struct mm
 			struct mmu_notifier_range range;
 			struct mmu_gather tlb;
 
-			mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0,
+			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
 						mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm);
_

Patches currently in -mm which might be from david@kernel.org are


