Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F941925B2;
	Thu, 17 Oct 2024 07:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150117; cv=none; b=Lum2HfisDYtcXp/EAZ3BDMPsU8OePCZgQ2y8bLRaeZt2qTb8SaldfAqSyPHh48q5eftvxeibDQt1AJ9LKMu4ijSw6Zp0KCc8CuVHA0I6v67jVJP4SP5wqVk6zYkwnV/sJwWqetpKNeI5t5kt8EmWfqbw86v/P5oyaalPvBxX+sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150117; c=relaxed/simple;
	bh=o8+T4F58CdKwTJL09OXYNcOGv0HeBaaF2fe3UnlWZns=;
	h=Date:To:From:Subject:Message-Id; b=o8ihhGdflbEkko7Oe+cd83AHHArBbzKqE+vuvbPFCHSTgIwCTpsEyJHB5d5EQVS2dD1/epbhiYyhTOr/smuSmlSejilEsC+nUqUV9Ld7oldeubDl9ckAPuuMXh2miGxHkFhy6TBmXo1KCAU6Qq08Bg9hov5gc2L4iI66+YUCJhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uEBL+IIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uEBL+IIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5A8C4CEC3;
	Thu, 17 Oct 2024 07:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150117;
	bh=o8+T4F58CdKwTJL09OXYNcOGv0HeBaaF2fe3UnlWZns=;
	h=Date:To:From:Subject:From;
	b=uEBL+IIQdCOhzg/eZeRe257TJ9R6kciYR0BpqL3/xFtjcsNlQunU/jLkC46RfVEp3
	 taMPt4+Wv50Z/+Ob+cWJotAhuaKSZvSFAIrAzYR+tMvsWC68kT5uQ0G9CC84JVaR6S
	 qgMNPI+mgEgZgmljSeARsuOWQE1Gtg5JKUyGsHFY=
Date: Thu, 17 Oct 2024 00:28:36 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hirofumi@mail.parknet.co.jp,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fat-fix-uninitialized-variable.patch removed from -mm tree
Message-Id: <20241017072837.2C5A8C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: fix uninitialized variable
has been removed from the -mm tree.  Its filename was
     fat-fix-uninitialized-variable.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix uninitialized variable
Date: Fri, 04 Oct 2024 15:03:49 +0900

syszbot produced this with a corrupted fs image.  In theory, however an IO
error would trigger this also.

This affects just an error report, so should not be a serious error.

Link: https://lkml.kernel.org/r/87r08wjsnh.fsf@mail.parknet.co.jp
Link: https://lkml.kernel.org/r/66ff2c95.050a0220.49194.03e9.GAE@google.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: syzbot+ef0d7bc412553291aa86@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
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


