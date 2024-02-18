Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AFF8C1A
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708291806; cv=none; b=ozUkOoAOV44Dw+gZSSIhOAWGsZwZsxHahHCx4O3txJWlK2E0svozTxY86ihsbg9FjTLQKV+x2jtAgVgw79Lwa1JOKDkzYe4IXb9lvYuJwYg9b1MYvICZMLbi0UMzMUP3Uagc6HKJ93aTujEUl5w9ZUJUup6r3MhuqHLlyLnS3FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708291806; c=relaxed/simple;
	bh=tyDTN2+QiC0ODj7oc7A3v5hQGGuEXTBFw0I9RSQp/Nk=;
	h=Date:To:From:Subject:Message-Id; b=dn5ui16AawO+BdMVez9S1xbcVjBPE6i660CUxSEVCOu4K2kf9JhXNrOd9WXKJJ5r6HC2rVC60G5tpsEN1khcHYrkuTwiga6o+txDnm+Mn/qGY3xG9pv6Fx2IZh8yAKxFBSjZ92A5xZUuPIkWngtsEvozPrEryDN7BvDWn06m0Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMOvCA9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMOvCA9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD82C433F1;
	Sun, 18 Feb 2024 21:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708291805;
	bh=tyDTN2+QiC0ODj7oc7A3v5hQGGuEXTBFw0I9RSQp/Nk=;
	h=Date:To:From:Subject:From;
	b=tMOvCA9INSmgkJduOZ5IYjNEZCge52sg6cmE/AaLtjRhiIi2E5lY4uwsHpMb9Yplz
	 gxpC3QQlVD3VHgq6LEq8gNpp/T+ONhIXgq0kt/NhmrgUuNSUEC3r0PYlmRdvtRLUJx
	 4gG3d+WH8u05nT19prjqRI0rNchgYLYXAmr6czss=
Date: Sun, 18 Feb 2024 13:30:04 -0800
To: mm-commits@vger.kernel.org,yajun.deng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-add-case-9-in-vma_merge.patch added to mm-unstable branch
Message-Id: <20240218213005.6CD82C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: Add case 9 in vma_merge()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-add-case-9-in-vma_merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-add-case-9-in-vma_merge.patch

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
mm-mmap-add-case-9-in-vma_merge.patch

