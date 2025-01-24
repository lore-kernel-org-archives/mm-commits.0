Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1B41D8E16
	for <mm-commits@vger.kernel.org>; Fri, 24 Jan 2025 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737700094; cv=none; b=bFlpxOCAbdopQeEmQGD2wZjOj1J9fol0ZNJUjo1K4SBvcHhs1ACtr8gIGxVJzpvr/CNd0HOHRT9wroARxnJdxRBqO+heBvkU5qvs1bVU+sqtuiwXZMb7nDRQZsgXraBv0rn1rhwXJGJ5clJZPePFixOqbUXQzUalJ5zQucUSUBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737700094; c=relaxed/simple;
	bh=hoxW8Y2XrdYyBzubGF/V4/TVFkJkGnjhgvNvKHwb1ec=;
	h=Date:To:From:Subject:Message-Id; b=haPYrxYjvAi8AAyJrY2GVskQO0CZMINrawG6j08IEtKoClZ0fKiNsKTu+IJ9PmtnsXSq2Pm9V7SKnIji2UKEjPDoDdCF5Mld3YPuTRtKNFBxzF68i1XHQK5gm82ZKfcoV9zxENhwur7mTz4uMs4bOK/J5Yw9GIQaf6caXKY85y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IUIVTYfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IUIVTYfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31D3C4CED2;
	Fri, 24 Jan 2025 06:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737700093;
	bh=hoxW8Y2XrdYyBzubGF/V4/TVFkJkGnjhgvNvKHwb1ec=;
	h=Date:To:From:Subject:From;
	b=IUIVTYfd4PGW7GQ7M3HA7rMf2vU1kqiIUmanoqeBw2epz7tBO8EHWJ5pkpN4A89yC
	 i8zkuLMcrYtOXJJumV5cmdaYpgo/HHEwEfiudHdj7JpcJ40m5MxcHuf3H7fatzGJ0J
	 XtDktZNyP3Ra2/arnK7JA3p6/vmbKsuN/f/jyYm0=
Date: Thu, 23 Jan 2025 22:28:13 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250124062813.C31D3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix incorrect CPU endianness conversion causing mount failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/super.c~ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure
+++ a/fs/ocfs2/super.c
@@ -2340,7 +2340,7 @@ static int ocfs2_verify_volume(struct oc
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

ocfs2-fix-incorrect-cpu-endianness-conversion-causing-mount-failure.patch

