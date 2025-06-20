Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBF522339
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 01:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750383254; cv=none; b=Y5wEIYXkURuDYWgEgfFdm22JBl9HOnUiBjrq7GSWbARYUP03qw2ledbg2+oZU1JsAU7+818A2YGBklmuonrH/DREpN4wT7Dw4Z0gCZeepXXRpJE6abqZB6djEvlJU6bugynSsCOlvjPgUJWNKuocKJS+9FMJ25I8kj1QCYl3554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750383254; c=relaxed/simple;
	bh=ykZ8KIKR8B1+kdFq2eQ8hyhO1n9zzmB+wEAKPtVysqc=;
	h=Date:To:From:Subject:Message-Id; b=XYS7t9FXTAlQNv5e7kaDMAdRMc1e8OOyKvoRIHFNEuQuavT8kyboiws+wSi+72rtJ480voMLs30PjCqL6FsnHiIw9OcHnLAemawh8s12RDbdufNfIq2PuqAF2BKDyygp1dOUSTH9ysCAyxE/8q64ei28VGKEKVwoOxvjhIBUshY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sm6PzV9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sm6PzV9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A655BC4CEEF;
	Fri, 20 Jun 2025 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750383253;
	bh=ykZ8KIKR8B1+kdFq2eQ8hyhO1n9zzmB+wEAKPtVysqc=;
	h=Date:To:From:Subject:From;
	b=sm6PzV9YjcR3Ee6vmAFb54scjTg1zhxehomlkvrqqWYbeIQwLwGe1ZnP5f9va4ADz
	 cC+VO/aDARMa9Lo8/JRWezGqoZ/XVvi4PO2I8oz/RYCjwxNcXLEcX7HfTqplLj9R1Y
	 XuJtxwL26pzWCbibBrJN8xjDdXLnh1B93dYzNSHs=
Date: Thu, 19 Jun 2025 18:34:13 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch added to mm-unstable branch
Message-Id: <20250620013413.A655BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET
Date: Thu, 19 Jun 2025 21:24:26 -0400

UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET have been unused since
they were added in commit 932b18e0aec6 ("userfaultfd:
linux/userfaultfd_k.h").  Remove them and the associated BUILD_BUG_ON()
checks.

Link: https://lkml.kernel.org/r/20250619-uffd-fixes-v3-4-a7274d3bd5e4@columbia.edu
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
@@ -2114,8 +2114,6 @@ static int new_userfaultfd(int flags)
 
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
userfaultfd-prevent-unregistering-vmas-through-a-different-userfaultfd.patch
userfaultfd-remove-vm_bug_ons.patch
userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

