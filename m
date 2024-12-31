Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D623B4A21
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735605150; cv=none; b=ivlrNOO/FaPk5+GgMVxWCeEka21E0o78yhA5BcRFxHyGdBn0Y0aPE8eHrVA+QRvQXOe87vNO0dIBGkcbbtkhmLqRUnDZeHbuLcyimt2IE+rrPsxa6AQCeEMYbyXUBh0ZS+MNXtzUnc+rsSZZN2ztUcCLUorl2Un2iJfLgk24Py8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735605150; c=relaxed/simple;
	bh=pEk5ekJW593XePCsfjg5pOgW8xzSjgRHMyqgSLxU1sw=;
	h=Date:To:From:Subject:Message-Id; b=Xn+fogWXKyPYfjW1zGR2a5SqSeE2OK/t+ZWMF29MiA4XTfOePzWlX1Pz2Tadr0y0i9i/es2jjA+5FEUg3EHBJKyVpkFVorxaiN74gNLqPgMIlc7iSUyuedvwDaCxWsJGxyonV5eS9o1+cVVn7J0T4x58Sr/AG8B6wbed0YaDHv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cEaURHTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cEaURHTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4645BC4CED0;
	Tue, 31 Dec 2024 00:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735605150;
	bh=pEk5ekJW593XePCsfjg5pOgW8xzSjgRHMyqgSLxU1sw=;
	h=Date:To:From:Subject:From;
	b=cEaURHTSm9bY0BGStD9DySBqNwODLfU+aSvGBCEuX1qOW1lRZwb4u3KOpp5RHw92A
	 +Qf10lk70AkPTJGi9udlRul2DoIGnUjegVQPmu1J4/hrpkhP+IvaiMC0j+T7FI/iIZ
	 NIvB/pkSEPEnU7YxQ5EZEY6ad2WcSjK3JWgFmeJE=
Date: Mon, 30 Dec 2024 16:32:29 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch added to mm-nonmm-unstable branch
Message-Id: <20241231003230.4645BC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: don't allocate read_page cache if SQUASHFS_FILE_DIRECT configured
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: don't allocate read_page cache if SQUASHFS_FILE_DIRECT configured
Date: Sun, 29 Dec 2024 23:37:50 +0000

If Squashfs has been configured to directly read datablocks into the page
cache (SQUASHFS_FILE_DIRECT), then the read_page cache is unnecessary.

This improvement is due to the following two commits, which added the
ability to read datablocks into the page cache when pages were missing,
enabling the fallback which used an intermediate buffer to be removed.

commit f268eedddf359 ("squashfs: extend "page actor" to handle missing pages")
commit 1bb1a07afad97 ("squashfs: don't use intermediate buffer if pages missing")

This reduces the amount of memory used when mounting a filesystem by
block_size * maximum number of threads.

Link: https://lkml.kernel.org/r/20241229233752.54481-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/squashfs.h |    6 ++++++
 fs/squashfs/super.c    |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/squashfs/squashfs.h~squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured
+++ a/fs/squashfs/squashfs.h
@@ -14,6 +14,12 @@
 
 #define WARNING(s, args...)	pr_warn("SQUASHFS: "s, ## args)
 
+#ifdef CONFIG_SQUASHFS_FILE_CACHE
+#define SQUASHFS_READ_PAGES msblk->max_thread_num
+#else
+#define SQUASHFS_READ_PAGES 0
+#endif
+
 /* block.c */
 extern int squashfs_read_data(struct super_block *, u64, int, u64 *,
 				struct squashfs_page_actor *);
--- a/fs/squashfs/super.c~squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured
+++ a/fs/squashfs/super.c
@@ -323,7 +323,7 @@ static int squashfs_fill_super(struct su
 
 	/* Allocate read_page block */
 	msblk->read_page = squashfs_cache_init("data",
-		msblk->max_thread_num, msblk->block_size);
+		SQUASHFS_READ_PAGES, msblk->block_size);
 	if (IS_ERR(msblk->read_page)) {
 		errorf(fc, "Failed to allocate read_page block");
 		err = PTR_ERR(msblk->read_page);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-make-squashfs_cache_init-return-err_ptr-enomem.patch
squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch
documentation-update-the-squashfs-filesystem-documentation.patch
squashfs-update-kconfig-information.patch

