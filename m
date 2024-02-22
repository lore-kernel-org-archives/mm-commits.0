Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528A517BC1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645180; cv=none; b=Xg44B4dS8GG6nnS7vEQWvtVDDGc84A7IWcTdcWxusebypt232SwkBUMI9WO0EEw/tXxbxxTCC5SmhJSXwbKmfNMxx3eUA7YQw9hBsHmpkwmaELMTshCCWepT8NsBZbJiUOKgrxMfT2oALwEQxA4YpsLfBcFhTokeOQr4XJ7MwV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645180; c=relaxed/simple;
	bh=/71HAVI9LJfdT7x0fXqf5vPcMybTxgSsxd3IC6AnD3Q=;
	h=Date:To:From:Subject:Message-Id; b=s2b0LS/VJ/d86BdPf0Pzmbj2pclRMC2FBXttM1j1manknTgmype06YM2+u9RbBxHLt5EspzUiOeiDz3CxMlU3rnhVM4kebDm0cYKc1tEUinUF+QfM4/rh8rS126UOqa96lIehgfTQ7ifxP1RILwivjM33fmTC+y8VcHBxdvje0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WiG45nrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WiG45nrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC76C433C7;
	Thu, 22 Feb 2024 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645179;
	bh=/71HAVI9LJfdT7x0fXqf5vPcMybTxgSsxd3IC6AnD3Q=;
	h=Date:To:From:Subject:From;
	b=WiG45nrI0tccznLvmomF6BaCxnJf5LKicd2y8U5d9ulpRALtnRFa6nLyM7j1ItIv4
	 U/b3+19Gf4r9SHHNKjiWxVM0W9CJ6Ri0gD1e2nB0dKRAfrsilFWSEfirQxwg9jVBTA
	 FjxH3uzP9QCyz9tVzMuo+me1hx6hfBc87VAa2YQQ=
Date: Thu, 22 Feb 2024 15:39:39 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,zeming@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] user_namespace-remove-unnecessary-null-values-from-kbuf.patch removed from -mm tree
Message-Id: <20240222233939.BDC76C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: user_namespace: remove unnecessary NULL values from kbuf
has been removed from the -mm tree.  Its filename was
     user_namespace-remove-unnecessary-null-values-from-kbuf.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: user_namespace: remove unnecessary NULL values from kbuf
Date: Mon, 15 Jan 2024 14:25:19 +0800

kbuf is assigned first, so it does not need to initialize the assignment.

Link: https://lkml.kernel.org/r/20240115062519.31298-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user_namespace.c~user_namespace-remove-unnecessary-null-values-from-kbuf
+++ a/kernel/user_namespace.c
@@ -931,7 +931,7 @@ static ssize_t map_write(struct file *fi
 	struct uid_gid_map new_map;
 	unsigned idx;
 	struct uid_gid_extent extent;
-	char *kbuf = NULL, *pos, *next_line;
+	char *kbuf, *pos, *next_line;
 	ssize_t ret;
 
 	/* Only allow < page size writes at the beginning of the file */
_

Patches currently in -mm which might be from zeming@nfschina.com are


