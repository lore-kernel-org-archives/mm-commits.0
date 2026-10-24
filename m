Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832526;
	b=LIF9mEUQ4/AsLb/GTq5zAzOlQzR+QrjXhm37JgffrMIi0WO1K4YWQ2cCVa+pYsgat29t
	 7eEYzptA4tPV/MQQ9WNZ3CgSrb0Go253vgPhAZ8qlyRy7NsP/nGk2rzrAz75bqVHtNhRl
	 gaENmQpcjFbFl8U1nK0j6Qoi2cg/DeSt944TF3SAwf30BQaAW+jPGyGj+Mfg4bNE8JBPL
	 mraUbXCuntpDW8uGqV57G3K9fc0kXgj5eVinQzWNALVEbsICbSz1LG7qNnKE8qCt4RvzA
	 DpzTqh59Dj/GJy9Rrj14vV8hLxHJuZlSZ14J7NMNdkblx0ODbEspdnwNl4opaV6Q7QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832526;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=54fbyhZ/v2AmcC30HiYwEZnHBeq1+IpuiMJA/79RJ8A=;
	b=rLWvQRP4fQ7iLk/tNYWBx9PL6TpnRxC3xubiVj2rWrLu7jDYFjHNdqsOzSJ1FKGvPPk6
	 5VLq3M/BEEBCIjovppEPJh+h4XUzbGbdR2/C996uANMbPGiZymdNXR7pMUWBdETzgskCv
	 RvW0lYQ/6kF6mkgwlREV5lrLpPTdRv8NY2z46s5PZfCVzze6dNY/hGnm33RDY+aj8Z03C
	 fxd+rH+k/Zr0j3x0gv7HtPo9YApquxcZTknDi5dviD1jKiMiU8nQU6+LPS9O1QBQtwPr4
	 Q/EdFJb742d9ygnsdq8Jd0l7RrkQpiSph/laRJro65dd1cjjaS1o/M8TDU7HNP8dtrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XbAek138;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F82606A320;
	Sat, 24 Oct 2026 09:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XbAek138
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3462C1F01825;
	Sat, 24 Oct 2026 09:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832526;
	bh=54fbyhZ/v2AmcC30HiYwEZnHBeq1+IpuiMJA/79RJ8A=;
	h=Date:To:From:Subject;
	b=XbAek138yHLDWwwelkoV7AFhz3N5NwqA++QSgm3YlTt8aNIMCtB6Mlejj2IXujqWT
	 rkD4PkV2u5wKEuJdlo8oUXppGfr8b84iwCzA7qoCXUni12XccldjIPCs5lR3AKe8eg
	 1ePIqboNQnvfKAqWdooC9h7TOYwPr7+1wEM6XMKA=
Date: Sat, 24 Oct 2026 02:02:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tytso@mit.edu,stable@vger.kernel.org,libaokun@linux.alibaba.com,jack@suse.cz,bfoster@redhat.com,nickolai@csail.mit.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch removed from -mm tree
Message-Id: <20261024090206.3462C1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/truncate: fix the zeroing end of pagecache_isize_extended()
has been removed from the -mm tree.  Its filename was
     mm-truncate-fix-the-zeroing-end-of-pagecache_isize_extended.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Assisted-by: LLM
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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

xarray-clear-the-new-heads-parent-before-freeing-the-old-head.patch
mm-vmalloc-read-vm_map_ram-block-regions-from-the-requested-offset.patch

