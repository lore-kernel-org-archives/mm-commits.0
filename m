Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12971C84BC
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744758; cv=none; b=prQlgMG3/USw+xsoBX8Gr1WCxPlGSdNkJ2fhDhuOqS0t/NM8e/5/KakqtT3x1RjLiJBP0cIepOLRwbKQQ3Q0MDCwRAfoKB7m4YJ5iBbtvskuYjsTaGuWFcfY7/3GwUQZw5Ey+L03M8/WQPmE4u3CMX+6FIqoWrQjoM92rr4RmBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744758; c=relaxed/simple;
	bh=DOIZtH0pg59ZcY3bluqInxQbTPUgek5UIb/UBGDhASM=;
	h=Date:To:From:Subject:Message-Id; b=ZhioV8P2M7J6D41zDhGguX3Ixy4ofsxEzMJgP1If7LBTvOhA6BlZyIVGiRGesO7XPCkXsWYJ4r4M4o9yAIUv8qhe/mooRwXugmpy0eYchC8Z6VKx5MWoNZZuSXk3nK6YoPSS3VHjnBrSkWXDLi7SXVXa23L/C6QqA06lhAmbsYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NmZGADRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NmZGADRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA22C4CEF7;
	Sun, 29 Mar 2026 00:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744758;
	bh=DOIZtH0pg59ZcY3bluqInxQbTPUgek5UIb/UBGDhASM=;
	h=Date:To:From:Subject:From;
	b=NmZGADRxL4V0kwEfENFpthsSrdB8jeDlVkpyRzq1y2h6eHrrbrGl9byEAtmaPRnrk
	 chX3d2B28chO60Xp+rFzlj8CT9IeLAPWD0zKEkfoKC5Czo4vAtkhNoJpznzAz8Hjqb
	 BZKaR9SqP7jsTedoXjHLKlaFbHGV6XIOXMrJIqZQ=
Date: Sat, 28 Mar 2026 17:39:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch removed from -mm tree
Message-Id: <20260329003918.3EA22C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: inline unmap_page_range() into __zap_vma_range()
has been removed from the -mm tree.  Its filename was
     mm-memory-inline-unmap_page_range-into-__zap_vma_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: inline unmap_page_range() into __zap_vma_range()
Date: Fri, 27 Feb 2026 21:08:42 +0100

Let's inline it into the single caller to reduce the number of confusing
unmap/zap helpers.

Get rid of the unnecessary BUG_ON().

[david@kernel.org: call the local variable simply "addr", per Lorenzo]
  Link: https://lkml.kernel.org/r/f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org
Link: https://lkml.kernel.org/r/20260227200848.114019-12-david@kernel.org
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

 mm/memory.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/mm/memory.c~mm-memory-inline-unmap_page_range-into-__zap_vma_range
+++ a/mm/memory.c
@@ -2056,25 +2056,6 @@ static inline unsigned long zap_p4d_rang
 	return addr;
 }
 
-static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long end,
-		struct zap_details *details)
-{
-	pgd_t *pgd;
-	unsigned long next;
-
-	BUG_ON(addr >= end);
-	tlb_start_vma(tlb, vma);
-	pgd = pgd_offset(vma->vm_mm, addr);
-	do {
-		next = pgd_addr_end(addr, end);
-		if (pgd_none_or_clear_bad(pgd))
-			continue;
-		next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
-	} while (pgd++, addr = next, addr != end);
-	tlb_end_vma(tlb, vma);
-}
-
 static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
 		struct zap_details *details)
@@ -2100,7 +2081,18 @@ static void __zap_vma_range(struct mmu_g
 			return;
 		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
 	} else {
-		unmap_page_range(tlb, vma, start, end, details);
+		unsigned long next, addr = start;
+		pgd_t *pgd;
+
+		tlb_start_vma(tlb, vma);
+		pgd = pgd_offset(vma->vm_mm, addr);
+		do {
+			next = pgd_addr_end(addr, end);
+			if (pgd_none_or_clear_bad(pgd))
+				continue;
+			next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
+		} while (pgd++, addr = next, addr != end);
+		tlb_end_vma(tlb, vma);
 	}
 }
 
_

Patches currently in -mm which might be from david@kernel.org are


