Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A65D3839A1;
	Sat, 17 Oct 2026 01:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792202336; cv=none; b=kg99LD/p0Go9NvsjHE220Elvmiu0UKYhDxQJ3Q5Oh37Qv0EvoxUTnzAw7nMlA5kNqwPnpDQhZtOqXvnV0ySg0bogRZrbWzFbWyqMvMO4QNFIz8r8sacCROe1Rkvhsat77Ikg6mWpC+brQADn9NZcQRoIOdyR4W6gBWNw6OWE9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792202336; c=relaxed/simple;
	bh=HplwlsGM2lyiBq2P77ojlm6MTaRfdEFAmJaL+hDUqIk=;
	h=Date:To:From:Subject:Message-Id; b=uo3zX9gjFYup6notYeTqHuZCNNURMnYOStoHMOo9cOczaUI3d0nqhHdG1W8oMqzZbSMlaVgFscP7nMRM+38Isf05zG3ykQnZTXiQOu0paqpsrFdBvYBc8qAPSHhhRc1AYUDBhAGMNaVNxMevD2TDvHPDEs9mHvcQCZegCJLMpXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9cTw3vf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9cTw3vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC941F000C4;
	Sat, 17 Oct 2026 01:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792202335;
	bh=Y6PL4QJpzuOuNlOKSjKEgmfWQ4KB4rl13vCBS87J/iw=;
	h=Date:To:From:Subject;
	b=Z9cTw3vfcE5SdYnK0hZKFaj8b4ykb3hfHFYgzZnMxlOmre48wBOvdW9CKCPcOJKLA
	 2+igazlDQDn215OAEsWMcjEO5SpqyZLpTSi79CNTt+jeN7CGKGwXNsayfBGK4LKRsO
	 wqouPBm0yvFH6VZaSKXMltJCjZ4LW/MtmVqjZ+Wg=
Date: Fri, 16 Oct 2026 18:58:54 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,stable@vger.kernel.org,jack@suse.cz,bfoster@redhat.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch added to mm-unstable branch
Message-Id: <20261017015855.2FC941F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/truncate: fix the zeroing end of pagecache_isize_extended()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch

This patch will later appear in the mm-unstable branch at
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
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: mm/truncate: fix the zeroing end of pagecache_isize_extended()
Date: Fri, 16 Oct 2026 18:27:21 -0400

A process that extends a file by 4 GiB or more past a dirty folio, on a
file system whose block size is smaller than the page size (ext4 with 1k
blocks), reads back the bytes it wrote through a shared mapping beyond the
old end of file instead of zeroes, and a later write into that block
carries them to the disk.  With the example of commit 52aecaee1c26 ("mm:
zero range of eof folio exposed by inode size extension") and the truncate
taken 4 GiB further (pwrite 2k at 0, mmap the first page and write 'X'
over [2k, 4k), truncate(2) to 4 GiB + 2k), the read of [2k, 4k) returns
the 2048 'X' bytes, and a pwrite of 16 bytes at 3k followed by fsync() and
a remount leaves 1008 'X' bytes on the disk in [3k+16, 4k).  No privilege
is needed, and every size extension of 4 GiB or more reaches it:
truncate(2)/ftruncate(2) through truncate_setsize(), writes beyond the end
of file through generic_write_end(), ext4, iomap, btrfs, exfat, ntfs, afs
and orangefs.  Affected since v6.13.

pagecache_isize_extended() zeroes the part of the dirty folio straddling
the old end of file that the size extension exposes, from the old size to
the new size or the end of the folio, whichever comes first:

	end = min_t(unsigned int, to - folio_pos(folio), folio_size(folio));

min_t() converts both operands to unsigned int before comparing, so the
loff_t difference to - folio_pos(folio) is reduced modulo 2^32 first. 
When the file grows by 4 GiB or more past the folio, end is that residue
instead of folio_size(folio): below offset nothing is zeroed, above it
only [offset, end) is.  The bytes beyond the old end of file stay in the
dirty folio and, now inside i_size, are file data.

Compare in loff_t; the result is at most folio_size(folio) and fits end.

Found while formally verifying pagecache_isize_extended() against the
kernel binary.

Link: https://lore.kernel.org/20261016222721.791785-1-nickolai@csail.mit.edu
Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@vger.kernel.org>
---

 mm/truncate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/truncate.c~mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended
+++ a/mm/truncate.c
@@ -919,8 +919,7 @@ void pagecache_isize_extended(struct ino
 		unsigned int offset, end;
 
 		offset = from - folio_pos(folio);
-		end = min_t(unsigned int, to - folio_pos(folio),
-			    folio_size(folio));
+		end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));
 		folio_zero_segment(folio, offset, end);
 	}
 
_

Patches currently in -mm which might be from nickolai@csail.mit.edu are

mm-mlock-use-a-long-for-the-page-count-in-mlock_fixup.patch
mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch

