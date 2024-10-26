Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B52217F3C
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 02:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729910484; cv=none; b=PAXLZoZQh9MX3bJi2vATQkq9R3ktq2wHogx9WS/vky0/Wjoko8Sh0hyuTbwwMvU/VVfbu7J2FQ83HSQZrpEbdQusBLe5CJKDAq5BmfS3SpwuwDxFdEJgr7U5V4C+xhVYQ4O7XOXRv7hwRTwPQBuD/3qc04yldlerTlkbf3SFiwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729910484; c=relaxed/simple;
	bh=C7zo6pXOBXToSDAurDbkCFP4mHSrJuLNfQA7U12u6oU=;
	h=Date:To:From:Subject:Message-Id; b=NwS7KyMa3OOyKEcHIezS+tA6ipMkF27exIqs5TFZAyJNa05PEx+a8CxaLOVKC1PLGKnIt6yogQ2O4y7HD5rpLkh689PQTVr+0SbtOs0a7sROPDSQgP0wO7HVMPIbkZSpmNE0oFle8yWmVOu68Ff0AAoDX6LMN3HOlbtIl0Qm64A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bjS2S1jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bjS2S1jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B621BC4CEC3;
	Sat, 26 Oct 2024 02:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729910483;
	bh=C7zo6pXOBXToSDAurDbkCFP4mHSrJuLNfQA7U12u6oU=;
	h=Date:To:From:Subject:From;
	b=bjS2S1jp0dW/RW4eLpTzLdgwrOHIv8XG5mToGd7W7/kmfSPR6jHn+mbBdskcgplYS
	 QsCUoBN+NrT8m/Og47c7OtJdXn4s4NW1nodM0+j1aVH7qrLfOR7LJQr4xf4SNRoCio
	 +OpNBbCmtHmcxUbIv9Qbn37ddoo2vgEv67O/lXb8=
Date: Fri, 25 Oct 2024 19:41:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch added to mm-unstable branch
Message-Id: <20241026024123.B621BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch

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
Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
Date: Fri Oct 25 07:39:41 PM PDT 2024

remove now-unused local

mm/vma.c: In function 'vma_merge_new_range':
mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
  965 |         unsigned long start = vmg->start;
      |                       ^~~~~
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma.c~mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
+++ a/mm/vma.c
@@ -962,7 +962,6 @@ struct vm_area_struct *vma_merge_new_ran
 {
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next = vmg->next;
-	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
bootmem-stop-using-page-index-fix.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch

