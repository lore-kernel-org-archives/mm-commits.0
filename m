Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35419153565;
	Sat,  1 Feb 2025 11:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410841; cv=none; b=OZI8Haa/GCZpnwkIfXZFS8LQW1s/EPlXs/bsuciGBwe35/j0afdawriqYuFrP9hGd2epjzGX8p6lRVmwwqv27g6AyVpFWXgSSxB0Cn4qqPAHwDNbUpU4RzF1GnW6IbQBYlhfcJkagt/bujVImuce5ZOQCI0DniGOsocFDvLnZJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410841; c=relaxed/simple;
	bh=Ri0Bh4bGRPLXdLkUODfNEY3fS5fKYoonclrLiLNda5M=;
	h=Date:To:From:Subject:Message-Id; b=nr5UN10Azt0oCaBOfsRcm3HipKyD01ZCxn4vuM8OmmQY8Eq9O+8pOXWXnCGYYfvlyuo/lr9fd/pxWhU0AUWpreHFWBynasdQ6Ut+UpYxahi6KMI9MmmLQxMxPaTRHtC56QwvirsddtDKmjiHwhjR0K5FDRWvgk+zDKVklqlpBrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OGzXQMxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGzXQMxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18D0C4CED3;
	Sat,  1 Feb 2025 11:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410840;
	bh=Ri0Bh4bGRPLXdLkUODfNEY3fS5fKYoonclrLiLNda5M=;
	h=Date:To:From:Subject:From;
	b=OGzXQMxaLHLDK77p+JK2SNVFpQAIw7wL8VO+Gi/TjgBXBcQpl7aRrzXi6/Vwiusdx
	 UVhtxAJOqMlMExDJP1TS7jSil2gKZM0DWat+KVhCUhCzlKXBpAG6OKXFfog7zM+/aR
	 yqDW72YuO3t3ztZptG4j/hHff78onfB8K99KClck=
Date: Sat, 01 Feb 2025 03:54:00 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch removed from -mm tree
Message-Id: <20250201115400.A18D0C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix incorrect CPU endianness conversion causing mount failure
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heming Zhao <heming.zhao@suse.com>
Subject: ocfs2: fix incorrect CPU endianness conversion causing mount failure
Date: Tue, 21 Jan 2025 19:22:03 +0800

Commit 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
introduced a regression bug.  The blksz_bits value is already converted to
CPU endian in the previous code; therefore, the code shouldn't use
le32_to_cpu() anymore.

Link: https://lkml.kernel.org/r/20250121112204.12834-1-heming.zhao@suse.com
Fixes: 23aab037106d ("ocfs2: fix UBSAN warning in ocfs2_verify_volume()")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure
+++ a/fs/ocfs2/super.c
@@ -2285,7 +2285,7 @@ static int ocfs2_verify_volume(struct oc
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size bits: found %u, should be 9, 10, 11, or 12\n",
 			     blksz_bits);
-		} else if ((1 << le32_to_cpu(blksz_bits)) != blksz) {
+		} else if ((1 << blksz_bits) != blksz) {
 			mlog(ML_ERROR, "found superblock with incorrect block "
 			     "size: found %u, should be %u\n", 1 << blksz_bits, blksz);
 		} else if (le16_to_cpu(di->id2.i_super.s_major_rev_level) !=
_

Patches currently in -mm which might be from heming.zhao@suse.com are


