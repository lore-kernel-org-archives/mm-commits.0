Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FECF8635D
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810110; cv=none; b=fepY0VwpFnRmPMCgbiP3xqZ4E4V6E+AnCrU9gQMwU9SQSqYe2YZe/ZzfOupOdhkWIrSMXAPdpp19a1ze4HIps15EVYsTtKWOgqaDsMhe+L0cuJTvUfD2CttOWu8d0L/2XcD7GBv8ZItIG+A+1AiS9z0sWlEbnTLFwtG91hVrKh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810110; c=relaxed/simple;
	bh=r/KeH4aw/S3juV9aSuF01mWx6kwfJ3HAXT5IvyA3mAE=;
	h=Date:To:From:Subject:Message-Id; b=reBc0DV6iMvoER3rzeh7lM/auadMKshCn+Vel6nohEkFN7DTmy1dm8+L0XkUhfxWviF1EQjvxcOCPtvkxbIIxQWN4S4wI7ghOL0oTL1Ov1NH273dvoWXm/Yo9ZTmPofhxP3icf6QTc6l7IMKT0iviTmWLciFip9JFVcKKSoCx4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPhJ5l8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPhJ5l8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FF4C4CEEB;
	Sun, 14 Sep 2025 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810109;
	bh=r/KeH4aw/S3juV9aSuF01mWx6kwfJ3HAXT5IvyA3mAE=;
	h=Date:To:From:Subject:From;
	b=pPhJ5l8cI52SEFO3wG8pWJ2EoEub0r1gZMsAx4Xrzu3RC1sVB9lbcBH7/2gJUMgaV
	 J6pIQ+Ij5RvGJRP+lZLqz6I/L+XoMJnGfZRfEWeQ2LT/ge576aSmYVuzZUMhF59tRw
	 3AEpfUyUNBrGnDvFYNPkHNoqVIBdjYrU2RRTclj8=
Date: Sat, 13 Sep 2025 17:35:09 -0700
To: mm-commits@vger.kernel.org,zhao.xichao@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-use-ptr_err_or_zero-to-simplify-code.patch removed from -mm tree
Message-Id: <20250914003509.D8FF4C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/fault-inject-usercopy.c: use PTR_ERR_OR_ZERO() to simplify code
has been removed from the -mm tree.  Its filename was
     lib-use-ptr_err_or_zero-to-simplify-code.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xichao Zhao <zhao.xichao@vivo.com>
Subject: lib/fault-inject-usercopy.c: use PTR_ERR_OR_ZERO() to simplify code
Date: Tue, 12 Aug 2025 16:40:45 +0800

Use the standard error pointer macro to shorten the code and simplify.

Link: https://lkml.kernel.org/r/20250812084045.64218-1-zhao.xichao@vivo.com
Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject-usercopy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/fault-inject-usercopy.c~lib-use-ptr_err_or_zero-to-simplify-code
+++ a/lib/fault-inject-usercopy.c
@@ -22,10 +22,8 @@ static int __init fail_usercopy_debugfs(
 
 	dir = fault_create_debugfs_attr("fail_usercopy", NULL,
 					&fail_usercopy.attr);
-	if (IS_ERR(dir))
-		return PTR_ERR(dir);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(dir);
 }
 
 late_initcall(fail_usercopy_debugfs);
_

Patches currently in -mm which might be from zhao.xichao@vivo.com are


