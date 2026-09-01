Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FCD386C03;
	Tue,  1 Sep 2026 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788305748; cv=none; b=RkF4+LaO93OJqg3Z0dhoMtn+pXT5E5Q2fm0bnhFsJV7YwYbmfQKIPPUfLL0rnXYUqTradxEIPrAA9EFxkv9Xb43KdFvl63hlcNgN+XYN5AtQFFbn7nY5S0IrfLLezsfs7/XaYXGygIOxR3+jRqdELi1JyF8uOMt9gltlEbGJ/mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788305748; c=relaxed/simple;
	bh=c5I7Fod9Ns0UQNu3GGNaWubu9lAOr8ZIobYQFXETTGs=;
	h=Date:To:From:Subject:Message-Id; b=lMlP7zQ4N6FJmzxxhZ8Zlp9eC3ePQv1hqg+y7sYr182UAMjfGFP36DDUM9yIcd0bkJBphGygml9rm3FTeVpTEoI9ZeNkr/aRcGRTHXHMa0huamBcl9RdYGjKz6LOuj197boBEXWareLdetsglCtxxIJaAvXGAz6Qth6W7GdtNUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GBkqAJVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GBkqAJVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315381F000E9;
	Tue,  1 Sep 2026 23:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788305744;
	bh=3gSL/9GYFq4h+89sI/QO7PTi3iJqFPJ/2QwpQ3mdiwc=;
	h=Date:To:From:Subject;
	b=GBkqAJVtk+ujTTYu1bE5E/zcNzhvLdlwmLhw9ZIeuJZ2ldEGn+KiDbr7OkOEusEyA
	 DHQuNCXkFITvfJ41RMr2nOHiQ7IKgO169aNemQQVn2F0M0BuLJzGbpwsAVQsMDDlVc
	 kQRom0nfYyFfCSwWineTVvK5+ymrvnAaxQSCIp6c=
Date: Tue, 01 Sep 2026 16:35:43 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,fadouse@pm.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ufs-use-u64-for-directory-size-in-ufs_last_byte.patch added to mm-nonmm-unstable branch
Message-Id: <20260901233544.315381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ufs: use u64 for directory size in ufs_last_byte
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ufs-use-u64-for-directory-size-in-ufs_last_byte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ufs-use-u64-for-directory-size-in-ufs_last_byte.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: YANXIN LI <fadouse@pm.me>
Subject: ufs: use u64 for directory size in ufs_last_byte
Date: Sat, 18 Jul 2026 19:03:07 +0000

ufs1_read_inode() and ufs2_read_inode() copy the untrusted 64-bit on-disk
size into inode->i_size.  ufs_last_byte() then truncates that value to an
unsigned int before calculating the valid extent of a directory folio.

A directory size of exactly 4 GiB is truncated to zero.  In
ufs_find_entry(), subtracting the requested record length from that zero
forms an endpoint almost 4 GiB beyond the mapped folio.  A crafted UFS2
image produces:

  BUG: KASAN: use-after-free in ufs_find_entry+0x583/0x6e0 [ufs]
  Read of size 1
  ...
  ufs_find_entry
  ufs_inode_by_name
  ufs_lookup
  __lookup_slow
  path_lookupat

The KASAN classification reflects that the adjacent physical page was
free; the source-level operation is an out-of-folio read.  A controlled
UFS1 test with CONFIG_UFS_FS_WRITE enabled also made ufs_find_entry()
return a directory entry from an adjacent anonymous page.  unlink() then
passed that pointer to ufs_delete_entry(), which cleared the adjacent
page's 32-bit d_ino.  This write result reproduced three out of three
times.

UFS normally requires a privileged mount path.  A relevant boundary is a
privileged automounter or image-processing service handling an
attacker-supplied filesystem.  The write primitive additionally requires
UFS1 to be mounted read-write with CONFIG_UFS_FS_WRITE enabled; the read
is reachable with read-only UFS2.

Keep the intermediate size arithmetic at 64 bits so non-final pages are
bounded at PAGE_SIZE.  With this change, the same controlled tests reach
the real on-disk directory entry and produce no adjacent-page write or
KASAN report.  A reproducer and full validation logs are available on
request.

The vulnerable helper is present in v7.2-rc3, v7.1, v6.18.38, v6.12.95,
v6.6.111, and upstream master at 1229e2e57a5c.  Runtime reproduction and
fix validation were performed in an x86-64 QEMU guest running v7.2-rc3
with generic KASAN.

Signed-off-by: YANXIN LI <fadouse@pm.me>
Fixes: b71034e5e67d ("[PATCH] ufs: directory and page cache: from blocks to pages")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ufs/dir.c~ufs-use-u64-for-directory-size-in-ufs_last_byte
+++ a/fs/ufs/dir.c
@@ -213,7 +213,7 @@ fail:
 static unsigned
 ufs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)
_

Patches currently in -mm which might be from fadouse@pm.me are

ufs-use-u64-for-directory-size-in-ufs_last_byte.patch

