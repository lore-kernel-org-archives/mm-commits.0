Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1435614883F
	for <mm-commits@vger.kernel.org>; Thu,  4 Jun 2026 19:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600348; cv=none; b=mUfNDNnSb2tMzRfSu7zPaEEld0x6c+CTD1ipbYzaSN/wK2Zsrb0VWQqCGJOnfrflEgRRcYe0opEtdTFkIxTspTrq6CT+AxBGV2baMqQOg+RVB6YMSeS3+D9H4Eux+WF7ARVypxvU3d+qfNSW6otIhjcCC0mohTqaqoCCJA4j+wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600348; c=relaxed/simple;
	bh=qzqmsFpX4/UGCPKxeD/z990MCrk5cLvvCnzkGz3qI1o=;
	h=Date:To:From:Subject:Message-Id; b=bD/33+9qCOjaP/VRi9BStqk91Alrx1TJdB50jOqp/kAnrASa/e3/OslVP8ATLHQ66D0VSssaKSI5FJVbYTiyE6h4vZbxPkWIP6JESdTBCsZrGidJ/Z3Vgsf5LZmwhqbkFUQuHOiQF3bMl1ZAlpb+L61DT0CkAWNnwiv6iRj3ew0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sp7frYve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sp7frYve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8659F1F00893;
	Thu,  4 Jun 2026 19:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780600346;
	bh=tcIHwHG2YBKQWCQ8g5/tE8bej46uEf2Jj0BSEal/FO4=;
	h=Date:To:From:Subject;
	b=Sp7frYve3Bzs42KAJPCbMEj41w/KhYtyCeRmObux6M/Wt3zFaHHgoxTvjxWkH7Wsi
	 LZAVDOg5xnG7qGE7yczuC9Gy8dKphPUd+e9Wu6F25ZoC1A5z3fe7MfwSy5sxMoGKRX
	 ZSyvCSuIFbs4Hanciz+jKyrzG0BzQB+pBYxVsoIQ=
Date: Thu, 04 Jun 2026 12:12:26 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,m32285159@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-fat-inode-replace-sprintf-with-scnprintf.patch added to mm-nonmm-unstable branch
Message-Id: <20260604191226.8659F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: fat: inode: replace sprintf() with scnprintf()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-fat-inode-replace-sprintf-with-scnprintf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-fat-inode-replace-sprintf-with-scnprintf.patch

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
From: Maxwell Doose <m32285159@gmail.com>
Subject: fs: fat: inode: replace sprintf() with scnprintf()
Date: Wed, 3 Jun 2026 09:52:21 -0500

The kernel documentation notes that sprintf() is deprecated and unsafe. 
Replace it with the more preferred scnprintf() to help with hardening.

Link: https://lore.kernel.org/20260603145222.59012-1-m32285159@gmail.com
Signed-off-by: Maxwell Doose <m32285159@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fat/inode.c~fs-fat-inode-replace-sprintf-with-scnprintf
+++ a/fs/fat/inode.c
@@ -1786,7 +1786,7 @@ int fat_fill_super(struct super_block *s
 	 */
 
 	error = -EINVAL;
-	sprintf(buf, "cp%d", sbi->options.codepage);
+	scnprintf(buf, sizeof(buf), "cp%d", sbi->options.codepage);
 	sbi->nls_disk = load_nls(buf);
 	if (!sbi->nls_disk) {
 		fat_msg(sb, KERN_ERR, "codepage %s not found", buf);
_

Patches currently in -mm which might be from m32285159@gmail.com are

fs-fat-inode-replace-sprintf-with-scnprintf.patch

