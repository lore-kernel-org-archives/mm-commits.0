Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2DFEEC0;
	Sun, 28 Jun 2026 01:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782610614; cv=none; b=HoI3ApRRe6HScxckgQmNbNRdSH1w5i/D8PX+U5HimLC2jrAdmEJs6UJxd/dOp/ibfqL9QxZ6GjEoH65hVXoMQD5nhQ2kw5GnFCsBpwWoZX+SjfFrK6JZavpENK+2pLEFA08thNdXqKKGxQqmEQbOiS+jx47GPSiCPqDsChtOmZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782610614; c=relaxed/simple;
	bh=qcyT18ycfgs67qeBeGLSw680gcNmqxnv+2QGvTVVH64=;
	h=Date:To:From:Subject:Message-Id; b=iDWIeIecvhRpNHr6pAuNPqPjWNtqt/2eJSlBOYGTXOjMiyM6ggXDfeB8krHGItSWQtWAidsmUZpMIEc9dQtY3revyParJr+u0hUjxudHaTRNQVAWkPT4AMci3dxCykBI/A5fw77z6cHHs0mukXMumq5b6hLahMX2gP5qzDOmmiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ubSpsty6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ubSpsty6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDE1F000E9;
	Sun, 28 Jun 2026 01:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782610612;
	bh=4ayx45IuqpUBVfUPNG6TijbKmA66iUihHOUZXkkdfuE=;
	h=Date:To:From:Subject;
	b=ubSpsty6vaTEh9LRYanM1L+PH9qAIcXBto8YuabribI0/FkkqGCmZLKCTO4Ga5vc1
	 yut3JUzuBDd0b9CdpghlmQnKtILhkq7qh9NQl/1obqOPvOafWqdpSEA1wcZXxgaZ1Z
	 QDHeUTz4yDNOr8GhDYT2Aixg9xzYQ9EYSjlmPxB0=
Date: Sat, 27 Jun 2026 18:36:51 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,baolin.wang@linux.alibaba.com,alhouseenyousef@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-zero-unused-folio-tail-for-long-symlinks.patch added to mm-new branch
Message-Id: <20260628013652.3EBDE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: zero unused folio tail for long symlinks
has been added to the -mm mm-new branch.  Its filename is
     tmpfs-zero-unused-folio-tail-for-long-symlinks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-zero-unused-folio-tail-for-long-symlinks.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: tmpfs: zero unused folio tail for long symlinks
Date: Sun, 28 Jun 2026 02:43:14 +0200

shmem_symlink() marks the entire folio uptodate after copying only the
NUL-terminated link target.  The remainder of the freshly allocated folio
is left uninitialized.

Reclaim may pass the whole folio to a swap compressor.  KMSAN observed
sw842_compress() computing a checksum over the uninitialized tail.  If the
folio is written to a swap device, those bytes can also leave the kernel.

Zero the remainder of the folio before marking it uptodate and dirty.

Link: https://lore.kernel.org/20260628004314.27370-1-alhouseenyousef@gmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+bf5586280a66e9ccdfa9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bf5586280a66e9ccdfa9
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~tmpfs-zero-unused-folio-tail-for-long-symlinks
+++ a/mm/shmem.c
@@ -4057,6 +4057,7 @@ static int shmem_symlink(struct mnt_idma
 			goto out_remove_offset;
 		inode->i_op = &shmem_symlink_inode_operations;
 		memcpy(folio_address(folio), symname, len);
+		folio_zero_range(folio, len, folio_size(folio) - len);
 		folio_mark_uptodate(folio);
 		folio_mark_dirty(folio);
 		folio_unlock(folio);
_

Patches currently in -mm which might be from alhouseenyousef@gmail.com are

tmpfs-zero-unused-folio-tail-for-long-symlinks.patch

