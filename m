Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B9B45C08
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 20:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711397738; cv=none; b=dU34qrhuRMJIZa7ycMQiYm2+9Wy/rOaUcvK+aHI6OfY/QrBaXY8c4Rtg42lFEJ8logZ73aLb5a1nb3OEm2MCMkU5naZAALvzCO3O60v0ppODiLxajf+i2MAzD4lXY24AkTXdmiRX7IuiCpoBcqTPX1HFUm+vLeWOCP2f/fNXIyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711397738; c=relaxed/simple;
	bh=6sTV/53qr9Lg626rnHp2XIVz7gkJRsfXZAlFSpmI1Lg=;
	h=Date:To:From:Subject:Message-Id; b=TS1sLT+xORYpLwaAfX1XUgtAi8RvrP30iyFM/2NamdxRocW8e+1Tz+8/0vHZ9941KirHD+94s2zp8MtkJvDQA7E7V6GblsjcuCdNj0haz4xslLrLmAOeMQ752DXdPYmxZHxNfx/+lB4W82SDcB1qEnP9m5PaD6f8a8qvHwS7lR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AnSaAjor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AnSaAjor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEB2C433F1;
	Mon, 25 Mar 2024 20:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711397737;
	bh=6sTV/53qr9Lg626rnHp2XIVz7gkJRsfXZAlFSpmI1Lg=;
	h=Date:To:From:Subject:From;
	b=AnSaAjorzyMrtW1RumYH+Jrp+QsGjcoaYz8thmJ9tMD/Fhe700ugctm1nzpnSxmMC
	 uuG0AyYFLB+Cx8B4Hna31A9YG3A8r0J3UeqErxghykvK9vu7qJrHOAQx37GvCOdbNo
	 +TRaP5Yxvmxt7j67k+K0o8U7oQRwCLq7SF665acU=
Date: Mon, 25 Mar 2024 13:15:36 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,mingo@kernel.org,luto@kernel.org,hch@lst.de,fei1.li@intel.com,david@redhat.com,dave.hansen@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch added to mm-unstable branch
Message-Id: <20240325201537.6FEB2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix
Date: Mon Mar 25 01:14:34 PM PDT 2024

whitespace fix, per Ingo

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fei Li <fei1.li@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat/memtype.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/mm/pat/memtype.c~mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix
+++ a/arch/x86/mm/pat/memtype.c
@@ -958,6 +958,7 @@ static int follow_phys(struct vm_area_st
 
 	if (follow_pte(vma->vm_mm, vma->vm_start, &ptep, &ptl))
 		return -EINVAL;
+
 	pte = ptep_get(ptep);
 	*prot = pgprot_val(pte_pgprot(pte));
 	*phys = (resource_size_t)pte_pfn(pte) << PAGE_SHIFT;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-move-follow_phys-to-arch-x86-mm-pat-memtypec-fix.patch

