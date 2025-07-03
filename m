Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96FED28A1F8
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 21:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751578820; cv=none; b=tn5qxUgsx3G5GLTyKRy/dVBbHB0T8+wl7m567Zp1Ip1hCpiv0PrSffb85Iju29s/t3zec83pjiOX9MYM4wIqlwLdRDYYnaw+RL0OPsqxCOe+Rd+fEY1cPcAJoWCDYZzu75JKrfwXQrtZ2sUdFcjl5oYk87O6hzj0Fy4gURrTSo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751578820; c=relaxed/simple;
	bh=LbT+j5te9/CKgJ2Ovqq0TzJbQaktgKXjrbagrmX3MSU=;
	h=Date:To:From:Subject:Message-Id; b=H5kRv/46uKOmxlGM153DKu/gvXa2pvFaOn+lOAWoG8lJq3wwgBH3bkwp0MdnfzE7Op4RzpPMMeTWzOPmKqVAsgmJY++dV16uFYVQu5TMEucfnOgt2D2QoH+OE+H+U2Ejup7fntT1o6YGvaZnJw1SeNe50Gcprq15xYn8sEMaQy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WwOvATCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WwOvATCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF0DC4CEED;
	Thu,  3 Jul 2025 21:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751578820;
	bh=LbT+j5te9/CKgJ2Ovqq0TzJbQaktgKXjrbagrmX3MSU=;
	h=Date:To:From:Subject:From;
	b=WwOvATCdk8PHp8YMBa9OhEqRYD3TrwS25AqXqVCAHqHgdi+VCcciaeCDTDcZTW1Pv
	 NUBtbdv6gYVAe3mb1uyHQvT4y4wRb/Vs6KTGEkGueWZ26XbtnEaN+fEWo5WrWd6fS0
	 VaM9Cnl+Hn2kGT2pxCmDfWGlKYtKkin96Vb66IFg=
Date: Thu, 03 Jul 2025 14:40:19 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,liam.howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple-tree-add-some-comments.patch added to mm-new branch
Message-Id: <20250703214020.1EF0DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple tree: add some comments
has been added to the -mm mm-new branch.  Its filename is
     maple-tree-add-some-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple-tree-add-some-comments.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: maple tree: add some comments
Date: Thu, 3 Jul 2025 12:03:38 +0530

Add comments explaining the fields for maple_metadata, since "end" is
ambiguous and "gap" can be confused as the largest gap, whereas it is
actually the offset of the largest gap.

Add comment for mas_ascend() to explain, whose min and max we are trying
to find.  Explain that, for example, if we are already on offset zero,
then the parent min is mas->min, otherwise we need to walk up to find the
implied pivot min.

Link: https://lkml.kernel.org/r/20250703063338.51509-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    4 ++--
 lib/maple_tree.c           |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/include/linux/maple_tree.h~maple-tree-add-some-comments
+++ a/include/linux/maple_tree.h
@@ -75,8 +75,8 @@
  * searching for gaps or any other code that needs to find the end of the data.
  */
 struct maple_metadata {
-	unsigned char end;
-	unsigned char gap;
+	unsigned char end;	/* end of data */
+	unsigned char gap;	/* offset of largest gap */
 };
 
 /*
--- a/lib/maple_tree.c~maple-tree-add-some-comments
+++ a/lib/maple_tree.c
@@ -1053,7 +1053,7 @@ static inline void mte_set_gap(const str
  * mas_ascend() - Walk up a level of the tree.
  * @mas: The maple state
  *
- * Sets the @mas->max and @mas->min to the correct values when walking up.  This
+ * Sets the @mas->max and @mas->min for the parent node of mas->node.  This
  * may cause several levels of walking up to find the correct min and max.
  * May find a dead node which will cause a premature return.
  * Return: 1 on dead node, 0 otherwise
@@ -1098,6 +1098,12 @@ static int mas_ascend(struct ma_state *m
 
 	min = 0;
 	max = ULONG_MAX;
+
+	/*
+	 * !mas->offset implies that parent node min == mas->min.
+	 * mas->offset > 0 implies that we need to walk up to find the
+	 * implied pivot min.
+	 */
 	if (!mas->offset) {
 		min = mas->min;
 		set_min = true;
_

Patches currently in -mm which might be from dev.jain@arm.com are

xarray-add-a-bug_on-to-ensure-caller-is-not-sibling.patch
mm-call-pointers-to-ptes-as-ptep.patch
mm-optimize-mremap-by-pte-batching.patch
maple-tree-use-goto-label-to-simplify-code.patch
maple-tree-add-some-comments.patch

