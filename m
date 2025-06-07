Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F1B2CA6
	for <mm-commits@vger.kernel.org>; Sat,  7 Jun 2025 22:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749334095; cv=none; b=hNg8F2oJ6ZdN8WEhcDeZz13XWCc4c/49rG3rRqxgWqXbrbWNfkzUH0MLh1dbiZTb5qpycLH8G9WfRBy0/A+RXdpulvRirmw/I4izsitQ4ZGkAWDbAm5YvZb+bDlLOHOqmg22fJhCXiPO4wQY7HQJl9+vQc8EpkSI3XIhsIel7/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749334095; c=relaxed/simple;
	bh=bKvyRpUFTQyi+1VkE8/CGAfs59skasAuP9BbXq9NEgo=;
	h=Date:To:From:Subject:Message-Id; b=nzKfhter4UcPwdF0CEvTG8GAzvYy4fz61nT4p6uP+ODGlohkhhmuq73zD4US0WuGPOgNGOm5YnE+D2XUlqmlE3NvaJOphiE76aCknY9xYlGiBlI3cRM3PbuvgAXNT9JebjdvFzE4tMlNJ0eczO4jPd9Zy5w86e+HtKAnuwdY4JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eCJZd2DG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eCJZd2DG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B2FC4CEF1;
	Sat,  7 Jun 2025 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749334094;
	bh=bKvyRpUFTQyi+1VkE8/CGAfs59skasAuP9BbXq9NEgo=;
	h=Date:To:From:Subject:From;
	b=eCJZd2DG6nOaA6Ho/wSkhSdDbrAKENceYhMGdQzI5gBQwtK3UAoAyLvcP+uM0anlm
	 3CA5OYwRt0mF/tv2FX3RRJOFUm91HeSRdi43VJv/hlwIVnLel5yVczZMHBsWPN8u4m
	 1onZ+5n8wpeB/l77KJj2KMGVrwgavnOX5VyezUdQ=
Date: Sat, 07 Jun 2025 15:08:14 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch added to mm-new branch
Message-Id: <20250607220814.C4B2FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET
has been added to the -mm mm-new branch.  Its filename is
     userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET
Date: Sat, 07 Jun 2025 02:40:03 -0400

UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET have been unused since
they were added in commit 932b18e0aec6 ("userfaultfd:
linux/userfaultfd_k.h").  Remove them and the associated BUILD_BUG_ON()
checks.

Link: https://lkml.kernel.org/r/20250607-uffd-fixes-v2-4-339dafe9a2fe@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |    2 --
 include/linux/userfaultfd_k.h |    4 ----
 2 files changed, 6 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set
+++ a/fs/userfaultfd.c
@@ -2118,8 +2118,6 @@ static int new_userfaultfd(int flags)
 
 	/* Check the UFFD_* constants for consistency.  */
 	BUILD_BUG_ON(UFFD_USER_MODE_ONLY & UFFD_SHARED_FCNTL_FLAGS);
-	BUILD_BUG_ON(UFFD_CLOEXEC != O_CLOEXEC);
-	BUILD_BUG_ON(UFFD_NONBLOCK != O_NONBLOCK);
 
 	if (flags & ~(UFFD_SHARED_FCNTL_FLAGS | UFFD_USER_MODE_ONLY))
 		return -EINVAL;
--- a/include/linux/userfaultfd_k.h~userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set
+++ a/include/linux/userfaultfd_k.h
@@ -30,11 +30,7 @@
  * from userfaultfd, in order to leave a free define-space for
  * shared O_* flags.
  */
-#define UFFD_CLOEXEC O_CLOEXEC
-#define UFFD_NONBLOCK O_NONBLOCK
-
 #define UFFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
-#define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
 
 /*
  * Start with fault_pending_wqh and fault_wqh so they're more likely
_

Patches currently in -mm which might be from tz2294@columbia.edu are

userfaultfd-correctly-prevent-registering-vm_droppable-regions.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch
compiler_types-remove-unnecessary-indirection-in-compiletime_assert.patch

