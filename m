Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475B21FE47B
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 19:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780256487; cv=none; b=c7yLnF4FB6o3brLD8eDYNn7ieO4yZnxfZV2b1sWMoMlrcQp1qQzCnO9ITyz401xl/gRb/dAAXAFi2iEEEbGhR0orzKkMAOg69RgTzpP8lTHS35cPFMZU8I3qXBfGyUf0P5Ux/CHQoLFh0PxJdV/Rd7lq384ZCIW2di2kZuuTh2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780256487; c=relaxed/simple;
	bh=JfBnUV1zIfURkL7b0wYkeXhcpvgREryncHy+AIZF9j8=;
	h=Date:To:From:Subject:Message-Id; b=g8n4qWauxO3ilq3vnETnm+QKm9qQhv+74si/EZRbpByZ/EfSY2+0TZO/9QLUOCtfCeWRWhtWQ7CxWJcm9Ybnh4wmarXKtBtAzIIPxeEEHHxWUA19xZVC/dtuaX7qWUtFumve2cFpNvJfPGsx3EST0mSO1y4e4MKYgvNwFn7aejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aM+cYfHn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aM+cYfHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0471F00898;
	Sun, 31 May 2026 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780256485;
	bh=JZd0hH2TfvRu27hxfyNs2R0SLb5CM24b1p0jDYQL07s=;
	h=Date:To:From:Subject;
	b=aM+cYfHnERyfOabQCzGAqWFB8Y+l6QjFEQbTjWfNIhsL8urFwxkY5qzzdkhSYPgqj
	 SLoD/OyOJfyf1jkscyQmTg2ioyG0jJpb9B1N5Iu/C01VvYLqQ8YrNvDrpoNH4CS6NT
	 GU35ieq1HEKqgvMYh7t4BDcEo5jG8/TZZDuN27uI=
Date: Sun, 31 May 2026 12:41:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,rollkingzzc@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch added to mm-nonmm-unstable branch
Message-Id: <20260531194125.BD0471F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: reject FITRIM ranges shorter than a cluster
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch

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
From: Zhang Cen <rollkingzzc@gmail.com>
Subject: ocfs2: reject FITRIM ranges shorter than a cluster
Date: Thu, 28 May 2026 23:12:47 +0800

ocfs2_trim_mainbm() trims the global bitmap in cluster units, but its
too-short range validation only checks sb->s_blocksize.

On filesystems with a cluster size larger than the block size, a FITRIM
range that is at least one block but shorter than one cluster is accepted
and shifted down to len == 0.  The later start + len - 1 and len -= ... 
arithmetic then underflows and can drive trimming past the requested
range.

Reject ranges shorter than s_clustersize instead.  That preserves the
existing -EINVAL behavior for requests that cannot discard even one
allocation unit and keeps zero-cluster trims out of the group walk.

Link: https://lore.kernel.org/20260528151247.361854-1-rollkingzzc@gmail.com
Fixes: aa89762c5480 ("ocfs2: return EINVAL if the given range to discard is less than block size")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Zhang Cen <rollkingzzc@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/alloc.c~ocfs2-reject-fitrim-ranges-shorter-than-a-cluster
+++ a/fs/ocfs2/alloc.c
@@ -7576,7 +7576,7 @@ int ocfs2_trim_mainbm(struct super_block
 	len = range->len >> osb->s_clustersize_bits;
 	minlen = range->minlen >> osb->s_clustersize_bits;
 
-	if (minlen >= osb->bitmap_cpg || range->len < sb->s_blocksize)
+	if (minlen >= osb->bitmap_cpg || range->len < osb->s_clustersize)
 		return -EINVAL;
 
 	trace_ocfs2_trim_mainbm(start, len, minlen);
_

Patches currently in -mm which might be from rollkingzzc@gmail.com are

ocfs2-rebase-copied-fsdlm-lvb-pointers-in-locking_state.patch
ocfs2-reject-oversized-group-bitmap-descriptors.patch
ocfs2-validate-fast-symlink-target-during-inode-read.patch
ocfs2-reject-fitrim-ranges-shorter-than-a-cluster.patch

