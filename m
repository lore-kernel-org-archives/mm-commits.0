Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE245472A
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 22:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708380015; cv=none; b=Z9N/Wu4hr9b/+AioXqiJFdFrzcDmDYYJBod86fZMp+fGtCwZM8EOZw2LOaf23ccrFqYxP6dFz80BFsunvsnxVzJq/DscK+vi/Harf6J6j/qfOLzUgMBieHXGHknNzRtgKDR/tIGb/piyEmfdB8MxURoK/LldsHt0rsM1QVLk8Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708380015; c=relaxed/simple;
	bh=cgM13/Zy3lP0x8z4a2vEetmO6XtjlWhAgTrt856zsP8=;
	h=Date:To:From:Subject:Message-Id; b=aaoMvaSYk05m+Llrg+jLXFYQeO+GgInt36fYba8mKvPBg9MR6JwjY6e/kd6MBPnIg5ROEGnK9/VMVtzjFvTjHOKxjZvSLQiWWSKnb8pSXEamf5BeL8WeD+2HriVoGP6z6kHQ1QS4spHHs8Tn7vT6Ibfm9wQTJuytuVUPSoyVvg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fiyuRA9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fiyuRA9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3127C433C7;
	Mon, 19 Feb 2024 22:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708380015;
	bh=cgM13/Zy3lP0x8z4a2vEetmO6XtjlWhAgTrt856zsP8=;
	h=Date:To:From:Subject:From;
	b=fiyuRA9omw3S34EP0fUTmo8XXNtz4a9FFuq8HTp6SmaAFONWn4Am4CKW7cjPIDnpo
	 rS0sXdOlqWRMEt35etL53RG9V6Ji4dwlSTqeubyDv71GDjSyPjS9sK/c+hYHZ+OxN1
	 +YtJCxdmeg/F8cyBzj7Sdh2FX1Ww0+VrmOhgjBWo=
Date: Mon, 19 Feb 2024 14:00:14 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mmap-add-case-9-in-vma_merge.patch removed from -mm tree
Message-Id: <20240219220014.F3127C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmap: Add case 9 in vma_merge()
has been removed from the -mm tree.  Its filename was
     mm-mmap-add-case-9-in-vma_merge.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/mmap: Add case 9 in vma_merge()
Date: Sun, 18 Feb 2024 16:50:28 +0800

If the prev vma exists and the end is less than the end of prev, we
can return NULL immediately. This reduces unnecessary operations.

Link: https://lkml.kernel.org/r/20240218085028.3294332-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-add-case-9-in-vma_merge
+++ a/mm/mmap.c
@@ -827,7 +827,7 @@ can_vma_merge_after(struct vm_area_struc
  *
  *     ****             ****                   ****
  *    PPPPPPNNNNNN    PPPPPPNNNNNN       PPPPPPCCCCCC
- *    cannot merge    might become       might become
+ *    cannot merge 9  might become       might become
  *                    PPNNNNNNNNNN       PPPPPPPPPPCC
  *    mmap, brk or    case 4 below       case 5 below
  *    mremap move:
@@ -890,6 +890,9 @@ static struct vm_area_struct
 	if (vm_flags & VM_SPECIAL)
 		return NULL;
 
+	if (prev && end < prev->vm_end) /* case 9 */
+		return NULL;
+
 	/* Does the input range span an existing VMA? (cases 5 - 8) */
 	curr = find_vma_intersection(mm, prev ? prev->vm_end : 0, end);
 
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-mmap-simplify-vma-link-and-unlink.patch
mm-mmap-introduce-vma_set_range.patch
mm-mmap-use-sz_8k-128k-helper-macro.patch
mm-mmap-pass-vma-to-vma_merge.patch

