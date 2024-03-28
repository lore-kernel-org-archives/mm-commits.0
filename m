Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F86313790B
	for <mm-commits@vger.kernel.org>; Thu, 28 Mar 2024 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711653375; cv=none; b=crdzLPUIJy/M2iBZqANPMHRDUbZA+8Fxl4DAvD2mJ/ATzE3MGm/QTI74OuPhKRzUeIk1UDDL13ulFps+ZMP+d84UlqK2n+ECMNrXCDHDFOTov6BOlQSoJa8JhTrj84txLMQVkBDcwls72PXwjdBCu5d00IsuyDoB8Fob/P8Qgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711653375; c=relaxed/simple;
	bh=BC9Unvt/XBdna8iIhiQoDhZOuQo4ts2V/aQIfd6wGEQ=;
	h=Date:To:From:Subject:Message-Id; b=gEA29rIv58i95mRDN/NxIkLpEWta7iJvOJaG8scUz+znvXnbAL+fmvG2GJNANJ/GbdaY9nU3CpGfZLiAFz8MHkZt+fCM9YA+S45MV674xBvoxLDJSkiXTZvGpQHL8qU91EHmA20gxt/MXyGCzjjJHbVyV4em7WRomVBr0nv4o34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c26XBIrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c26XBIrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E981EC433C7;
	Thu, 28 Mar 2024 19:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711653375;
	bh=BC9Unvt/XBdna8iIhiQoDhZOuQo4ts2V/aQIfd6wGEQ=;
	h=Date:To:From:Subject:From;
	b=c26XBIrVzp8pGLhNgUvMFnaetKVWxllK3mhfOTGts0hzb8Q/yvOCDNFZRPEzqKC8O
	 6fP50Q9+BR2l40iqd4L+PMnFj3otuXNOpImPDY2FGr5lTYI/+1xoczh7pbju0aJlr4
	 eI4Qe0xllpzsj6aU/ZhemLxrfZy45QqMkqSQACFg=
Date: Thu, 28 Mar 2024 12:16:14 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,heming.zhao@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-speed-up-chain-list-searching.patch added to mm-nonmm-unstable branch
Message-Id: <20240328191614.E981EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: speed up chain-list searching
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-speed-up-chain-list-searching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-speed-up-chain-list-searching.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: ocfs2: speed up chain-list searching
Date: Thu, 28 Mar 2024 20:52:02 +0800

Add short-circuit code to speed up searching

Link: https://lkml.kernel.org/r/20240328125203.20892-4-heming.zhao@suse.com
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/suballoc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/suballoc.c~ocfs2-speed-up-chain-list-searching
+++ a/fs/ocfs2/suballoc.c
@@ -2006,7 +2006,7 @@ static int ocfs2_claim_suballoc_bits(str
 	for (i = 0; i < le16_to_cpu(cl->cl_next_free_rec); i ++) {
 		if (i == victim)
 			continue;
-		if (!cl->cl_recs[i].c_free)
+		if (le32_to_cpu(cl->cl_recs[i].c_free) < bits_wanted)
 			continue;
 
 		ac->ac_chain = i;
_

Patches currently in -mm which might be from heming.zhao@suse.com are

ocfs2-improve-write-io-performance-when-fragmentation-is-high.patch
ocfs2-adjust-enabling-place-for-la-window.patch
ocfs2-speed-up-chain-list-searching.patch
ocfs2-fix-sparse-warnings.patch

