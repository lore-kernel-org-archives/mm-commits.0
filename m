Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DAEBA53
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560090; cv=none; b=ll/41yPLfPF5ijYGCHWKgnsKsN6qEDYoUgPK3Ryxq/bMntzahmXke3UP/L6x9RueeDmv+xY1nt9yaUGsL5md+JaKiaZfToI3dyH2PFPnCihH+5pRSFaiyE1w6F4voKb09u67p42w2gfQh1OPlUrGSN2rYQvlv1r79EYt0BEsx5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560090; c=relaxed/simple;
	bh=FaaH47PAp7qddoP1j54w4esIhPEC3G4CObMh3prdRQU=;
	h=Date:To:From:Subject:Message-Id; b=pGSshTT7wp1wqJ0BqP4gHGsvA2ssiljcGwYVEsAVg5OqS/Y93THC9HWglwrbfYIIC/r27PGAXhTSHqMz4aXfSAR/FezKC7MmbXP/VZ1AfFIkyOGf4khv7m82NVSb/iDuhBXOloNFKDAKGlHJptKwl9YjDFfmQ8ENi8LHfObYMaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eod+XZrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eod+XZrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3531CC43390;
	Thu, 22 Feb 2024 00:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560090;
	bh=FaaH47PAp7qddoP1j54w4esIhPEC3G4CObMh3prdRQU=;
	h=Date:To:From:Subject:From;
	b=eod+XZrSW1AJZ/eTC2+wJCatH5OnSzKznRa3E5SdCFHBcfwsFBL9a92KebHBtiw7X
	 tnyfjp6Mt2gO4ngzXGyqRtgGqjzNB/E7LojykTh66LNWsb8M87B9xWNgAVe28Li7LP
	 91oCqT1pl4BMl8ybQgWtho4slePrqiTQVOeXN+pc=
Date: Wed, 21 Feb 2024 16:01:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch removed from -mm tree
Message-Id: <20240222000130.3531CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: fix return error if mmap_changing is non-zero in MOVE ioctl
has been removed from the -mm tree.  Its filename was
     userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix return error if mmap_changing is non-zero in MOVE ioctl
Date: Wed, 17 Jan 2024 14:39:21 -0800

To be consistent with other uffd ioctl's returning EAGAIN when
mmap_changing is detected, we should change UFFDIO_MOVE to do the same.

Link: https://lkml.kernel.org/r/20240117223922.1445327-1-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/userfaultfd.c~userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl
+++ a/fs/userfaultfd.c
@@ -2047,7 +2047,7 @@ static int userfaultfd_move(struct userf
 			ret = move_pages(ctx, mm, uffdio_move.dst, uffdio_move.src,
 					 uffdio_move.len, uffdio_move.mode);
 		else
-			ret = -EINVAL;
+			ret = -EAGAIN;
 
 		mmap_read_unlock(mm);
 		mmput(mm);
_

Patches currently in -mm which might be from lokeshgidra@google.com are

userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch
userfaultfd-protect-mmap_changing-with-rw_sem-in-userfaulfd_ctx.patch
mm-add-vma_assert_locked-for-config_per_vma_lock.patch
userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

