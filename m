Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B05D1C84C9
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027948; cv=none; b=jQHz6DU2Cw05zN8qXQomsENgv/xeALS0gaM63zTW1NmanHt7uMrl3pJDRaDqlj3oZlqsUWvUAhEjCIaFSKyLyZ8PQf45DuelEeX2FnaZQk9htO/XTvBkjaoG9BHLOcj5NSU4pT165mgxTP/E11pZHsqMkk2RZ/1AP5aw4wGvccM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027948; c=relaxed/simple;
	bh=g0CgHIIBdJ+Z1NPHxPANbtNBSXz3h5jluPjzqGILib0=;
	h=Date:To:From:Subject:Message-Id; b=lPZoS4SNEQ40BGCqjzVEmDZDBQKdyjjFC2dhIlCpqy8GlEeSUrXaLHpBIgw+9quYDwSBHNtHycEXZNl3AYjrERjMe5zFfjct8ccnvu9VLyheJ1sgDXLJucajnLAV4//Vuk/4KyKqchzAF2+9BT+Ms62DZNWW/RXjQcYrq3V9Adw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhlv3p0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhlv3p0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3181CC4CEED;
	Wed,  9 Jul 2025 02:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027948;
	bh=g0CgHIIBdJ+Z1NPHxPANbtNBSXz3h5jluPjzqGILib0=;
	h=Date:To:From:Subject:From;
	b=xhlv3p0oLYzbvCKDpbcacuYfa5KZApPBFYUvDxwH3O/dwnFE7bU9QxO2sPCXh/PQ/
	 jXAnBr4EfbOxecG87UzNLEnq1QY9+UPAoSl5NZeiqP1F3LoB2PYXbbt9g0srNznbAA
	 kFNFR/1+7aMg/H7KUpxzb2M+2ZMDG9w2wdJB0+ZQ=
Date: Tue, 08 Jul 2025 19:25:47 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-replace-with-and-end-of-fi-declaration.patch added to mm-nonmm-unstable branch
Message-Id: <20250709022548.3181CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: replace ;; with ; and end of fi declaration
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-replace-with-and-end-of-fi-declaration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-replace-with-and-end-of-fi-declaration.patch

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
From: Colin Ian King <colin.i.king@gmail.com>
Subject: squashfs: replace ;; with ; and end of fi declaration
Date: Tue, 8 Jul 2025 12:49:00 +0100

There is an extraneous ; after a declaration, remove it.

Link: https://lkml.kernel.org/r/20250708114900.1883130-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-replace-with-and-end-of-fi-declaration
+++ a/fs/squashfs/block.c
@@ -83,7 +83,7 @@ static int squashfs_bio_read_cached(stru
 	struct folio *head_to_cache = NULL, *tail_to_cache = NULL;
 	struct block_device *bdev = fullbio->bi_bdev;
 	int start_idx = 0, end_idx = 0;
-	struct folio_iter fi;;
+	struct folio_iter fi;
 	struct bio *bio = NULL;
 	int idx = 0;
 	int err = 0;
_

Patches currently in -mm which might be from colin.i.king@gmail.com are

squashfs-replace-with-and-end-of-fi-declaration.patch

