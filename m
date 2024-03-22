Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E325F87D
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127466; cv=none; b=tFGs5NAurWk++aOYreMOqHjm65StnzqUii/LS6kow30rQYUJoMCDtdSJbkotVgIXrL5LSK/ruMChyCIwOS3zLIM6ZiMwfO/rTbpYrNPg2EABcStiMjFtHkKI3JE5huEZBwhWmTJqoiPLTeKImj6hD0fi16Ovy6WlJl26d2qhwHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127466; c=relaxed/simple;
	bh=oT2f3WiIW1jv8cQ7QcchM9MADZOjOEOrf1Ksu1GnBWw=;
	h=Date:To:From:Subject:Message-Id; b=a+/RtADjapYeZyGVzW74GWIRht8qBqz55Dez7RZ+PuSR2T+x0MjE4HqgN2e/CQn/cCzR0rjUWSvUILHReGPW017PUsMvRaqk6W9dSFzeKWZepP7YQT9A+UPRY31gqoIVKaEHwQk5hs96j7i5m9VmDagxlw4mdQHr7ZcseKMI7PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MK8OvPyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MK8OvPyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22C7C433C7;
	Fri, 22 Mar 2024 17:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711127466;
	bh=oT2f3WiIW1jv8cQ7QcchM9MADZOjOEOrf1Ksu1GnBWw=;
	h=Date:To:From:Subject:From;
	b=MK8OvPyyAsFj5bo3+aQpwg4bSPH3VnVgnz3zjMrGMMgbPiQ/ZbnAEblaHXDWjSAir
	 NBoN8Nt88eIHNfg9LQp/OulXZovJV9aOflxtezQBV4uToY/dS7O+evqAFURUhbpPRj
	 xvj6LRvwBbvI5LzqJcQPrWFvI6zB/vuYPlXuhu7E=
Date: Fri, 22 Mar 2024 10:11:05 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-add-kernel-doc-comments-to-fat_parse_long.patch added to mm-nonmm-unstable branch
Message-Id: <20240322171105.E22C7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: add kernel-doc comments to fat_parse_long()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-add-kernel-doc-comments-to-fat_parse_long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-add-kernel-doc-comments-to-fat_parse_long.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: fs: add kernel-doc comments to fat_parse_long()
Date: Fri, 22 Mar 2024 15:37:24 +0800

Add kernel-doc style comments with complete parameter descriptions for
fat_parse_long().

Link: https://lkml.kernel.org/r/20240322073724.102332-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/dir.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/fat/dir.c~fs-add-kernel-doc-comments-to-fat_parse_long
+++ a/fs/fat/dir.c
@@ -269,6 +269,18 @@ enum { PARSE_INVALID = 1, PARSE_NOT_LONG
 /**
  * fat_parse_long - Parse extended directory entry.
  *
+ * @dir: Pointer to the inode that represents the directory.
+ * @pos: On input, contains the starting position to read from.
+ *       On output, updated with the new position.
+ * @bh: Pointer to the buffer head that may be used for reading directory
+ *	 entries. May be updated.
+ * @de: On input, points to the current directory entry.
+ *      On output, points to the next directory entry.
+ * @unicode: Pointer to a buffer where the parsed Unicode long filename will be
+ *	      stored.
+ * @nr_slots: Pointer to a variable that will store the number of longname
+ *	       slots found.
+ *
  * This function returns zero on success, negative value on error, or one of
  * the following:
  *
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

fs-add-kernel-doc-comments-to-fat_parse_long.patch

