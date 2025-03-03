Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73471EEA2A
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741043401; cv=none; b=s7XDsVbm3N/qwp6ibDi0gJfHu/hHI/6LPcpJwraBJ3Z0bIpCGl3P5f4MXeY+3T/3cEZ9s49NxRFreMAoNHRT7RCAGqKI0qXAVjk8MlZ7as+612YBSRPoB46jxKzO6N6xJwrkwXMeWkEKHRzr0Y/doTvlCMZXr0yXVXpVJcu8aqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741043401; c=relaxed/simple;
	bh=cuxEJiWDu5K43mQPbMxpfZOZt9gPiudCLEOkJE+ggn0=;
	h=Date:To:From:Subject:Message-Id; b=XSYWg5fD3j1gFat7xKMdtjqswRZ1PI0jrg6IW3zckwATQm+DdGZa/e9OhGSfmbZD68ygNscTxJeQNqxav69Su1XFByIgyfcRaVlD0EByHPwn95yhkxF+EFKr7JWJiCfrT+N6aI+OsoKlOd8k9uRecHdopGEquJzmw0LkDW+56xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aGVhu8Lz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aGVhu8Lz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7B1C4CEE8;
	Mon,  3 Mar 2025 23:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741043401;
	bh=cuxEJiWDu5K43mQPbMxpfZOZt9gPiudCLEOkJE+ggn0=;
	h=Date:To:From:Subject:From;
	b=aGVhu8Lz8i2ixAAO96/jZ2bP/0q5+mTXiVBjt5OdpjoQ9KQ/gQW9Q4NO5H8cuIuBV
	 sRz5jSqZM865+aCY6rd7jYYfYkPZFbVF49t9v4ajtWBHn6Nz5rW5GYZRokJA3vj/QH
	 YVdQ6/sEdCMrVHVuLDqlFBMATyleLAqxHQSx/l60=
Date: Mon, 03 Mar 2025 15:10:01 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-x86-xen-allow-nesting-of-same-lazy-mode.patch added to mm-unstable branch
Message-Id: <20250303231001.9C7B1C4CEE8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "x86/xen: allow nesting of same lazy mode"
has been added to the -mm mm-unstable branch.  Its filename is
     revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

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

mm-dont-skip-arch_sync_kernel_mappings-in-error-paths.patch
mm-ioremap-pass-pgprot_t-to-ioremap_prot-instead-of-unsigned-long.patch
mm-fix-lazy-mmu-docs-and-usage.patch
fs-proc-task_mmu-reduce-scope-of-lazy-mmu-region.patch
sparc-mm-disable-preemption-in-lazy-mmu-mode.patch
sparc-mm-avoid-calling-arch_enter-leave_lazy_mmu-in-set_ptes.patch
revert-x86-xen-allow-nesting-of-same-lazy-mode.patch

