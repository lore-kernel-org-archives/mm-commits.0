Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC10717D2
	for <mm-commits@vger.kernel.org>; Thu, 11 Sep 2025 00:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757552317; cv=none; b=ZgMO9YjAtxbmqNWg6Uj91I7KeWR6EcYUQrcxg7jz7es2lwEDtAy1At79q8pvtRtppQF5P1afV2PeT3EfwMoyGFeuRjO3N/JeWXyrw2SsggghIlghxRIHNKd6HxdZLQ1wDDqTqAOmkNDHASzEXwzYtXOA2NhvL+SoDZ9yxr2tCMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757552317; c=relaxed/simple;
	bh=UUDoHG6f7JANbtX3WlW4omn82Vf7/iQrp63K4+df8vA=;
	h=Date:To:From:Subject:Message-Id; b=Q23CEHT1QAzGHcar4aOpSYZO9jwYNI3moPq7xTs3NJi3onzGdD9rwcevdoCeQLQVyur3jofgdrROahfMyCPLUVP9yFS5PQYX/7EktoepDhnODGaozD8WxcbWiwnwSjy780t7F4M7cffK3PPLL6PImeozByqTaHNkXmDetWV3l+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+G4IEvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+G4IEvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB0AC4CEEB;
	Thu, 11 Sep 2025 00:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757552317;
	bh=UUDoHG6f7JANbtX3WlW4omn82Vf7/iQrp63K4+df8vA=;
	h=Date:To:From:Subject:From;
	b=D+G4IEvGFcXXK/32VaK83+CuKuOgVm3+W3iAou4F0TdO0XK1pyHms/KhuM58EttvU
	 gbjlkkwRJLori5Txk+bvR84cf0b1ieMG20Bh1Jlu+V1i7GeWTTrhpfl3oH3/R+Ick2
	 pZ+henR7e58SQtciLyLtgiLb7K21KMhnV9MN8bv0=
Date: Wed, 10 Sep 2025 17:58:36 -0700
To: mm-commits@vger.kernel.org,terrelln@fb.com,dsterba@suse.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-decompress-use-designated-initializers-for-struct-compress_format.patch added to mm-nonmm-unstable branch
Message-Id: <20250911005837.4BB0AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/decompress: use designated initializers for struct compress_format
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-decompress-use-designated-initializers-for-struct-compress_format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-decompress-use-designated-initializers-for-struct-compress_format.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: lib/decompress: use designated initializers for struct compress_format
Date: Thu, 11 Sep 2025 01:23:51 +0200

Switch 'compressed_formats[]' to the more modern and flexible designated
initializers.  This improves readability and allows struct fields to be
reordered.  Also use a more concise sentinel marker.

Remove the curly braces around the for loop while we're at it.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250910232350.1308206-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: David Sterba <dsterba@suse.com>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/decompress.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/lib/decompress.c~lib-decompress-use-designated-initializers-for-struct-compress_format
+++ a/lib/decompress.c
@@ -49,15 +49,15 @@ struct compress_format {
 };
 
 static const struct compress_format compressed_formats[] __initconst = {
-	{ {0x1f, 0x8b}, "gzip", gunzip },
-	{ {0x1f, 0x9e}, "gzip", gunzip },
-	{ {0x42, 0x5a}, "bzip2", bunzip2 },
-	{ {0x5d, 0x00}, "lzma", unlzma },
-	{ {0xfd, 0x37}, "xz", unxz },
-	{ {0x89, 0x4c}, "lzo", unlzo },
-	{ {0x02, 0x21}, "lz4", unlz4 },
-	{ {0x28, 0xb5}, "zstd", unzstd },
-	{ {0, 0}, NULL, NULL }
+	{ .magic = {0x1f, 0x8b}, .name = "gzip", .decompressor = gunzip },
+	{ .magic = {0x1f, 0x9e}, .name = "gzip", .decompressor = gunzip },
+	{ .magic = {0x42, 0x5a}, .name = "bzip2", .decompressor = bunzip2 },
+	{ .magic = {0x5d, 0x00}, .name = "lzma", .decompressor = unlzma },
+	{ .magic = {0xfd, 0x37}, .name = "xz", .decompressor = unxz },
+	{ .magic = {0x89, 0x4c}, .name = "lzo", .decompressor = unlzo },
+	{ .magic = {0x02, 0x21}, .name = "lz4", .decompressor = unlz4 },
+	{ .magic = {0x28, 0xb5}, .name = "zstd", .decompressor = unzstd },
+	{ /* sentinel */ }
 };
 
 decompress_fn __init decompress_method(const unsigned char *inbuf, long len,
@@ -73,11 +73,10 @@ decompress_fn __init decompress_method(c
 
 	pr_debug("Compressed data magic: %#.2x %#.2x\n", inbuf[0], inbuf[1]);
 
-	for (cf = compressed_formats; cf->name; cf++) {
+	for (cf = compressed_formats; cf->name; cf++)
 		if (!memcmp(inbuf, cf->magic, 2))
 			break;
 
-	}
 	if (name)
 		*name = cf->name;
 	return cf->decompressor;
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

ocfs2-remove-commented-out-mlog-statements.patch
lib-decompress-use-designated-initializers-for-struct-compress_format.patch

