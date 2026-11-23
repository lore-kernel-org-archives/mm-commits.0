Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407298;
	b=gJ3QzhewDDpiKsNJEpDbJ7ipiWsUxosQCEYuYJ+FiuoigUm1/ZKmpc8CUZw/dgBuMWG+
	 gQwrH7uhn7rmoDal91K/d0Z3v/i28g2KALfdVS6zM8quFqWU4hLY1/0vOqyIz49UbBxXi
	 GsQNVftiS7I8GlcQmhEW+Ss5w/qUDofu3+Qcy9JxYPf30Oh6P3GUUNFUrzAbgRAQ/XZeJ
	 Pcmffdo5gWJN26pJ2EWxcKZKbjL9s63bR9f7vsVCYELqt0ZAkZ87zsu8AI5QKWyv2RZNn
	 BHuLO+im2puUnhcgHkZyJ29fmyEm9KntLcxDf4SdKk8TvqudQBlbI4pmtijG3OceK+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407298;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=oAFGkefyc+6sWruPqh3DKGWOs1bQdw1bvUiuUxh/Wuo=;
	b=Eai22fNTGeqGI/kZbLRTp0432zyKXxLI5iZX0W80MfDVZp8ns6Rjp3E4nVHMJzYKlqxe
	 uDJ5d9/OgNSY7CbzDtkNd+t277GSGCvl91J8W+5Ybu6wE70bei7ljcLgv7hyBZ9mD4Cac
	 XUDtlCKcLm+bN6FhrDkJ4fDCF2gha/XTk4twGmx7vqqU1WC0qgmRjQQMVRYI5J21mhGn9
	 cNgtwsNuO6e03QCfZ8iqaJbOjgTr53lX/69Dj5gaPBIPptdjXAN5T5+IE8j8O8cN9EKu/
	 YGODJwP5eyibeUxr9MlY/9jGKYy/5w/vLvVVjZ78PPGmtTAjgZsEoAa2S772qG+Z7sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RVzgPrqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981C2606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RVzgPrqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377001F000C6;
	Mon, 23 Nov 2026 04:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795407298;
	bh=oAFGkefyc+6sWruPqh3DKGWOs1bQdw1bvUiuUxh/Wuo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=RVzgPrqmPbvMCbv9xf3M6cWLGteta1CICPU4G5IgVYKPYKnyxG4SBAh6CIb0zI4DQ
	 oYHQviAJViJyUv9x5o3syQvUQDEP4PDw1MWPtPvpW99H7ghtM0dOONr1UhhX4sAnit
	 Ut3mnRXLazeQ6SKa3g+78bJVEEkXTpKmbS0rh3n0=
Date: Sun, 22 Nov 2026 20:14:57 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-24-phillip@squashfs.org.uk>
References: <20261123034304.261742-24-phillip@squashfs.org.uk>
Subject: + squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch added to mm-nonmm-unstable branch
Message-Id: <20261123041458.377001F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
Date: Mon, 23 Nov 2026 03:43:04 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://patch.msgid.link/20261123034304.261742-24-phillip@squashfs.org.uk
Fixes: e2780ab159ac ("Squashfs: block operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/block.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/squashfs/block.c~squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data
+++ a/fs/squashfs/block.c
@@ -297,6 +297,15 @@ int squashfs_read_data(struct super_bloc
 	int res;
 	int offset;
 
+	/*
+	 * Reject index values greater than possible filesystem size (S64_MAX).
+	 * This also ensures the index variable doesn't overflow in the function.
+	 */
+	if (index > S64_MAX) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (length) {
 		/*
 		 * Datablock.
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-or-size_t.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

