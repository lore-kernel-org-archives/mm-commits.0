Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DFB271801
	for <mm-commits@vger.kernel.org>; Tue, 11 Feb 2025 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739318151; cv=none; b=uXfHIjwSCPg1ZJEnm+Zj4BqvvOStiv44rxhp4EAHezbd7zf6dyqgDlAdvw+ky/IMF8UueADyYNoJt33y6L/xL2VzHeQuphy5UKMNyWZPxP04P9jXBDay0fjVs7+8WhH0vZN6fMBWgam5EUiBVQckm/ZZE3opnnk9VGnyVEAXi5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739318151; c=relaxed/simple;
	bh=pxXrxTlhk9CnVwbrqNRApZAuBiwNoCPv587pKua63Pw=;
	h=Date:To:From:Subject:Message-Id; b=Ka667PqNYRWVlt6HjEcGfxAksAKLi6Hb6M3/XO2E/qh8cnIwVajUg1FaDNS0BU4l4187xryKEzY5RJDd4gGm2VLJcIP1PW9iKkwe2hRzgGM4NpoNqOjEGTNfcr6WrlUD2B0O/Waw515Na2abFQvtYPBK17zwKA5I8Lp77ZVHeHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hTJy4/ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hTJy4/ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E0BC4CEDD;
	Tue, 11 Feb 2025 23:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739318150;
	bh=pxXrxTlhk9CnVwbrqNRApZAuBiwNoCPv587pKua63Pw=;
	h=Date:To:From:Subject:From;
	b=hTJy4/phXxWyyycSP7MgK7l5NwcJnXmnBRXWUL8ibAY9a17BdVwLGS0VDnpm2fM5P
	 BnUnyXBvc1dvZyVwauUTH1z1z/A0/os0d8gD7K0mdx4/l2inH6bBB4lXq2UrZRtr3E
	 IjLX9/QTVayOrw8mAwtV8XUk9yZo6uUv3IrT1fG8=
Date: Tue, 11 Feb 2025 15:55:49 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20250211235550.62E0BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
Date: Tue Feb 11 03:55:07 PM PST 2025

WARNING: suspect code indent for conditional statements (8, 12)
#57: FILE: mm/madvise.c:1598:
+	if (is_memory_failure(behavior))
+	    return 0;

WARNING: Statements should start on a tabstop
#58: FILE: mm/madvise.c:1599:
+	    return 0;

WARNING: suspect code indent for conditional statements (8, 12)
#72: FILE: mm/madvise.c:1612:
+	if (is_memory_failure(behavior))
+	    return;

WARNING: Statements should start on a tabstop
#73: FILE: mm/madvise.c:1613:
+	    return;

Please run checkpatch prior to sending patches

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes
+++ a/mm/madvise.c
@@ -1596,7 +1596,7 @@ static bool is_memory_failure(int behavi
 static int madvise_lock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
-	    return 0;
+		return 0;
 
 	if (madvise_need_mmap_write(behavior)) {
 		if (mmap_write_lock_killable(mm))
@@ -1610,7 +1610,7 @@ static int madvise_lock(struct mm_struct
 static void madvise_unlock(struct mm_struct *mm, int behavior)
 {
 	if (is_memory_failure(behavior))
-	    return;
+		return;
 
 	if (madvise_need_mmap_write(behavior))
 		mmap_write_unlock(mm);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-checkpatch-fixes.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix-fix.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

