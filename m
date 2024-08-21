Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECBC53370
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 02:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724206072; cv=none; b=X6CZmU/1Mg2zHGqCyuF1Sx6FnQRIJJYU+LLuB+meQA4mHzwpSt5jTejAPBvnryYaJU7xFDhhNxkfIjemWZDS8nNYLF7OWXGgtWg211r33FVe4mBaosoQ1k6dxmTtZj+DVU0eM2WUTlDBy5ypZmdKjISxQszDnBy/UOguFTpeamI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724206072; c=relaxed/simple;
	bh=sGVMt3GHmSbGjrcigy+cQ7zqF9nGE4XSHD+V4khaQg4=;
	h=Date:To:From:Subject:Message-Id; b=BZXujP1sFJTEVmQDnKHOFk4TdCTGU13jWQiwxuuuS5jm/SOwQ2xTFVgnIZ6BUbKyDCGQxOEnaS6JKqZrBplg2eEFeBhgN+EoDLTgLsWP/aK0vNHxCtxnlrovbiB13wApbPjYSqPyH8sqPzreRGSgShY2n14yPJURrkX7zXZwL/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pu99EMls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pu99EMls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9E9C4AF12;
	Wed, 21 Aug 2024 02:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724206071;
	bh=sGVMt3GHmSbGjrcigy+cQ7zqF9nGE4XSHD+V4khaQg4=;
	h=Date:To:From:Subject:From;
	b=pu99EMlsQwGtlp7W9Q7FfwxGapB3mUVemPpgUW0KsMiYf1Izq61adubNJT1VFuxUN
	 RljBYJtwXbbTErukqo+9pOwU3+mbZtF/MgY8ocmnCx5uhyIYJ/OY65pRPHrIgtmr5y
	 XSd0OxgHaICU8S0YN+eLcLjzJb1/aZpDNsA8iAS0=
Date: Tue, 20 Aug 2024 19:07:50 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,shuah@kernel.org,mpe@ellerman.id.au,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,kees@kernel.org,jeffxu@chromium.org,pedro.falcato@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-can_modify_vma-to-mm-vmah.patch added to mm-unstable branch
Message-Id: <20240821020751.6D9E9C4AF12@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move can_modify_vma to mm/vma.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-can_modify_vma-to-mm-vmah.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-can_modify_vma-to-mm-vmah.patch

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
From: Pedro Falcato <pedro.falcato@gmail.com>
Subject: mm: move can_modify_vma to mm/vma.h
Date: Sat, 17 Aug 2024 01:18:28 +0100

Patch series "mm: Optimize mseal checks", v3.

Optimize mseal checks by removing the separate can_modify_mm() step, and
just doing checks on the individual vmas, when various operations are
themselves iterating through the tree.  This provides a nice speedup and
restores performance parity with pre-mseal[3].

This series also depends on the powerpc series that removes arch_unmap[2]. This
series is already in mm-unstable.

will-it-scale mmap1_process[1] -t 1 results:

commit 3450fe2b574b4345e4296ccae395149e1a357fee:

min:277605 max:277605 total:277605
min:281784 max:281784 total:281784
min:277238 max:277238 total:277238
min:281761 max:281761 total:281761
min:274279 max:274279 total:274279
min:254854 max:254854 total:254854
measurement
min:269143 max:269143 total:269143
min:270454 max:270454 total:270454
min:243523 max:243523 total:243523
min:251148 max:251148 total:251148
min:209669 max:209669 total:209669
min:190426 max:190426 total:190426
min:231219 max:231219 total:231219
min:275364 max:275364 total:275364
min:266540 max:266540 total:266540
min:242572 max:242572 total:242572
min:284469 max:284469 total:284469
min:278882 max:278882 total:278882
min:283269 max:283269 total:283269
min:281204 max:281204 total:281204

After this patch set:

min:280580 max:280580 total:280580
min:290514 max:290514 total:290514
min:291006 max:291006 total:291006
min:290352 max:290352 total:290352
min:294582 max:294582 total:294582
min:293075 max:293075 total:293075
measurement
min:295613 max:295613 total:295613
min:294070 max:294070 total:294070
min:293193 max:293193 total:293193
min:291631 max:291631 total:291631
min:295278 max:295278 total:295278
min:293782 max:293782 total:293782
min:290361 max:290361 total:290361
min:294517 max:294517 total:294517
min:293750 max:293750 total:293750
min:293572 max:293572 total:293572
min:295239 max:295239 total:295239
min:292932 max:292932 total:292932
min:293319 max:293319 total:293319
min:294954 max:294954 total:294954

This was a Completely Unscientific test but seems to show there were
around 5-10% gains on ops per second.

Oliver performed his own tests and showed[3] a similar ~5% gain in them.

[1]: mmap1_process does mmap and munmap in a loop. I didn't bother testing multithreading cases.
[2]: https://lore.kernel.org/all/20240807124103.85644-1-mpe@ellerman.id.au/
[3]: https://lore.kernel.org/all/ZrMMJfe9aXSWxJz6@xsang-OptiPlex-9020/
Link: https://lore.kernel.org/all/202408041602.caa0372-oliver.sang@intel.com/


This patch (of 7):

Move can_modify_vma to vma.h so it can be inlined properly (with the
intent to remove can_modify_mm callsites).

Link: https://lkml.kernel.org/r/20240817-mseal-depessimize-v3-1-d8d2e037df30@gmail.com
Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   17 -----------------
 mm/vma.h   |   28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 17 deletions(-)

--- a/mm/mseal.c~mm-move-can_modify_vma-to-mm-vmah
+++ a/mm/mseal.c
@@ -16,28 +16,11 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-static inline bool vma_is_sealed(struct vm_area_struct *vma)
-{
-	return (vma->vm_flags & VM_SEALED);
-}
-
 static inline void set_vma_sealed(struct vm_area_struct *vma)
 {
 	vm_flags_set(vma, VM_SEALED);
 }
 
-/*
- * check if a vma is sealed for modification.
- * return true, if modification is allowed.
- */
-static bool can_modify_vma(struct vm_area_struct *vma)
-{
-	if (unlikely(vma_is_sealed(vma)))
-		return false;
-
-	return true;
-}
-
 static bool is_madv_discard(int behavior)
 {
 	switch (behavior) {
--- a/mm/vma.h~mm-move-can_modify_vma-to-mm-vmah
+++ a/mm/vma.h
@@ -361,4 +361,32 @@ struct vm_area_struct *vma_iter_prev_ran
 	return mas_prev_range(&vmi->mas, 0);
 }
 
+#ifdef CONFIG_64BIT
+
+static inline bool vma_is_sealed(struct vm_area_struct *vma)
+{
+	return (vma->vm_flags & VM_SEALED);
+}
+
+/*
+ * check if a vma is sealed for modification.
+ * return true, if modification is allowed.
+ */
+static inline bool can_modify_vma(struct vm_area_struct *vma)
+{
+	if (unlikely(vma_is_sealed(vma)))
+		return false;
+
+	return true;
+}
+
+#else
+
+static inline bool can_modify_vma(struct vm_area_struct *vma)
+{
+	return true;
+}
+
+#endif
+
 #endif	/* __MM_VMA_H */
_

Patches currently in -mm which might be from pedro.falcato@gmail.com are

selftests-mm-add-mseal-test-for-no-discard-madvise.patch
selftests-mm-add-mseal-test-for-no-discard-madvise-fix.patch
mm-move-can_modify_vma-to-mm-vmah.patch
mm-munmap-replace-can_modify_mm-with-can_modify_vma.patch
mm-mprotect-replace-can_modify_mm-with-can_modify_vma.patch
mm-mremap-replace-can_modify_mm-with-can_modify_vma.patch
mseal-replace-can_modify_mm_madv-with-a-vma-variant.patch
mm-remove-can_modify_mm.patch
selftests-mm-add-more-mseal-traversal-tests.patch

