Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE16284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126244; cv=none; b=Q02kc6zupYgorKWZ/B8W8Rv2rmRj8m+6sZ6aKJ2M/D6bIdHrMiJQNMKtBSdeNCEHlUOzDHEnPrk1N/lBilnWVwC7IMTVMHNOBLyVh9+weV/0UBV3waJJnn92HhSe+lS1+P1VfY+3kU/ND+GNmc/mftGHfFnEA+Q7eWLUMysj35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126244; c=relaxed/simple;
	bh=C+R2e2gPnqwQp/K2p9eSx1hvpLmpaLJi7AtAvSmIUvc=;
	h=Date:To:From:Subject:Message-Id; b=FF7pDXC8PnW4nh5ZRPFApfv5/0EAH4Pak612VodzTiOSBviiB3CiicLYBMyhrHJ3ypkTTxk2JVIfApgsttFdQ6SJFql9qxRl1r9dWRG/VM80mMDdqastaRDvR1Mm/QJ/A82GZULuW/mrmGehPNKy1S9A1+rffQAEXUCaJhyaCdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VW8+V+EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VW8+V+EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149B7C4CEE3;
	Thu, 10 Jul 2025 05:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126244;
	bh=C+R2e2gPnqwQp/K2p9eSx1hvpLmpaLJi7AtAvSmIUvc=;
	h=Date:To:From:Subject:From;
	b=VW8+V+EMQpq0GOzs6g+s8O5a0f4bqwOnedUTw1IUy6UGRYmU3cl3KSV5yeuN+XIFP
	 Vk2SkjTgdmpLaAP9LAbR8yCRRh7QO/UvwKNTu3uJUHk9/GY1L06Nh0uYBSgi+Cq7Eb
	 016DILkHfMzAQiEdj+72OPUyQpybAW+QT8YEDkCA=
Date: Wed, 09 Jul 2025 22:44:03 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,peterx@redhat.com,Jason@zx2c4.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,aarcange@redhat.com,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch removed from -mm tree
Message-Id: <20250710054404.149B7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: remove UFFD_CLOEXEC, UFFD_NONBLOCK, and UFFD_FLAGS_SET
has been removed from the -mm tree.  Its filename was
     userfaultfd-remove-uffd_cloexec-uffd_nonblock-and-uffd_flags_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


