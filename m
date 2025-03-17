Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6664155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188515; cv=none; b=Q8Rtzho6ascF5XFmVWnrs0FXNcra/g1bRWEQ8S1gVpKoJ0PY8vNrS5WQkM5CX2b73moqejhlRMurNe1BFyJpr6tKCQWMlEALtx0IY7tv9o/ll8+QHEEZoVLDqMsb5+YvGUaB5qoQUN1/srDJ/kXdBPeLZ3lBb1uNVekfuvYn1Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188515; c=relaxed/simple;
	bh=OYBgINqSB/B6Mmcf77mkTj+MmCiUB5cP1jJ9INbWpzE=;
	h=Date:To:From:Subject:Message-Id; b=i1p7P8+rRlFHSAiQvCVnHE9HbQ0+I7Ytm1oPIGKV1qQe+RIs4MZdEjscP8xuVlI176q4iobedIgFXcKYlROtmN6QGjG05UAgaqVgT4aYVr7hdbv0wOcIIojWx26viRm65SXHniw6dOBh537yxzADYFI5ugo0TP4PCWU1IzhKrBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sx1PeiBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sx1PeiBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC82C4CEEC;
	Mon, 17 Mar 2025 05:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188515;
	bh=OYBgINqSB/B6Mmcf77mkTj+MmCiUB5cP1jJ9INbWpzE=;
	h=Date:To:From:Subject:From;
	b=Sx1PeiBwDdRM2u3HuqWTqqOEg/y9HwULkdJvLh0epP/9YlhQgXUmDjhd1hxzSFJo4
	 nRPorXNbsle2nN6wGnT3AMMI8ZGoD/6bEH/6WObNGsAZFqILh1K1CtueS9yMk3bYVK
	 kN3oPLVj60+/ezDy96YVdbUyjyv4G8Tr9eYvNekI=
Date: Sun, 16 Mar 2025 22:15:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-x86-xen-allow-nesting-of-same-lazy-mode.patch removed from -mm tree
Message-Id: <20250317051515.9CC82C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "x86/xen: allow nesting of same lazy mode"
has been removed from the -mm tree.  Its filename was
     revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: Revert "x86/xen: allow nesting of same lazy mode"
Date: Mon, 3 Mar 2025 14:15:39 +0000

Commit 49147beb0ccb ("x86/xen: allow nesting of same lazy mode") was added
as a solution for a core-mm code change where
arch_[enter|leave]_lazy_mmu_mode() started to be called in a nested
manner; see commit bcc6cc832573 ("mm: add default definition of
set_ptes()").

However, now that we have fixed the API to avoid nesting, we no longer
need this capability in the x86 implementation.

Additionally, from code review, I don't believe the fix was ever robust in
the case of preemption occurring while in the nested lazy mode.  The
implementation usually deals with preemption by calling
arch_leave_lazy_mmu_mode() from xen_start_context_switch() for the
outgoing task if we are in the lazy mmu mode.  Then in
xen_end_context_switch(), it restarts the lazy mode by calling
arch_enter_lazy_mmu_mode() for an incoming task that was in the lazy mode
when it was switched out.  But arch_leave_lazy_mmu_mode() will only unwind
a single level of nesting.  If we are in the double nest, then it's not
fully unwound and per-cpu variables are left in a bad state.

So the correct solution is to remove the possibility of nesting from the
higher level (which has now been done) and remove this x86-specific
solution.

Link: https://lkml.kernel.org/r/20250303141542.3371656-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Juergen Gross <jgross@suse.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/xen/hypervisor.h |   15 ++-------------
 arch/x86/xen/enlighten_pv.c           |    1 -
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/xen/hypervisor.h~revert-x86-xen-allow-nesting-of-same-lazy-mode
+++ a/arch/x86/include/asm/xen/hypervisor.h
@@ -72,18 +72,10 @@ enum xen_lazy_mode {
 };
 
 DECLARE_PER_CPU(enum xen_lazy_mode, xen_lazy_mode);
-DECLARE_PER_CPU(unsigned int, xen_lazy_nesting);
 
 static inline void enter_lazy(enum xen_lazy_mode mode)
 {
-	enum xen_lazy_mode old_mode = this_cpu_read(xen_lazy_mode);
-
-	if (mode == old_mode) {
-		this_cpu_inc(xen_lazy_nesting);
-		return;
-	}
-
-	BUG_ON(old_mode != XEN_LAZY_NONE);
+	BUG_ON(this_cpu_read(xen_lazy_mode) != XEN_LAZY_NONE);
 
 	this_cpu_write(xen_lazy_mode, mode);
 }
@@ -92,10 +84,7 @@ static inline void leave_lazy(enum xen_l
 {
 	BUG_ON(this_cpu_read(xen_lazy_mode) != mode);
 
-	if (this_cpu_read(xen_lazy_nesting) == 0)
-		this_cpu_write(xen_lazy_mode, XEN_LAZY_NONE);
-	else
-		this_cpu_dec(xen_lazy_nesting);
+	this_cpu_write(xen_lazy_mode, XEN_LAZY_NONE);
 }
 
 enum xen_lazy_mode xen_get_lazy_mode(void);
--- a/arch/x86/xen/enlighten_pv.c~revert-x86-xen-allow-nesting-of-same-lazy-mode
+++ a/arch/x86/xen/enlighten_pv.c
@@ -99,7 +99,6 @@ struct tls_descs {
 };
 
 DEFINE_PER_CPU(enum xen_lazy_mode, xen_lazy_mode) = XEN_LAZY_NONE;
-DEFINE_PER_CPU(unsigned int, xen_lazy_nesting);
 
 enum xen_lazy_mode xen_get_lazy_mode(void)
 {
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

