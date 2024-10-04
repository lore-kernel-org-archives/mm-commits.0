Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B8A146000
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 22:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728082420; cv=none; b=lJhsG16T8nAIE9wMIx6A2QuIu52HCRAmQk4uepaJ4MV22ty7V5pLUk/BguqliCUriwdNuFh3eG8KkPFlVwKOUzf3rS/iIHHQiNo+rRmyamuCooICQXFM6mXJTrLI6+xzKI3he87IQlpBUlw3VcnIPpm0q1RnCwVea3WLMfxf7BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728082420; c=relaxed/simple;
	bh=QccNV+QXaW4FGwd3UPTiuJUhlvzQKeTpXXSes7BPBKI=;
	h=Date:To:From:Subject:Message-Id; b=YmGHHThWj97f66BqKqXjT5wWk6hs7sAOobhbocujaIaGdFBnuF8CaDbsAgCTy2S2ePMdtAQAooKpsNrZjrfdLBR3712ZFT5tU4WO2R7CbGamY6zR5pOdCZ+1wDYedgZNi4X+aHh8H0HaZ26F/avzXjr0smXlMEfwUILxYC974XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fzAyb6ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fzAyb6ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AEEC4CEC6;
	Fri,  4 Oct 2024 22:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728082419;
	bh=QccNV+QXaW4FGwd3UPTiuJUhlvzQKeTpXXSes7BPBKI=;
	h=Date:To:From:Subject:From;
	b=fzAyb6nsLQp9df+RfNI25DOOBrTd3l2aEayyJdWtKjs5pWrYInCVJNg4D5qsEK1AM
	 eWXVVHDs7y9PSqpnoAKRZDNa6JwhVBcgzSx1OS2MohLb4a9RJAfsPTEXi2mEEjbYbN
	 Y4TrTwcEKJKRDLc5MB9AnDwO0qiw1law7NFgePOA=
Date: Fri, 04 Oct 2024 15:53:38 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-uninitialized-variable.patch added to mm-hotfixes-unstable branch
Message-Id: <20241004225339.80AEEC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: fix uninitialized variable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fat-fix-uninitialized-variable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-uninitialized-variable.patch

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
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix uninitialized variable
Date: Fri, 04 Oct 2024 15:03:49 +0900

Link: https://lkml.kernel.org/r/87r08wjsnh.fsf@mail.parknet.co.jp
Link: https://lkml.kernel.org/r/66ff2c95.050a0220.49194.03e9.GAE@google.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/namei_vfat.c~fat-fix-uninitialized-variable
+++ a/fs/fat/namei_vfat.c
@@ -1037,7 +1037,7 @@ error_inode:
 	if (corrupt < 0) {
 		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+			     __func__, new_i_pos);
 	}
 	goto out;
 }
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fat-fix-uninitialized-variable.patch

