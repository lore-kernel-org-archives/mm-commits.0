Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9AF3FE4
	for <mm-commits@vger.kernel.org>; Tue,  3 Jun 2025 02:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748919144; cv=none; b=Ojh5izFFetBLGo/TG8ZMVYNBcfcmZbg/ZiTqVCc46XSjGfKQxChOaoH7Ga9k+pCI985u1Z9u6qGlOeOLlSEY31CRQ0L53GPUU9uw1akKEKk89qAtM4Rryq6+5gmOjmz3sgn3cggVK/K/rpD7/niLoyoBEdJoiLY3Txg/yQmdHwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748919144; c=relaxed/simple;
	bh=h6U/kC+It7VcqD3A17YOxhyuSbC86bwupRjtQIvtq4I=;
	h=Date:To:From:Subject:Message-Id; b=X+1jdMIjBUVRY6ijNUO4GeJ4JfmcxkCKIKn+LWkvf4m7h/HHUgTYgl7iBOYU84uVgn5ay8FMOdQzo0oied1ofp99hQJu6d7eEMfABW+baRZjwp4l8mI21uSqdNqDiupuZwIGV0ZLL0lnYojySMr6qu3fLZPQQhL7WgFUMqoQAlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SE1n7y1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SE1n7y1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6CEC4CEEB;
	Tue,  3 Jun 2025 02:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748919143;
	bh=h6U/kC+It7VcqD3A17YOxhyuSbC86bwupRjtQIvtq4I=;
	h=Date:To:From:Subject:From;
	b=SE1n7y1lEDDXqW+noPfOiRW/lwVS/9pncAu1JQkFj/cHXAbaS2cLxRtVff1Bro7pL
	 jxlsz7/bIsztBWRQYBVNIvVShqKCxTlTDyR6M6EuK2lfAx/HZTxhzvCWeyaBbTwLyY
	 w/Dio5u0zJYcmfaQc7MT4O1QFbvGOWBaJVCOhZb0=
Date: Mon, 02 Jun 2025 19:52:23 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,viro@zeniv.linux.org.uk,vbabka@suse.cz,shr@devkernel.io,Liam.Howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,chengming.zhou@linux.dev,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch added to mm-new branch
Message-Id: <20250603025223.BB6CEC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: ksm: refer to special VMAs via VM_SPECIAL in ksm_compatible()
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: ksm: refer to special VMAs via VM_SPECIAL in ksm_compatible()
Date: Thu, 29 May 2025 18:15:46 +0100

There's no need to spell out all the special cases, also doing it this way
makes it absolutely clear that we preclude unmergeable VMAs in general,
and puts the other excluded flags in stark and clear contrast.

Link: https://lkml.kernel.org/r/c8be5b055163b164c8824020164076ee3b9389bd.1748537921.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible
+++ a/mm/ksm.c
@@ -679,9 +679,8 @@ static int break_ksm(struct vm_area_stru
 
 static bool ksm_compatible(const struct file *file, vm_flags_t vm_flags)
 {
-	if (vm_flags & (VM_SHARED   | VM_MAYSHARE   | VM_PFNMAP  |
-			VM_IO       | VM_DONTEXPAND | VM_HUGETLB |
-			VM_MIXEDMAP | VM_DROPPABLE))
+	if (vm_flags & (VM_SHARED  | VM_MAYSHARE | VM_SPECIAL |
+			VM_HUGETLB | VM_DROPPABLE))
 		return false;		/* just ignore the advice */
 
 	if (file_is_dax(file))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch

