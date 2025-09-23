Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0CD23E25B
	for <mm-commits@vger.kernel.org>; Tue, 23 Sep 2025 03:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758597086; cv=none; b=eRO9CET85HZSsV25FtVxh+RWpCs2+/GrmDc38VJZvau37sWh6rM8kMx9Vt9/wX5QXlLhJjBvsaVOji41Kf/0IpsBOIxn+QZrLxvU/Oj7X65qsxTG6SUE5sMdT+4h04qUELFODzn4Xv/U9ZQNmwor9CRcAHgdxjnxNC/1L9ZCKUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758597086; c=relaxed/simple;
	bh=MofV+cchyz7bIumbaxUT7B+ujZraIdS1kBh8G9DcfkE=;
	h=Date:To:From:Subject:Message-Id; b=nu27RC9FN/UZoIocT1wUwTtxvFRhzBAmzjNc04QA+J7KpZDz3af49zZ/Yutn5DUoyWVu1GmOsngpeQQnemMb2QEs1JCldRLyWhJ6v4vluOVIjfNFafir8klukhquYgtXG8jlBJZI1nZc3rzEvydHWIyz/F4cIyFKCXU0ptJp984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P61tvBjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P61tvBjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F9AC16AAE;
	Tue, 23 Sep 2025 03:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758597086;
	bh=MofV+cchyz7bIumbaxUT7B+ujZraIdS1kBh8G9DcfkE=;
	h=Date:To:From:Subject:From;
	b=P61tvBjQ4xEwC1bm4WGiFrYISipTnxqvqhHkRQzvDg1qh9mmwX969301o+xg4PdWg
	 VbLc1ojO64VrZkufLNDu0O1JXotark3reRFdOdAWdQouldBW+TrVc3SQs2y5bicoIq
	 1uq9dkw2Y3FxKYLLS/qUY3IhWNuLsuSzdXDKK5ow=
Date: Mon, 22 Sep 2025 20:11:25 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,terrelln@fb.com,dsterba@suse.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-decompress-use-designated-initializers-for-struct-compress_format.patch removed from -mm tree
Message-Id: <20250923031126.17F9AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/decompress: use designated initializers for struct compress_format
has been removed from the -mm tree.  Its filename was
     lib-decompress-use-designated-initializers-for-struct-compress_format.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
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


