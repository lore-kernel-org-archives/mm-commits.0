Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0EB54BD2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970609; cv=none; b=tvt9eYBePgjsUvTfwMCchLGazWI9mPHOiMSA4BXMb+upJxLnmvaePgi73loDPHO69Z95VDHoXu/CxqAkDBxWfEjM7Zh43f4Uwg5srqbj7B3U0B+Xxm1sxNcwQI3C38/JCBQ0GJ66pzJ2uDhTP+B7BsjOvkBMbMp5aOqV4s6UTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970609; c=relaxed/simple;
	bh=wLZagRUTB0lDnWOTulKQCK+Iaw7YhkLiwtKf9C5FYjU=;
	h=Date:To:From:Subject:Message-Id; b=VY5vj0dxTsM0KC3GEz+ZXdAZPtEKWwlZz9RrlSd83NI+kvGzBkCfxz/PoVbzh0tFKFJDB8uJwGAh/sWLb9MRp2B0tUnaJJrZnn3tT2JryRovoZkZkiL/cz3eSX3rh3zUXmM1eVyQQaxNWua/mSBlE10gABmNVeQDS5rmYGjxMW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cbolvDm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cbolvDm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CECDC433C7;
	Tue, 23 Jan 2024 00:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970609;
	bh=wLZagRUTB0lDnWOTulKQCK+Iaw7YhkLiwtKf9C5FYjU=;
	h=Date:To:From:Subject:From;
	b=cbolvDm8mMXDRct2TdgvTz5L7GPFZf5VOhXJ5BJGnq/PovB2z8KHhWd++oT1goYFX
	 xInXa+/6VSv9gOn9flMVoVytF+/Q2t2pODTXrA7oTGba10gYiCX3dCDmhlrNrw5Y9c
	 nNLCECR2Inv6ocFCf52/0IjtXTxiS23ZNsQtSltc=
Date: Mon, 22 Jan 2024 16:43:26 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@oracle.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch added to mm-unstable branch
Message-Id: <20240123004329.0CECDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: avoid duplicate variable init in mast_spanning_rebalance()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch

This patch will later appear in the mm-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: maple_tree: avoid duplicate variable init in mast_spanning_rebalance()
Date: Mon, 22 Jan 2024 11:20:00 +0100

The local variables r_tmp and l_tmp in mast_spanning_rebalance() are
already initialized at its declaration; there is no need to assign the
value again.

Remove the duplicate initialization of {r,l}_tmp.  No functional change. 
Due to common compiler optimizations, also no change to object code.

This issue was identified with clang-analyzer's dead stores analysis.

Link: https://lkml.kernel.org/r/20240122102000.29558-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance
+++ a/lib/maple_tree.c
@@ -2271,8 +2271,6 @@ bool mast_spanning_rebalance(struct mapl
 	struct ma_state l_tmp = *mast->orig_l;
 	unsigned char depth = 0;
 
-	r_tmp = *mast->orig_r;
-	l_tmp = *mast->orig_l;
 	do {
 		mas_ascend(mast->orig_r);
 		mas_ascend(mast->orig_l);
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch

