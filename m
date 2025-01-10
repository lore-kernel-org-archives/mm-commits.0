Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1737514286
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 00:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736467254; cv=none; b=u8Hn8TQjh8GrCr6K2JpesR46IXlZ2plthEEs4Zn7Vhynilao5MRtbrZ5009oRqWfg7Yw+3DUtm6UmrVqvCkzvAiaiu3+//SWMfcZFMBIYhN7z5fM2F1AuceWzI3dZY42KHSOlC7irRtrAutVCw8NjVvO7Tw8E59rznx2F+jjoBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736467254; c=relaxed/simple;
	bh=eWvlFz+/p5sSWYEKcrV4BYOmYlsMR/676ujOfaO7Bc0=;
	h=Date:To:From:Subject:Message-Id; b=tUvvVcXaavD3ZmBfBFAXYbsExTFB+vHpvm2b+unllIdTiqDRvtx66rqW79AglRLdOYLHUYB4BqcjiQfsq0PSdgumBPC0lrgyuVyXv+p2pWwNrh2TiuYYrC+2U2EHgd7jotdTn5TOkyGDBOtKMDxEA8eEDqaWVkn5fYUaAiyDT40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kkz2dRkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kkz2dRkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654EC4CED2;
	Fri, 10 Jan 2025 00:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736467253;
	bh=eWvlFz+/p5sSWYEKcrV4BYOmYlsMR/676ujOfaO7Bc0=;
	h=Date:To:From:Subject:From;
	b=kkz2dRkL+4ZtRCZa8m/aM3VC9oEUYX8nvJv3rQmNAqqRYs/UQilT9t96Y/2BdBNLa
	 vjjfn1Cam7j+mny4pXONahlTVGWbCl7Dpqyor1Vc7UauiRCByNugmVvr1eY/Amxs/l
	 llvwuUDjWv2gC6BUhr1bcCJZV+yUoFcfMmY/wp/0=
Date: Thu, 09 Jan 2025 16:00:52 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jstultz@google.com,jeffxu@chromium.org,axelrasmussen@google.com,aliceryhl@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch added to mm-unstable branch
Message-Id: <20250110000053.9654EC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: use strncpy_from_user() to read memfd name
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

This patch will later appear in the mm-unstable branch at
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
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/memfd: use strncpy_from_user() to read memfd name
Date: Thu, 9 Jan 2025 10:59:05 -0800

The existing logic uses strnlen_user() to calculate the length of the
memfd name from userspace and then copies the string into a buffer using
copy_from_user().  This is error-prone, as the string length could have
changed between the time when it was calculated and when the string was
copied.  The existing logic handles this by ensuring that the last byte in
the buffer is the terminating zero.

This handling is contrived and can better be handled by using
strncpy_from_user(), which gets the length of the string and copies it in
one shot.  Therefore, simplify the logic for copying the memfd name by
using strncpy_from_user().

No functional change.

Link: https://lkml.kernel.org/r/20250109185908.1006310-3-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: John Stultz <jstultz@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/mm/memfd.c~mm-memfd-use-strncpy_from_user-to-read-memfd-name
+++ a/mm/memfd.c
@@ -396,26 +396,18 @@ static char *alloc_name(const char __use
 	char *name;
 	long len;
 
-	/* length includes terminating zero */
-	len = strnlen_user(uname, MFD_NAME_MAX_LEN + 1);
-	if (len <= 0)
-		return ERR_PTR(-EFAULT);
-	if (len > MFD_NAME_MAX_LEN + 1)
-		return ERR_PTR(-EINVAL);
-
-	name = kmalloc(len + MFD_NAME_PREFIX_LEN, GFP_KERNEL);
+	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
 		return ERR_PTR(-ENOMEM);
 
 	strcpy(name, MFD_NAME_PREFIX);
-	if (copy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, len)) {
+	/* returned length does not include terminating zero */
+	len = strncpy_from_user(&name[MFD_NAME_PREFIX_LEN], uname, MFD_NAME_MAX_LEN + 1);
+	if (len < 0) {
 		error = -EFAULT;
 		goto err_name;
-	}
-
-	/* terminating-zero may have changed after strnlen_user() returned */
-	if (name[len + MFD_NAME_PREFIX_LEN - 1]) {
-		error = -EFAULT;
+	} else if (len > MFD_NAME_MAX_LEN) {
+		error = -EINVAL;
 		goto err_name;
 	}
 
_

Patches currently in -mm which might be from isaacmanjarres@google.com are

mm-memfd-refactor-and-cleanup-the-logic-in-memfd_create.patch
mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

