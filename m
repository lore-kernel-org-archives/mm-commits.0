Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B0E1991D4
	for <mm-commits@vger.kernel.org>; Wed, 13 May 2026 04:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778646165; cv=none; b=I8kuZ0uUTXE/FnxDinEb0nM2gtGdn28soJPXUIljeIVMfpztd8X0xoJ3mFJYmTi3BRK4vH6xcUCYPNcbdH5NJt1AC15QW8HLA3+dptKCMF3Pvhxu4R/jzK279jeuLoGITqE4RZylxneBo53CJOXTuvpoNLAEHBVp4Jdb1yndDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778646165; c=relaxed/simple;
	bh=abwdr+V5iavUPhw4zXoPkWoeKo1Mi7xRyuH/LizE5w8=;
	h=Date:To:From:Subject:Message-Id; b=F8z2V+p4D0TIr0RWLNRf+deEtitztyoOncSDKKchiDNDvnqcOxnQ2AsnwMBVsf53bBB1PSh8MF8YkunnuXfd0oCTOPkftVkgjdZPC+Q9WEwvOfyfC+3/dbJPlJ3xoaXASW9x3D0AORJ6+2NzQQYETvGWAeoFzhDHktjsq+dHZSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tqRxUfDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tqRxUfDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7188C2BCB7;
	Wed, 13 May 2026 04:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778646164;
	bh=abwdr+V5iavUPhw4zXoPkWoeKo1Mi7xRyuH/LizE5w8=;
	h=Date:To:From:Subject:From;
	b=tqRxUfDx577hGrIHljxzAbp+fliUoOEcFYrlHS4SICokyUwrcncCpKLBZ89yLU4OV
	 wBGq5ufjGBzCUPxIGgpituiF0M2BbnKBDpOj/3krm9bmMG3Rz60odQ+VPw/CqnRSDz
	 mzxXY3A7pw87k5f4j7grJvi/aCK6+VH30IfoEf8o=
Date: Tue, 12 May 2026 21:22:44 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,sj@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-use-min-max-in-mseal_apply.patch added to mm-new branch
Message-Id: <20260513042244.A7188C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: use min/max in mseal_apply
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-use-min-max-in-mseal_apply.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-use-min-max-in-mseal_apply.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm/mseal: use min/max in mseal_apply
Date: Sun, 3 May 2026 13:59:16 +0200

Use the type-checked min()/max() macros instead of MIN()/MAX(), which are
supposed to be used "for obvious constants only".

Link: https://lore.kernel.org/20260503115915.18680-3-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mseal.c~mm-mseal-use-min-max-in-mseal_apply
+++ a/mm/mseal.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/mempolicy.h>
+#include <linux/minmax.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
@@ -65,8 +66,8 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		const unsigned long curr_start = MAX(vma->vm_start, start);
-		const unsigned long curr_end = MIN(vma->vm_end, end);
+		const unsigned long curr_start = max(vma->vm_start, start);
+		const unsigned long curr_end = min(vma->vm_end, end);
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-mseal-use-min-max-in-mseal_apply.patch
proc-use-strnlen-for-name-validation-in-__proc_create.patch

