Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BAE423EA9;
	Tue,  4 Aug 2026 04:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816297; cv=none; b=Zajdd+QPFf2L2uHJD8Fpo6N86ycgvS4Vo3POMPsxed041lMehGEx0dLM5PSH/GsR7aBGVkwqOw7ZVUS2BvHO8Qi/aVM2T8sjjxcHJdM5L4OBYONV7mcQHkRMIsx2xJyN7M9fRseIpbS+nPvgtKKmk4OGJNQl+U+uIYtiqyZsZvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816297; c=relaxed/simple;
	bh=pwBpiNMuWQxI/eWemAKcpTcjkR80y1IMFdLTcI52SxM=;
	h=Date:To:From:Subject:Message-Id; b=PX74tmNgXRkGymSH7ixTIcK90cxCUt80f6931O+/6kcS8tftqCRalLIpbXa/1MBb09O6Us8GC1HydvLpP1JdXjBECPt4eEy+9nyVWYCwuAGFehA2RRBTc6+htIbs4hxvH+MGwQRSbqIIW3ArdTLOXrddX13/4gTZlGB86GCQLzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HydUs4Zg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HydUs4Zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E031F000E9;
	Tue,  4 Aug 2026 04:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816295;
	bh=vmn2a3cQG98FQltQELTIgZZpy9BuvwnPFlARKLK7+oE=;
	h=Date:To:From:Subject;
	b=HydUs4ZgYtNZpmfmvoJTBnIwLYb70Tw3mU3g9oWWEAFvaEQ5QD7P9JGYQaB8/V+HL
	 Y+Riwdext/WXGXohqXHOxyVszZRr592aBzvY9NE/pf+0EKuv8Qjmw1vdwuitV8wypF
	 keo7mjmLelIIt6CZuzRMhQ5MO0veb4CBy1ciyHxc=
Date: Mon, 03 Aug 2026 21:04:55 -0700
To: mm-commits@vger.kernel.org,yuantan098@gmail.com,yifanwucs@gmail.com,tomapufckgml@gmail.com,stable@vger.kernel.org,n05ec@lzu.edu.cn,hirofumi@mail.parknet.co.jp,brauner@kernel.org,bird@lzu.edu.cn,prcups@krgm.moe,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-restore-original-value-when-fat_ent_write-failed.patch removed from -mm tree
Message-Id: <20260804040455.93E031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: restore original value when fat_ent_write failed
has been removed from the -mm tree.  Its filename was
     fat-restore-original-value-when-fat_ent_write-failed.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: <stable@vger.kernel.org>
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


