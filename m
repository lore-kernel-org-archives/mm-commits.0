Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C8314A4C7
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560486; cv=none; b=ipFR2YZa8TuHBxjno7mn0VkxCeQql2MyXbSVbJMaKyHLrybxHkTQRdNnk7ulztD7KEmzki/9oMiQUQtgOXCH/ZWblF73UdQJvpMGJh2fUiZcyh20Gw+MEranCQmZMUQocG3qMJHqa379LypEb6g1wCJh9rdQBig0YCCIBXdUC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560486; c=relaxed/simple;
	bh=dIT2F6GcSEfn06injlGZr5kfrXGrds4subH8HrimPKg=;
	h=Date:To:From:Subject:Message-Id; b=P0VIbUdj4IP/kZOcc4om6XtSF7HM/bLiJmfoSHOGz/LBYExqHsAHSz8hoV/tvWu1J+oX4PO/19k8vYDR+PH9nlj947VG1GOnVmGVNC8nkgmTGYPPRPJUYUnX8WyAkfKSCPghHV7A/McZ8ZX+XeGQu5JWm4wGKSnPAfN3aJfTWw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X7YHrqse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X7YHrqse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F18CC4CEC6;
	Tue, 17 Sep 2024 08:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560486;
	bh=dIT2F6GcSEfn06injlGZr5kfrXGrds4subH8HrimPKg=;
	h=Date:To:From:Subject:From;
	b=X7YHrqse5sdmUMH0Gdc8VoYOkTtrnAwHH1+dL/RAewEmWR880Zi/FFD/mxIWLsE9H
	 gPFlrR9O2GqsCH8NvfihA4SHQd6+7rE3ULko8vkkd7/MYVEf5StvJ4PQQALJyisccB
	 QXFGUYfmjx0HUzDIIHoVSH3ZHkNCLeKLQSF9FK/4=
Date: Tue, 17 Sep 2024 01:08:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kvm-use-follow_pfnmap-api.patch removed from -mm tree
Message-Id: <20240917080806.1F18CC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: use follow_pfnmap API
has been removed from the -mm tree.  Its filename was
     kvm-use-follow_pfnmap-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: KVM: use follow_pfnmap API
Date: Mon, 26 Aug 2024 16:43:44 -0400

Use the new pfnmap API to allow huge MMIO mappings for VMs.  The rest work
is done perfectly on the other side (host_pfn_mapping_level()).

Link: https://lkml.kernel.org/r/20240826204353.2228736-11-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/virt/kvm/kvm_main.c~kvm-use-follow_pfnmap-api
+++ a/virt/kvm/kvm_main.c
@@ -2860,13 +2860,11 @@ static int hva_to_pfn_remapped(struct vm
 			       unsigned long addr, bool write_fault,
 			       bool *writable, kvm_pfn_t *p_pfn)
 {
+	struct follow_pfnmap_args args = { .vma = vma, .address = addr };
 	kvm_pfn_t pfn;
-	pte_t *ptep;
-	pte_t pte;
-	spinlock_t *ptl;
 	int r;
 
-	r = follow_pte(vma, addr, &ptep, &ptl);
+	r = follow_pfnmap_start(&args);
 	if (r) {
 		/*
 		 * get_user_pages fails for VM_IO and VM_PFNMAP vmas and does
@@ -2881,21 +2879,19 @@ static int hva_to_pfn_remapped(struct vm
 		if (r)
 			return r;
 
-		r = follow_pte(vma, addr, &ptep, &ptl);
+		r = follow_pfnmap_start(&args);
 		if (r)
 			return r;
 	}
 
-	pte = ptep_get(ptep);
-
-	if (write_fault && !pte_write(pte)) {
+	if (write_fault && !args.writable) {
 		pfn = KVM_PFN_ERR_RO_FAULT;
 		goto out;
 	}
 
 	if (writable)
-		*writable = pte_write(pte);
-	pfn = pte_pfn(pte);
+		*writable = args.writable;
+	pfn = args.pfn;
 
 	/*
 	 * Get a reference here because callers of *hva_to_pfn* and
@@ -2916,9 +2912,8 @@ static int hva_to_pfn_remapped(struct vm
 	 */
 	if (!kvm_try_get_pfn(pfn))
 		r = -EFAULT;
-
 out:
-	pte_unmap_unlock(ptep, ptl);
+	follow_pfnmap_end(&args);
 	*p_pfn = pfn;
 
 	return r;
_

Patches currently in -mm which might be from peterx@redhat.com are


