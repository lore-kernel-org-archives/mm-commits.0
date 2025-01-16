Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA7188A0D
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006294; cv=none; b=MDQhNS8m5ybMuqxXgzuddQFvITeb89rT8Lq8snz9ak45+lsO5spz7/WLMnrMr1VDqkXb1KpxNzLs0T1bKfMuBL25JzI0iobf2lPqeJLXa1FYT3eBprqKQGfMrP5+KcosEBL+sawRJDnoGJIlRoBjKh3WkYQSTfdTVFRmXEJ99nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006294; c=relaxed/simple;
	bh=ThnR6ciAwqh2mqs4xM/CMYNluraphhzWYAr+Lk5jpco=;
	h=Date:To:From:Subject:Message-Id; b=GBn1zWb/IFc/W64hx1EviHOTii3iwcq/Lbm/4+j/mlmBDh3MtV9/Gnj3T/6ytoyA9sRtG+M1v6h+xgiruZpXLYp9Rk2ae/igfwqyoxNza6NnE3Otga3xTCR9GYuSUYZhSOAECLGvuUmt96tfIHHrQC1BJ8oXxfrb28GHjF0NMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JyhSlWGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JyhSlWGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B358C4CED6;
	Thu, 16 Jan 2025 05:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006294;
	bh=ThnR6ciAwqh2mqs4xM/CMYNluraphhzWYAr+Lk5jpco=;
	h=Date:To:From:Subject:From;
	b=JyhSlWGqkUUf62rAZbfaBvTC5pSVHFW673YgvycWixcZfXf4je6xTjNMJyfgLU/l/
	 V2zKWYXMLiVMYB+vXys0yEnpegq3+JLNuWu8pnv9AXuR3yQCblXSzRBImafN20bHxQ
	 xsL+1ePHJ/vw8z5aQh1HlvGuLaK+WmBaOW4gLeXs=
Date: Wed, 15 Jan 2025 21:44:53 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,lorenzo.stoakes@oracle.com,kaleshsingh@google.com,jstultz@google.com,aliceryhl@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch removed from -mm tree
Message-Id: <20250116054454.2B358C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd: use strncpy_from_user() to read memfd name
has been removed from the -mm tree.  Its filename was
     mm-memfd-use-strncpy_from_user-to-read-memfd-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: mm/memfd: use strncpy_from_user() to read memfd name
Date: Fri, 10 Jan 2025 08:59:00 -0800

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

Link: https://lkml.kernel.org/r/20250110165904.3437374-3-isaacmanjarres@google.com
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: John Stultz <jstultz@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
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


