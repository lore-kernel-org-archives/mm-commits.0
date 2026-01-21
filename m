Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8630F92E
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768965995; cv=none; b=GM7cet+kmwByiqMz7HQ19WTHT+/ZEJSBPwsizyc3yniJ2dusy201rT9S9xStv6TrWEEhDFVJtATE9uwur7ZbFB1pocIIcfA/hnh0249dNi0wPyumA0+8/YpM+FuBHN6ZWmFyTU3mv72t5HE2Lypu4ZIrMEnTUCzaeDNdq+59dQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768965995; c=relaxed/simple;
	bh=gr2lRNtNur+1SomoO0UKtRBSSo9gRK8sEeNVaTOKYug=;
	h=Date:To:From:Subject:Message-Id; b=rAB9YyVf4OWqGZvhplhv1YBsiimxb6XQ8uHyvAzcpXdIeYEQZ8BHVqdOzy0jcF+7gkvRCEZvT/tRAG8nUyuldva6c6eZiQh1dsRgRoGKDlSxrSg7GWXDRLJIzrlfc138POHRahP8sOca9gwPUQEv8hgSlWAVgfPjYNBexWc061A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1rETDEqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1rETDEqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56281C16AAE;
	Wed, 21 Jan 2026 03:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768965995;
	bh=gr2lRNtNur+1SomoO0UKtRBSSo9gRK8sEeNVaTOKYug=;
	h=Date:To:From:Subject:From;
	b=1rETDEqmwCOpnb9gk+la//SO6oH1YBRlKVpRwKnlmFfcjCEAgvQRLxAoHFJi5CeQI
	 TybQ2gSznR73P1e4M3au7LgAuX84Oxrjm6gkthbQWawB1zzYGUv+6yoMCzUZ/MHVFi
	 zwa1+DhG0OqPKPJvzYRfiK+JciRRwKyo4M/fqR+Q=
Date: Tue, 20 Jan 2026 19:26:34 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,will@kernel.org,venkat88@linux.ibm.com,vbabka@suse.cz,tglx@linutronix.de,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jgross@suse.com,jannh@google.com,hpa@zytor.com,dwmw2@infradead.org,david@redhat.com,david@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,anshuman.khandual@arm.com,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-xen-simplify-flush_lazy_mmu.patch removed from -mm tree
Message-Id: <20260121032635.56281C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/xen: simplify flush_lazy_mmu()
has been removed from the -mm tree.  Its filename was
     x86-xen-simplify-flush_lazy_mmu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: x86/xen: simplify flush_lazy_mmu()
Date: Mon, 15 Dec 2025 15:03:11 +0000

arch_flush_lazy_mmu_mode() is called when outstanding batched pgtable
operations must be completed immediately.  There should however be no need
to leave and re-enter lazy MMU completely.  The only part of that sequence
that we really need is xen_mc_flush(); call it directly.

Link: https://lkml.kernel.org/r/20251215150323.2218608-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/mmu_pv.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/arch/x86/xen/mmu_pv.c~x86-xen-simplify-flush_lazy_mmu
+++ a/arch/x86/xen/mmu_pv.c
@@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
 {
 	preempt_disable();
 
-	if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
-		arch_leave_lazy_mmu_mode();
-		arch_enter_lazy_mmu_mode();
-	}
+	if (xen_get_lazy_mode() == XEN_LAZY_MMU)
+		xen_mc_flush();
 
 	preempt_enable();
 }
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-default-kdir-to-build-directory.patch
selftests-mm-remove-flaky-header-check.patch
selftests-mm-pass-down-full-cc-and-cflags-to-check_configsh.patch
selftests-mm-fix-usage-of-force_read-in-cow-tests.patch
selftests-mm-introduce-helper-to-read-every-page-in-range.patch
selftests-mm-fix-faulting-in-code-in-pagemap_ioctl-test.patch
selftests-mm-fix-exit-code-in-pagemap_ioctl.patch
selftests-mm-report-skip-in-pfnmap-if-a-check-fails.patch

