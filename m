Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C7F179AD;
	Wed, 17 Jul 2024 20:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721246814; cv=none; b=U6MZOtd9bSxcbj8P3uvnOZGqc76XmcAsSyw+zlC830AFQKMNF9TsRKTiAuWgYcSgeAn9Piph7lh+i0jt7/sdXV5DhJCSjPAn4So/kzVK0y0WNrYQodw2k5ehWrNQGOnv4jedDrgG570CssuH94eNSLE+mjBXQ+ZYP05hqFwXCg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721246814; c=relaxed/simple;
	bh=uokmSFYVIrurhLroGwuLI4rQ+GbBhi2O9z7v4+kw31Y=;
	h=Date:To:From:Subject:Message-Id; b=TUj1g+fAAsynd4WyHMWrWxs9I9vx5JQEQ0DiAHjIgr7APjpZjq3YmgW7V8qa0Uaz5R90QwU73yREJS6Tuod0aVt3uoUs9RVvPJfPcQ3/KB55iu4SK/qWlKEeLJ+6gNAb12N3hzRviRk1cR6RBkr2CJFu0SNhdlHCT3EfLKmdmmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=geZIYHlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="geZIYHlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FC3C2BD10;
	Wed, 17 Jul 2024 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721246813;
	bh=uokmSFYVIrurhLroGwuLI4rQ+GbBhi2O9z7v4+kw31Y=;
	h=Date:To:From:Subject:From;
	b=geZIYHlZgv+HCKaBdsckrqIVL1fC+ZTJxyj8MrfE9L5j19HodUWj9+vVcVEza57T0
	 agozjOkO+tlnDSi50DuRPotyI17wgX7dyGAkDnRynngwSndfNnBOgxbZ3aWpunXSHO
	 CSh/WV2k8WAfpYqmMff+i8uOO3DnghGoyY0DDLAE=
Date: Wed, 17 Jul 2024 13:06:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hpa@zytor.com,alain@knaff.lu,ross.lagerwall@citrix.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + decompress_bunzip2-fix-rare-decompression-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20240717200653.C0FC3C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: decompress_bunzip2: fix rare decompression failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     decompress_bunzip2-fix-rare-decompression-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/decompress_bunzip2-fix-rare-decompression-failure.patch

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
From: Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: decompress_bunzip2: fix rare decompression failure
Date: Wed, 17 Jul 2024 17:20:16 +0100

The decompression code parses a huffman tree and counts the number of
symbols for a given bit length.  In rare cases, there may be >= 256
symbols with a given bit length, causing the unsigned char to overflow. 
This causes a decompression failure later when the code tries and fails to
find the bit length for a given symbol.

Since the maximum number of symbols is 258, use unsigned short instead.

Link: https://lkml.kernel.org/r/20240717162016.1514077-1-ross.lagerwall@citrix.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress_bunzip2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c~decompress_bunzip2-fix-rare-decompression-failure
+++ a/lib/decompress_bunzip2.c
@@ -232,7 +232,8 @@ static int INIT get_next_block(struct bu
 	   RUNB) */
 	symCount = symTotal+2;
 	for (j = 0; j < groupCount; j++) {
-		unsigned char length[MAX_SYMBOLS], temp[MAX_HUFCODE_BITS+1];
+		unsigned char length[MAX_SYMBOLS];
+		unsigned short temp[MAX_HUFCODE_BITS+1];
 		int	minLen,	maxLen, pp;
 		/* Read Huffman code lengths for each symbol.  They're
 		   stored in a way similar to mtf; record a starting
_

Patches currently in -mm which might be from ross.lagerwall@citrix.com are

decompress_bunzip2-fix-rare-decompression-failure.patch

