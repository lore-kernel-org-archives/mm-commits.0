Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4391C22D7A1
	for <mm-commits@vger.kernel.org>; Tue,  9 Sep 2025 02:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757384658; cv=none; b=gxLYjuInRbpOqhUTnuMOB0MYw/dPO9yaqLUKDRTtF5qBs2JeGBwHX75bLG0m8tgLguFUyC30DH1jCv9ZymvvWdX4NOnMY6nIMRjS6t+qUwYjH6AUzx6glktUpxoiJQd1/qwHDC4UZ1YbIl8fvx8xSbmcxis8/ggQrbpBRd/mK7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757384658; c=relaxed/simple;
	bh=eB5TCadeTtxe1gG6IFINNC0KBXKKos9yz++MKTmRgYA=;
	h=Date:To:From:Subject:Message-Id; b=SmoC61epsUiGcQyOcdv018LGEBnQdpFi6YNvdamvk/5bshKV5i4fgeIpmYi4sE0+Pf7mQyNuF+kDU4LMCDk5Er+ShD8uD18j24phxT7ODWl4bYZC6uajDDLF6WO9nBuve1423eNOK34QuvGZ+COyeCW7zWZiFgpI67XBWqsXhG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3HPmC7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3HPmC7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D0EC4CEF1;
	Tue,  9 Sep 2025 02:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384653;
	bh=eB5TCadeTtxe1gG6IFINNC0KBXKKos9yz++MKTmRgYA=;
	h=Date:To:From:Subject:From;
	b=x3HPmC7VyAB1YyWN6BN/bfXzNVluRaKQlQl+TPNQ7p8Z8k0AydSF+Pdkw/+AADvpq
	 UFA3IxQEz9iPSbBAt3Gyt/hI389ly8hZNqkqLnT5jBp0h0PTZznfl1xMzihj/6RLiO
	 n7vLnHckwnCMrVi4VkFNAFQ9pQZR8FZ7OTBdkDro=
Date: Mon, 08 Sep 2025 19:24:13 -0700
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-lazy_mmu-documentation.patch added to mm-new branch
Message-Id: <20250909022413.A0D0EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update lazy_mmu documentation
has been added to the -mm mm-new branch.  Its filename is
     mm-update-lazy_mmu-documentation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-lazy_mmu-documentation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm: update lazy_mmu documentation
Date: Mon, 8 Sep 2025 08:39:31 +0100

We now support nested lazy_mmu sections on all architectures implementing
the API.  Update the API comment accordingly.

Link: https://lkml.kernel.org/r/20250908073931.4159362-8-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/pgtable.h~mm-update-lazy_mmu-documentation
+++ a/include/linux/pgtable.h
@@ -228,8 +228,18 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode cannot be used
+ * in interrupt context.
+ *
+ * Calls may be nested: an arch_{enter,leave}_lazy_mmu_mode() pair may be called
+ * while the lazy MMU mode has already been enabled. An implementation should
+ * handle this using the state returned by enter() and taken by the matching
+ * leave() call; the LAZY_MMU_{DEFAULT,NESTED} flags can be used to indicate
+ * whether this enter/leave pair is nested inside another or not. (It is up to
+ * the implementation to track whether the lazy MMU mode is enabled at any point
+ * in time.) The expectation is that leave() will flush any batched state
+ * unconditionally, but only leave the lazy MMU mode if the passed state is not
+ * LAZY_MMU_NESTED.
  */
 #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
 typedef int lazy_mmu_state_t;
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-remove-arch_flush_lazy_mmu_mode.patch
mm-introduce-local-state-for-lazy_mmu-sections.patch
arm64-mm-fully-support-nested-lazy_mmu-sections.patch
x86-xen-support-nested-lazy_mmu-sections-again.patch
powerpc-mm-support-nested-lazy_mmu-sections.patch
sparc-mm-support-nested-lazy_mmu-sections.patch
mm-update-lazy_mmu-documentation.patch

