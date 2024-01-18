Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95626321B9
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616177; cv=none; b=rxW0kRkFzF53DJ3VuFwj0fGGh7iTZdi8/Iv4puz/P+WZULrNmzFtDGwIf3wjIxcFz6qtzEtEpQTm2kYVK/8IXKBuOYDVDhAvDtjbiWzN4cDpZuapayFbGWm/IPDUc7dKY4n74BXm1zUfHu1VCjJpOWI/07KStpLnJftiVWWnhSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616177; c=relaxed/simple;
	bh=SeP8/R9JMKPWpwEUWhRPw2ETtaXzZEfODvar7BQQoUA=;
	h=Date:To:From:Subject:Message-Id; b=SYqFKh/1xLCA+W0IEptv1EUhvyFOGZq6Vm37DqB0KsyUKK1gvgOqa9VMuNrMCHBZ4c5uUrHzNLmJuyHGhER1VhX+WvD5EBo3y1kKlxTPhJt634/Et2E1RKycbzO+0EDXtO3iC4TeHGdNZcoET3Mi6manviXSN19j/FcuxW+th4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MtCRzqXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MtCRzqXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD29EC433C7;
	Thu, 18 Jan 2024 22:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616177;
	bh=SeP8/R9JMKPWpwEUWhRPw2ETtaXzZEfODvar7BQQoUA=;
	h=Date:To:From:Subject:From;
	b=MtCRzqXkkX5uYhwDdutwS2RuVNLEZ94nLnfyuXwoy8DmzhSeuUOljw7fYvqJIiZ4q
	 3fp8wpTNp86DICyw6HDwFkpMX7FIr1XsKkQhAN/666SMiaS9q+ffQW1U93QCmM8Th7
	 5BSP0LtZ3CYHS06s2Ee4bRxwoYVF3xquPpnMzNIU=
Date: Thu, 18 Jan 2024 14:16:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,peterx@redhat.com,ngeoffray@google.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch added to mm-unstable branch
Message-Id: <20240118221616.DD29EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: fix return error if mmap_changing is non-zero in MOVE ioctl
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch

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
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: fix return error if mmap_changing is non-zero in MOVE ioctl
Date: Wed, 17 Jan 2024 14:39:21 -0800

To be consistent with other uffd ioctl's returning EAGAIN when
mmap_changing is detected, we should change UFFDIO_MOVE to do the same.

Link: https://lkml.kernel.org/r/20240117223922.1445327-1-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
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

userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch

