Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB9372EF6
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028834; cv=none; b=Y35s7lGiDIgbrSQ2xjXsiDUt0MEdhxSxALEoIEEjwScdeeeXnIY8RJ8cafczNVZKVKeHul6Qym0PXxVfJ42XEsFtSYwvImnkUIRZQIRHcyLslD46AZxQ4Hvda0mp4vopAKXE7JKC6q5MIUWtoBeiaD90wv2brIIN/XgcdxS+AQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028834; c=relaxed/simple;
	bh=14wX49yPwLu4+gY3Xiw84EM1a2WzRt/MMDpmILE9n3o=;
	h=Date:To:From:Subject:Message-Id; b=M3YzjJuUbnvv205Ryx1v+Bv0t8gc1g5CccQKitwGRPFGVs3f0x17WhqfKRK+xUrgTo0VsEbu0CxHS5mGQsmyvxlokFSX7RrtOoces4QT73BBzIYeCPmm+qc0rirFTHIctGdcB5sXbvej422Ccj2AGdr7TCBtke920bQHU1bBku8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHw4NIT8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHw4NIT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82291F00898;
	Fri, 29 May 2026 04:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028832;
	bh=RyQ7vGhwzjBW7W28sg4t56x9jZgMa+08XsBOvWCr0KA=;
	h=Date:To:From:Subject;
	b=wHw4NIT8bruOsktQhUBV/mXqkCdjB7KxOehPp8bO4+we7a4mMJn/QFxdmdXeFdTsK
	 3N/v521m+gCTzjug98urmtNz3gIDkpMYZ8qhMqRoOyeFtSlssOyDAwWB+H51/nfSiZ
	 Cct8IvqMhXlmITe1vqvrRFyfXr86Kno/bDX0bFXc=
Date: Thu, 28 May 2026 21:27:12 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,ingyujang25@korea.ac.kr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] error-inject-use-is_err-check-for-debugfs_create_file.patch removed from -mm tree
Message-Id: <20260529042712.B82291F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: error-inject: use IS_ERR() check for debugfs_create_file()
has been removed from the -mm tree.  Its filename was
     error-inject-use-is_err-check-for-debugfs_create_file.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ingyu Jang <ingyujang25@korea.ac.kr>
Subject: error-inject: use IS_ERR() check for debugfs_create_file()
Date: Fri, 15 May 2026 04:32:14 +0900

debugfs_create_file() returns an error pointer on failure, never NULL, so
the !file check in ei_debugfs_init() never triggers and the
debugfs_remove() cleanup cannot run.

Use IS_ERR() and propagate the actual error via PTR_ERR().

Link: https://lore.kernel.org/20260514193214.2432769-1-ingyujang25@korea.ac.kr
Signed-off-by: Ingyu Jang <ingyujang25@korea.ac.kr>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/error-inject.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/error-inject.c~error-inject-use-is_err-check-for-debugfs_create_file
+++ a/lib/error-inject.c
@@ -219,9 +219,9 @@ static int __init ei_debugfs_init(void)
 	dir = debugfs_create_dir("error_injection", NULL);
 
 	file = debugfs_create_file("list", 0444, dir, NULL, &ei_fops);
-	if (!file) {
+	if (IS_ERR(file)) {
 		debugfs_remove(dir);
-		return -ENOMEM;
+		return PTR_ERR(file);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from ingyujang25@korea.ac.kr are


