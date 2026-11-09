Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794257582;
	b=GTHbk37Njn8PyqQ0sT8uuJ7ZRK/O4S8zlHwG8ao8dWatCMnwjTzvpPbAN6HMhaFv4dRy
	 GlL7nqDgBy5ExfBfeq2qzodGNEdvsLpI8VkAU1/jl7oZvGxUhttv5kvKmk8YcOIv9pTRj
	 UJ86OKYjI4Zds0r9kyG4mzA9OZ4tQzr+KQgCVZi9muKGZChU7bhq9pcA63dY5+lvJfsGi
	 oxU2z0Bol0iX5pBMH+2vjHXZPcYuDkdu+/ScTQsAHZ0MV3t3efgQgQqD9y+iROE55oIMy
	 QWW2BARPg4KDgbBHQo0yIDWusiuoitUbUPsO5dYNv6ZRIx/ertlSyaf81/BlehIyNrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794257582;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=CAET8kgkI0PYVe5hvBj5uZU70RHGqeoRshpvya75RQY=;
	b=hGBa3l9yNFyQvaE4lrhmIKDvLdVnkrjcMAHtygOtVnvPurl5iUzv1AqxMtKZopfOZ7DJ
	 ICbQWuoGx3hSYwY6BPTFjV8oFhRrE3V/7wemwBXxsEDntAi4zIXZRvv6tSd1g5GPKrDt+
	 +JdbFMGjT91qHqcZbMRwBUSiwKwAFqyzwWxUttd53XEGTAoFOgxUloHEhN94oNHiJsUV6
	 tgyHFZLbDVavYfmW7YvH+9InSE68WtsFV1J4eoxt73Lhrp4A07qy7FyziS97S4L+ULUA+
	 ksP7XiZQW1/lCucsS4SzuVCmvSQ9OXI2lihcsJd3b5+o+vj54ShvtilBULllIEuZn0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jXVzbi6n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB89F606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=jXVzbi6n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE4C1F0089F;
	Mon,  9 Nov 2026 20:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794257581;
	bh=CAET8kgkI0PYVe5hvBj5uZU70RHGqeoRshpvya75RQY=;
	h=Date:To:From:Subject;
	b=jXVzbi6nEMnPg07WgZ9OUNszazQ6JqTPPnLlrT1W6C+acLCNnuTsVXVcjvqQog0ow
	 LBcmEUSSfbHYHmFUGubolgwjWxKzjTAX1ZNt1bEj/1l5W4TMpY9iAPnkGxMeq+E96v
	 1lX+DYcYG1FINCoG0vBgQQByMyij5iYb9uHLZdo8=
Date: Mon, 09 Nov 2026 12:53:00 -0800
To: mm-commits@vger.kernel.org,joseph.qi@linux.alibaba.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-abstract-the-inline-data-i_size-bound-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261109205301.4EE4C1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ocfs2: abstract the inline data i_size bound check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-abstract-the-inline-data-i_size-bound-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-abstract-the-inline-data-i_size-bound-check.patch

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
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: abstract the inline data i_size bound check
Date: Mon, 09 Nov 2026 20:21:02 +0800

Fold the i_size against id_count test into a predicate, completing the
inline-data group.

No functional change intended.

Link: https://lore.kernel.org/20261109122121.21473-13-joseph.qi@linux.alibaba.com
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
---

 fs/ocfs2/inode.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/inode.c~ocfs2-abstract-the-inline-data-i_size-bound-check
+++ a/fs/ocfs2/inode.c
@@ -187,6 +187,11 @@ static bool ocfs2_dinode_has_oversized_i
 		ocfs2_max_inline_data_with_xattr(sb, di);
 }
 
+static bool ocfs2_dinode_has_inline_size_over_count(struct ocfs2_dinode *di)
+{
+	return le64_to_cpu(di->i_size) > le16_to_cpu(di->id2.i_data.id_count);
+}
+
 void ocfs2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = OCFS2_I(inode)->ip_attr;
@@ -1769,7 +1774,7 @@ int ocfs2_validate_inode_block(struct su
 			goto bail;
 		}
 
-		if (le64_to_cpu(di->i_size) > le16_to_cpu(data->id_count)) {
+		if (ocfs2_dinode_has_inline_size_over_count(di)) {
 			rc = ocfs2_error(sb,
 					 "Invalid dinode #%llu: inline data i_size %llu exceeds id_count %u\n",
 					 (unsigned long long)bh->b_blocknr,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-exempt-orphaned-dinodes-from-the-zero-nlink-check.patch
ocfs2-abstract-the-zero-nlink-or-mode-dinode-check.patch
ocfs2-abstract-the-dinode-i_blkno-mismatch-check.patch
ocfs2-abstract-the-dinode-ocfs2_valid_fl-check.patch
ocfs2-abstract-the-dinode-fs_generation-mismatch-check.patch
ocfs2-abstract-the-dinode-suballoc-slot-checks.patch
ocfs2-abstract-the-dinode-suballoc-bit-check.patch
ocfs2-abstract-the-dinode-orphaned-slot-check.patch
ocfs2-abstract-the-dinode-dio-orphaned-slot-check.patch
ocfs2-abstract-the-inline-data-dinode-guard-and-cluster-check.patch
ocfs2-abstract-the-inline-data-id_count-bound-check.patch
ocfs2-abstract-the-inline-data-i_size-bound-check.patch
ocfs2-abstract-the-fast-symlink-dinode-guard-and-size-check.patch
ocfs2-abstract-the-fast-symlink-nul-termination-check.patch
ocfs2-abstract-the-chain-list-dinode-guard-and-count-check.patch
ocfs2-abstract-the-chain-list-next-free-record-check.patch
ocfs2-abstract-the-chain-list-bits-per-cluster-check.patch
ocfs2-abstract-the-dinode-refcount-location-check.patch
ocfs2-abstract-the-zero-extent-list-count-check.patch
ocfs2-abstract-the-oversized-extent-list-count-check.patch
ocfs2-abstract-the-extent-list-next-free-record-check.patch
ocfs2-report-unrepairable-corruption-from-online-filecheck-fix.patch
ocfs2-check-dinode-nlink-and-mode-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-slot-in-online-filecheck.patch
ocfs2-check-dinode-suballoc-bit-in-online-filecheck.patch
ocfs2-check-dinode-orphaned-slots-in-online-filecheck.patch
ocfs2-check-inline-data-dinodes-in-online-filecheck.patch
ocfs2-check-fast-symlink-dinodes-in-online-filecheck.patch
ocfs2-check-chain-list-dinodes-in-online-filecheck.patch
ocfs2-check-dinode-refcount-location-in-online-filecheck.patch
ocfs2-check-extent-list-dinodes-in-online-filecheck.patch

