Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8AD12F5A5;
	Mon, 17 Mar 2025 05:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188513; cv=none; b=e5uwox68Tz7cHEhX6fduaB2oWDHsbJuAs5npPt9SOZK9/LNrEp6nPd5GlTWq9DSPrTwRXNZDh/Yh7UmXbxUecGnCMn548td0H4JcZpkB+Yenx9HCWtahatT5dNJgxtw4nlwYmBhOL5bqKWgkTBAku/3X8w8YDxAq7zZz3Ne7ifM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188513; c=relaxed/simple;
	bh=bVJdfSc4EYlaxt6Of18JMCn4JS/tZb/VGtL6IbIiAn8=;
	h=Date:To:From:Subject:Message-Id; b=KjB1lUzyje4/qk/UMupMtksxyrKt+Xud+7CY3AV+tO54n0wIrSfb03idZCa9Iaa5D+xTwdAJP6Ed+lqI9+u5zzHaP/Eb9ZIFYJey+TQSGsC+zg9/g4bIMAKRioVAibkE+w/O0SrnVDg6SIrozS+WmVFLxLn77SSPTtRc3zkx2hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5WvaCdp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5WvaCdp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207ECC4CEEC;
	Mon, 17 Mar 2025 05:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188513;
	bh=bVJdfSc4EYlaxt6Of18JMCn4JS/tZb/VGtL6IbIiAn8=;
	h=Date:To:From:Subject:From;
	b=r5WvaCdpOW4VhrRrc6XmY0g5Np7s9l2xDk3pc33iMjd4NvU4tMP1FVAtojVlDg5Gu
	 +1fBmfnqefeqoa9lZlicIJS4dClS5Ex4ttHiEZ4EgOPyZywkPvHepvojr33s3eqRDU
	 YtDmfuAD/Em81tfXVrFrOpyoXMUvqiYaF+LxcIqg=
Date: Sun, 16 Mar 2025 22:15:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tglx@linutronix.de,stable@vger.kernel.org,mingo@redhat.com,jgross@suse.com,hpa@zytor.com,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,boris.ostrovsky@oracle.com,andreas@gaisler.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc-mm-disable-preemption-in-lazy-mmu-mode.patch removed from -mm tree
Message-Id: <20250317051513.207ECC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc/mm: disable preemption in lazy mmu mode
has been removed from the -mm tree.  Its filename was
     sparc-mm-disable-preemption-in-lazy-mmu-mode.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: sparc/mm: disable preemption in lazy mmu mode
Date: Mon, 3 Mar 2025 14:15:37 +0000

Since commit 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy
updates") it's been possible for arch_[enter|leave]_lazy_mmu_mode() to be
called without holding a page table lock (for the kernel mappings case),
and therefore it is possible that preemption may occur while in the lazy
mmu mode.  The Sparc lazy mmu implementation is not robust to preemption
since it stores the lazy mode state in a per-cpu structure and does not
attempt to manage that state on task switch.

Powerpc had the same issue and fixed it by explicitly disabling preemption
in arch_enter_lazy_mmu_mode() and re-enabling in
arch_leave_lazy_mmu_mode().  See commit b9ef323ea168 ("powerpc/64s:
Disable preemption in hash lazy mmu mode").

Given Sparc's lazy mmu mode is based on powerpc's, let's fix it in the
same way here.

Link: https://lkml.kernel.org/r/20250303141542.3371656-4-ryan.roberts@arm.com
Fixes: 38e0edb15bd0 ("mm/apply_to_range: call pte function with lazy updates")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Andreas Larsson <andreas@gaisler.com>
Acked-by: Juergen Gross <jgross@suse.com>
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/sparc/mm/tlb.c~sparc-mm-disable-preemption-in-lazy-mmu-mode
+++ a/arch/sparc/mm/tlb.c
@@ -52,8 +52,10 @@ out:
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+	struct tlb_batch *tb;
 
+	preempt_disable();
+	tb = this_cpu_ptr(&tlb_batch);
 	tb->active = 1;
 }
 
@@ -64,6 +66,7 @@ void arch_leave_lazy_mmu_mode(void)
 	if (tb->tlb_nr)
 		flush_tlb_pending();
 	tb->active = 0;
+	preempt_enable();
 }
 
 static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-use-ptep_get-instead-of-directly-dereferencing-pte_t.patch

