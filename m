Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBCB80C14
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104460; cv=none; b=fP6w34UJirBScaZWBZHn7kxPKHKxDIBiBtl+rqm+DKbVloVF7EFBkdrTesisWEKitLTL3GPvq58PF7IQYw/oApDlRw/qqsfnvM5cfnX6BVTZoreiAVrAqfu2HLVeHIL8ApqESFLlY+R3OD32kQIRGBdaQwv2NCHGfpfyITThD78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104460; c=relaxed/simple;
	bh=n/bBb4f49j2ncCP4nmKVxAEnCnQbWfqQNJa02E6NLSM=;
	h=Date:To:From:Subject:Message-Id; b=ZghUfv76WHy/fnAzKEUingYMBkH32Lz0uuTcwO4u80AsDM2gVvh5WIBv7aGLunOXjzF3WAXHQXl7VC0A/e4BDScGVQwsMXnPwIoak6fwKzcGonzNtNQntoLKAA0ec+S9c56JJKyuAAFj2JkT3GJLNx2SFBdIP6b9MaP43oji3Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o4UgpYYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o4UgpYYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC66C113CD;
	Fri, 26 Apr 2024 04:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104460;
	bh=n/bBb4f49j2ncCP4nmKVxAEnCnQbWfqQNJa02E6NLSM=;
	h=Date:To:From:Subject:From;
	b=o4UgpYYbWF2+5FkPVf5TPCDQFABKeBuYdU8t7S6xxgr3KkhZLj0oUpfc6cHLmx5rX
	 1btRgfieVcUHUOA3600D1j+cLEcTSwgZBQ70Kg0kcOSXRl9W0tIqdUn4hoEspJadBX
	 kQ2a1V5R43ISpPYk/0zRSlZGp8uHAt3QOuuI1nDY=
Date: Thu, 25 Apr 2024 21:07:39 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-add-kernel-doc-comments-to-fat_parse_long.patch removed from -mm tree
Message-Id: <20240426040739.DCC66C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs: add kernel-doc comments to fat_parse_long()
has been removed from the -mm tree.  Its filename was
     fs-add-kernel-doc-comments-to-fat_parse_long.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


