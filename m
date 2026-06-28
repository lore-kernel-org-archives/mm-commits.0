Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E70C15746F
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 20:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782678486; cv=none; b=H7VRGjV+0svMBix3YtrzX4LKP+VU6IUvjEMC7YJWtGEyvd4sE0VOUfnk2pliiMdTTuifNgtAqnOEi2kvIM6Gqugx6JQMRnz7uXZSnidvPiUdk3ccHTVni9QKxx1xFXR8yMvSYhlDbtsl4XTIpTL6sXsmJYmSg6qDcAuaDZtT3zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782678486; c=relaxed/simple;
	bh=8PrhCwJywLn0zuh290k8/ydGK25nHrsV7TCxH2emw8M=;
	h=Date:To:From:Subject:Message-Id; b=YgH/Or+7AdAVU5oBKH2r9VQTwUrtA9EpNYjlFN62+UVu7dQ8I9IW/QLlmOiX6qkWgdW9oGyBhuiQMLdHQO5M+I0nJ4TgzwedEHbUmAVdYL8aDBHsh2fo1ChEl4XIuWvX8XofZZ/+Loupxi82rBmIjqCcjPvd09Q7foRYi9eCxzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NASqcDjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NASqcDjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B6C1F000E9;
	Sun, 28 Jun 2026 20:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782678484;
	bh=NNYtgqVegazJbIgCpHyZWukOnpvX5W5vz0jNePOfrO0=;
	h=Date:To:From:Subject;
	b=NASqcDjUK8UfSZRP45P1SXPS0sS3L7BQxPxfw2e6p7HobEgmmCddzBZJ5oVaefLke
	 aYob0vfh7hLqQDiNkTlMtkH+mQTwZG33etU/jjFuMgb2R7PDabmmlpdsYB6Mm6nuCH
	 j6DD5ZC+cK5nqgAAHFzZEKJqrZVbe1l7sfKuNZjE=
Date: Sun, 28 Jun 2026 13:28:04 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@kernel.org,n05ec@lzu.edu.cn,hirofumi@mail.parknet.co.jp,brauner@kernel.org,bird@lzu.edu.cn,prcups@krgm.moe,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-restore-original-value-when-fat_ent_write-failed.patch added to mm-nonmm-unstable branch
Message-Id: <20260628202804.A4B6C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: restore original value when fat_ent_write failed
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-restore-original-value-when-fat_ent_write-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-restore-original-value-when-fat_ent_write-failed.patch

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
From: Yemu Lu <prcups@krgm.moe>
Subject: fat: restore original value when fat_ent_write failed
Date: Mon, 25 May 2026 16:56:49 +0800

fat_ent_write() may have committed the new link to the primary FAT but
then failed on the mirror copy, leaving the chain pointing to new_dclus
even though the caller will free it.  Restore the original value to keep
the chain consistent.

Link: https://lore.kernel.org/20260525085649.781643-1-n05ec@lzu.edu.cn
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yemu Lu <prcups@krgm.moe>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/fat/misc.c~fat-restore-original-value-when-fat_ent_write-failed
+++ a/fs/fat/misc.c
@@ -133,7 +133,11 @@ int fat_chain_add(struct inode *inode, i
 		ret = fat_ent_read(inode, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
+			int old = ret;
+
 			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
+			if (ret < 0)
+				fat_ent_write(inode, &fatent, old, wait);
 			fatent_brelse(&fatent);
 		}
 		if (ret < 0)
_

Patches currently in -mm which might be from prcups@krgm.moe are

fat-restore-original-value-when-fat_ent_write-failed.patch

