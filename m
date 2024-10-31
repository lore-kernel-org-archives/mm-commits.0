Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162891CCEEC
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 20:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730407703; cv=none; b=GPp4MT/6Cc7G/9bdPfcIv1hRtSugSh/8hAsgH8gxPf7vmxSyObyS+CfYICH88Pwhazv+q8WR9PnG4D1gJ0V4oz6Hz3vKjVpghWT+0QlLYmPuV33YNwY8g+9Y7AcuknoUmhKfU6fZLLPsmx/4b9IQ618dXstOz15Cm49hEX9cYLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730407703; c=relaxed/simple;
	bh=6I+E+0KbFwlpxgBMzHyZGRIJoktDF2Ice48O8IDrd4w=;
	h=Date:To:From:Subject:Message-Id; b=LiiCeEfRLvfU6wKZ/JhG88nC5vcrHPg+3No7Ay7tYzDm3Ef9SC5n667diJmBz8JmLiUxUzHlsuwS/Rksbp/qwXjqngk/+pOvqE2QSq62sSXjQRn5Mx60FOnpeX61Ca/+zB/aZK63voP5LSVAhGZjHVfQXumm520dHK+lM2cCPM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mg46dSEE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mg46dSEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81154C4CEC3;
	Thu, 31 Oct 2024 20:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730407702;
	bh=6I+E+0KbFwlpxgBMzHyZGRIJoktDF2Ice48O8IDrd4w=;
	h=Date:To:From:Subject:From;
	b=mg46dSEEJxG7FCHwi2pkbB9FQIJg5S3e6sU82mCEcRGVVk7P4S1mHtVli6UKPR6T8
	 j/59ZHhikayn+wAJNiErxOKLk1IxzzCzch5cG4HXTgSP72IIBv13b3ng35l/3CfLID
	 6T3Qb8U1eeadMI1/xN2csvtrgbyf8P35HszlNw+s=
Date: Thu, 31 Oct 2024 13:48:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,jannh@google.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vma-detect-infinite-loop-in-vma-tree.patch added to mm-unstable branch
Message-Id: <20241031204822.81154C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vma: detect infinite loop in vma tree
has been added to the -mm mm-unstable branch.  Its filename is
     vma-detect-infinite-loop-in-vma-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vma-detect-infinite-loop-in-vma-tree.patch

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: vma: detect infinite loop in vma tree
Date: Thu, 31 Oct 2024 15:36:08 -0400

There have been no reported infinite loops in the tree, but checking the
detection of an infinite loop during validation is simple enough.  Add the
detection to the validate_mm() function so that error reports are clear
and don't just report stalls.

This does not protect against internal maple tree issues, but it does
detect too many vmas being returned from the tree.

The variance of +10 is to allow for the debugging output to be more useful
for nearly correct counts.  In the event of more than 10 over the
map_count, the count will be set to -1 for easier identification of a
potential infinite loop.

Note that the mmap lock is held to ensure a consistent tree state during
the validation process.

Link: https://lkml.kernel.org/r/20241031193608.1965366-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~vma-detect-infinite-loop-in-vma-tree
+++ a/mm/vma.c
@@ -615,7 +615,10 @@ void validate_mm(struct mm_struct *mm)
 			anon_vma_unlock_read(anon_vma);
 		}
 #endif
-		i++;
+		if (++i > mm->map_count + 10) {
+			i = -1;
+			break;
+		}
 	}
 	if (i != mm->map_count) {
 		pr_emerg("map_count %d vma iterator %d\n", mm->map_count, i);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

mm-mremap-clean-up-vma_to_resize.patch
mm-mremap-remove-goto-from-mremap_to.patch
vma-detect-infinite-loop-in-vma-tree.patch

