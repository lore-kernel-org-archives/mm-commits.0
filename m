Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844193597B
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 01:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739236373; cv=none; b=hdKZAxxMWhPeQncUPeFGlg9toBVSE/7KvKtyX6Q6jXlRTxLv4CSKtmWqqWakbd14KL4aOPdn7m+2xSR9tT4AcF3rQiOVcJW5ADxJ/JnVKs0kpoY5zQaQQ025rzN18Yb6DLDUMx17ygvodmSD6JruekfIguzWP/g6WjX42oBGS2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739236373; c=relaxed/simple;
	bh=bFjcdtMJNgXgRlv2ZhQ7h3inYXhwuO36K9o/TfXpivk=;
	h=Date:To:From:Subject:Message-Id; b=NtKrnCiC6I2SiOfxjvLpsz9nNDxxoSIdp1gmx25MnnOluD5c95NJJBqoAY9tpz1bR8Q9HEhqy96LyQ/PAGzvEGzsTBkVkJxTJxjlTtdNsLbIUf3bMWpHRVufsdEDRCDBx0hYjm0oPO+/gHdA9y2x0SXVKTYAMXhyj3OfB/8NOdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfw0jShv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfw0jShv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0AAC4CED1;
	Tue, 11 Feb 2025 01:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739236373;
	bh=bFjcdtMJNgXgRlv2ZhQ7h3inYXhwuO36K9o/TfXpivk=;
	h=Date:To:From:Subject:From;
	b=rfw0jShv58ZyRWbY3+hI3kiIFFUF6HwkEhncCKrd79Yh75mSTQpeBhyCGLiF6KOqn
	 hiofamT8SIADxoxcabZSXnaTYRYYIQNfZjm1XlPQ9+bo85hECH/kpiXXzLzJ4SEI+Q
	 g42mQgEzejchizGjUZylZiOI0b/t34m5by5T3Vuc=
Date: Mon, 10 Feb 2025 17:12:52 -0800
To: mm-commits@vger.kernel.org,howlett@gmail.com,richard120310@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-correct-comment-for-mas_start.patch added to mm-unstable branch
Message-Id: <20250211011252.EC0AAC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: correct comment for mas_start()
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-correct-comment-for-mas_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-correct-comment-for-mas_start.patch

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
From: I Hsin Cheng <richard120310@gmail.com>
Subject: maple_tree: correct comment for mas_start()
Date: Mon, 10 Feb 2025 02:10:23 +0800

There's no mas->status of "mas_start", what the function is checking is
whether mas->status equals to "ma_start".  Correct the comment for the
function.

Link: https://lkml.kernel.org/r/20250209181023.228856-1-richard120310@gmail.com
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Liam R. Howlett <howlett@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-correct-comment-for-mas_start
+++ a/lib/maple_tree.c
@@ -1353,7 +1353,7 @@ static void mas_node_count(struct ma_sta
  * mas_start() - Sets up maple state for operations.
  * @mas: The maple state.
  *
- * If mas->status == mas_start, then set the min, max and depth to
+ * If mas->status == ma_start, then set the min, max and depth to
  * defaults.
  *
  * Return:
_

Patches currently in -mm which might be from richard120310@gmail.com are

maple_tree-correct-comment-for-mas_start.patch
lib-plistc-add-shortcut-for-plist_requeue.patch

