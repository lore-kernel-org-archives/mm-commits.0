Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB995383AC
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957128; cv=none; b=brmaS5Ga8VHKi8nmWeo659A/8SiY22xOI64MSnYOc75QLuB/ZCvBaXV5bKRnjMsIojTszWmd7QvkGz7eOq8UWCHv+mKODn7B/9syvao4gy32WX2EZZrtRLq1PJUISefUpPXtcXfshj56jwodcTYP+jHE/5GAfCtlFqDXUpbiijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957128; c=relaxed/simple;
	bh=Vlgcb/ABknARewwkqnfwmIf/xwSZAGnmY4xCLkywlJg=;
	h=Date:To:From:Subject:Message-Id; b=KpK98uKkkG8KG35a0GYW/g/5ZDiuPwW23OuMDdT59vZBDvV1DmUWV8uAAwApQfZP7p9UlU198jNAd/isb6Trvp00PjgpGkGl32LEGuj/BV4SNfKVl3BLIiZyJmtpPwHOJ6KxcYAmgdwaXB0JKH7CD6VGL4I2YkDBxsipq3UZPk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1jMMs4yT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1jMMs4yT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B46C113CC;
	Mon,  6 May 2024 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957128;
	bh=Vlgcb/ABknARewwkqnfwmIf/xwSZAGnmY4xCLkywlJg=;
	h=Date:To:From:Subject:From;
	b=1jMMs4yTAoM0SPIwj0G3eiBzGYlSPxsCz/zwpAbZZOEXg0oLDGapHvwUXoo1eCJsT
	 cef7XQoJ1V4v0MILo5aDfzC5uzW/RtplyqkW/gWnah4/hRZJRRb9KUxUY11K35j+4S
	 9MnVwOp0GZS9Ce5S+lmXzAfKSt57c0gtKfyuPUxA=
Date: Sun, 05 May 2024 17:58:47 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,jannh@google.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch removed from -mm tree
Message-Id: <20240506005848.78B46C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: optimise vmf_anon_prepare() for VMAs without an anon_vma
has been removed from the -mm tree.  Its filename was
     mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: optimise vmf_anon_prepare() for VMAs without an anon_vma
Date: Fri, 26 Apr 2024 15:45:03 +0100

If the mmap_lock can be taken for read, we can call __anon_vma_prepare()
while holding it, saving ourselves a trip back through the fault handler.

Link: https://lkml.kernel.org/r/20240426144506.1290619-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-optimise-vmf_anon_prepare-for-vmas-without-an-anon_vma
+++ a/mm/memory.c
@@ -3232,16 +3232,21 @@ static inline vm_fault_t vmf_can_call_fa
 vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	vm_fault_t ret = 0;
 
 	if (likely(vma->anon_vma))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
+		if (!mmap_read_trylock(vma->vm_mm)) {
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
 	}
 	if (__anon_vma_prepare(vma))
-		return VM_FAULT_OOM;
-	return 0;
+		ret = VM_FAULT_OOM;
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
+		mmap_read_unlock(vma->vm_mm);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

