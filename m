Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C882D2153E1
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188241; cv=none; b=L5LEwNuIbHj0s5VKDU7GsZ2yuCncAN3Iw2FPI1JHGJslJLU0evNUYzGzeOrLsx+olXVGOKnEowM51L2SD3djgWAWtor4YSOmlq9j9v778tevfYDpOoVsc3nn+aIFhxalIsBuuj4PCpA0LngsePjJu5RSZdVefOI3hl7Oha1sbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188241; c=relaxed/simple;
	bh=7ZgZiBiGIMpPNPSbk4Isp3LJYof9f//1uuygChtTt3I=;
	h=Date:To:From:Subject:Message-Id; b=kHA12eL8rlMtwLBTt4UJt55Q4Fl21d3RRDMhc7APCEs7WScOoEWF4nPksFpVg+CQU1RbKaQpLBsZiR8fvmEIkxzf3ttVSiBmHWC7vxsVioqAp3lCg+8ada1pDSW2a3vb31XMITUwwUy/Cof6uVW/ZA9EtcXeumjS3a2o3H+pxgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M6SiN7+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M6SiN7+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2C9C4CEEC;
	Mon, 17 Mar 2025 05:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188240;
	bh=7ZgZiBiGIMpPNPSbk4Isp3LJYof9f//1uuygChtTt3I=;
	h=Date:To:From:Subject:From;
	b=M6SiN7+LQOwXv1nrrA+LTN//F9j5QiiZ7DMUMJotho5uXUdOuiTSgYj0w+p/E7ChP
	 2MUQQxHgdUNArqy2X+r8ZOCFBimi1yuU5mq8Mps5SBe6PW6IqKuRDQusSO0BSe5/Jy
	 uRAhQ2ni6fxTz//7OMz2M0S7Sv/DVfm22WYHfF38=
Date: Sun, 16 Mar 2025 22:10:40 -0700
To: mm-commits@vger.kernel.org,ryncsn@gmail.com,chrisl@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch removed from -mm tree
Message-Id: <20250317051040.DC2C9C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swapfile.c: update the code comment above swap_count_continued()
has been removed from the -mm tree.  Its filename was
     mm-swapfilec-update-the-code-comment-above-swap_count_continued.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/swapfile.c: update the code comment above swap_count_continued()
Date: Wed, 5 Feb 2025 17:27:15 +0800

Now, swap_count_continued() has two callers, __swap_duplicate() and
__swap_entry_free_locked(), the relevant code comment is stale.  Update it
to reflect the current situation.

[bhe@redhat.com: v2]
  Link: https://lkml.kernel.org/r/Z6V0/UvG1fvkQ4t/@fedora
Link: https://lkml.kernel.org/r/20250205092721.9395-7-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/swapfile.c~mm-swapfilec-update-the-code-comment-above-swap_count_continued
+++ a/mm/swapfile.c
@@ -3797,8 +3797,8 @@ outer:
  * into, carry if so, or else fail until a new continuation page is allocated;
  * when the original swap_map count is decremented from 0 with continuation,
  * borrow from the continuation and report whether it still holds more.
- * Called while __swap_duplicate() or swap_entry_free() holds swap or cluster
- * lock.
+ * Called while __swap_duplicate() or caller of __swap_entry_free_locked()
+ * holds cluster lock.
  */
 static bool swap_count_continued(struct swap_info_struct *si,
 				 pgoff_t offset, unsigned char count)
_

Patches currently in -mm which might be from bhe@redhat.com are


