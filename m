Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9197C248868
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160847; cv=none; b=INt6LD6t7LzKZpg/tZD71w4Gyp3bLMt13ZoFVHL+SvYzE2qcOR5cuBrND3cNpeM6fNFddv/pSO90Z3ogHTXmbgXOzmy5+Wcp6ZLyO1iyMMX9OYXEZLqIxG9muroYEjBtSe7D5AwIIRurHsg46qqhZdwbLMal0vbSveBT48aG/jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160847; c=relaxed/simple;
	bh=XwWxRUCdoPCTM6sr1mckFB4FMmfzpFA7Dr1A25ETbRM=;
	h=Date:To:From:Subject:Message-Id; b=rvnr9QwKJEpCH8GE6z4PnudxgHSoAcMnwgkPbs/NIybhMYa+CJ9ujDy0vDV3KMKm01wi/J0FH2jUnY6NhikgPsintDkef2fguBTStmCB90JiCZ01pDrnLi5iufJ2BMJKOJWXBDMkjO8ft3GN7Qbs/fVgjDqB3sIE8Ny1krQKH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XoGqfuXf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XoGqfuXf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620C4C4CEEF;
	Sat,  2 Aug 2025 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160847;
	bh=XwWxRUCdoPCTM6sr1mckFB4FMmfzpFA7Dr1A25ETbRM=;
	h=Date:To:From:Subject:From;
	b=XoGqfuXfremXBbdvea6id4bRT/Ga6jtDzAhYj3tJOEyx0/uS/zKb89tYKU8+9JkUV
	 vwf1F4znfWLUDCKz9Xo8L/eijHvcLgBBc6l8aZ1XozcGyMPOgCk2ual6G9gwCP5UIP
	 ht0zY6oBe3JTr06TRF2JJlTaElX0OLqnCXGiqO8Q=
Date: Sat, 02 Aug 2025 11:54:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-simplify-and-rename-vma-gap-check.patch removed from -mm tree
Message-Id: <20250802185407.620C4C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: simplify and rename VMA gap check
has been removed from the -mm tree.  Its filename was
     mm-mseal-simplify-and-rename-vma-gap-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mseal: simplify and rename VMA gap check
Date: Fri, 25 Jul 2025 09:29:44 +0100

The check_mm_seal() function is doing something general - checking whether
a range contains only VMAs (or rather that it does NOT contain any
unmapped regions).

So rename this function to range_contains_unmapped().

Additionally simplify the logic, we are simply checking whether the last
vma->vm_end has either a VMA starting after it or ends before the end
parameter.

This check is rather dubious, so it is sensible to keep it local to
mm/mseal.c as at a later stage it may be removed, and we don't want any
other mm code to perform such a check.

No functional change intended.

[lorenzo.stoakes@oracle.com: add comment explaining why we disallow gaps on mseal()]
  Link: https://lkml.kernel.org/r/d85b3d55-09dc-43ba-8204-b48267a96751@lucifer.local
Link: https://lkml.kernel.org/r/dd50984eff1e242b5f7f0f070a3360ef760e06b8.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Jeff Xu <jeffxu@chromium.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mseal.c |   51 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

--- a/mm/mseal.c~mm-mseal-simplify-and-rename-vma-gap-check
+++ a/mm/mseal.c
@@ -38,31 +38,40 @@ out:
 }
 
 /*
- * Check for do_mseal:
- * 1> start is part of a valid vma.
- * 2> end is part of a valid vma.
- * 3> No gap (unallocated address) between start and end.
- * 4> map is sealable.
+ * mseal() disallows an input range which contain unmapped ranges (VMA holes).
+ *
+ * It disallows unmapped regions from start to end whether they exist at the
+ * start, in the middle, or at the end of the range, or any combination thereof.
+ *
+ * This is because after sealng a range, there's nothing to stop memory mapping
+ * of ranges in the remaining gaps later, meaning that the user might then
+ * wrongly consider the entirety of the mseal()'d range to be sealed when it
+ * in fact isn't.
+ */
+
+/*
+ * Does the [start, end) range contain any unmapped memory?
+ *
+ * We ensure that:
+ * - start is part of a valid VMA.
+ * - end is part of a valid VMA.
+ * - no gap (unallocated memory) exists between start and end.
  */
-static int check_mm_seal(unsigned long start, unsigned long end)
+static bool range_contains_unmapped(struct mm_struct *mm,
+		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma;
-	unsigned long nstart = start;
+	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
 
-	/* going through each vma to check. */
 	for_each_vma_range(vmi, vma, end) {
-		if (vma->vm_start > nstart)
-			/* unallocated memory found. */
-			return -ENOMEM;
-
-		if (vma->vm_end >= end)
-			return 0;
+		if (vma->vm_start > prev_end)
+			return true;
 
-		nstart = vma->vm_end;
+		prev_end = vma->vm_end;
 	}
 
-	return -ENOMEM;
+	return prev_end < end;
 }
 
 /*
@@ -184,14 +193,10 @@ int do_mseal(unsigned long start, size_t
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	/*
-	 * First pass, this helps to avoid
-	 * partial sealing in case of error in input address range,
-	 * e.g. ENOMEM error.
-	 */
-	ret = check_mm_seal(start, end);
-	if (ret)
+	if (range_contains_unmapped(mm, start, end)) {
+		ret = -ENOMEM;
 		goto out;
+	}
 
 	/*
 	 * Second pass, this should success, unless there are errors
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


