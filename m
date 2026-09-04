Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488F033D6FA;
	Fri,  4 Sep 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788545130; cv=none; b=RF1K7b5LD48Vk9OmiHN+Kx/KVO9lq6TzaiJP5h7DJrvzPqYruylmU78YTIsfvoXgM5IJfmjuHMRsgScq/QWdQEjG/ddVCMbE8YJmfc9ROr3OpZTKdOzdm9s/qU51GPNKrAcfxqf4yPtv+Aot+p6b4YVaTgT99m5exaSu7ib9S24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788545130; c=relaxed/simple;
	bh=xf9YQpqV6O8beA59SFNGAUbmUMNLPdBTWfTr7C154Jw=;
	h=Date:To:From:Subject:Message-Id; b=Ok+fPZ50raQg5fj9zF18vFemdj7NxLKaY41HmXyglt9n5UI1J+ByfbprgQfwlRhVCOT09zACZTuvS7cx3uVSeYqOmOjzA/WPep3D+wSVlstC38LdeL5/lXIsUnEgQqP568GkFtoxA4ht2o67y8zHkTLMHXzLbFwlvGdio9bHNmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oviO/jcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oviO/jcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E51F00A3D;
	Fri,  4 Sep 2026 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788545128;
	bh=wRykqgwPDdTt6UUjETqzys0HEo1jI/qE+UtDoXbnxjs=;
	h=Date:To:From:Subject;
	b=oviO/jcm6M/sjNtl9F2r5VAVS3XykRt+/si1aveSVUN2qjPMWbNdGfLI1LVb0319b
	 uZEZtd6yvulP0eLW6qrLf/9PL3SgZZE7wz6WKdjVqYfkm/H+jJUgIlQSA5dSJ2A2GP
	 LbADkbzSVKcrjL3qhZclMQrvzDbZG5m88/DdQ478=
Date: Fri, 04 Sep 2026 11:05:28 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,fadouse@pm.me,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ufs-use-u64-for-directory-size-in-ufs_last_byte.patch removed from -mm tree
Message-Id: <20260904180528.C16E51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ufs: use u64 for directory size in ufs_last_byte
has been removed from the -mm tree.  Its filename was
     ufs-use-u64-for-directory-size-in-ufs_last_byte.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


