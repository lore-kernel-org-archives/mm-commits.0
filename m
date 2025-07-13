Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305B91EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450051; cv=none; b=dNpFkZGZ8qjTItL9h34J0EO1oOqEICVXGQ94QRzDCRoyt3kVCMe8C7AV1sCDysvS41L85/m1SCXMhZGhxdl9v/fx2BZUoComQcrrOCyU2YHBwRsJgAO6XB6LMmHErU3vxrga+wT8rOCZ+dqu57wdPYMu+wxFZ7lK9mMQatZzcvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450051; c=relaxed/simple;
	bh=XunXJWON2MRW9kg3L07G/GgP8M55kEu2sEkDBTkTD5Y=;
	h=Date:To:From:Subject:Message-Id; b=XVv0s7MizhPfB1MABK7/1tjOnxGmljtDpawkvO5WulFlXeB7mWrfQpeUIBC/HxiQhpgnwMajdW1k/DIYLWABaoUG207jQHpSMqLjt/p9hpZkt3j4+FiuFuGi2/HArJKp+NZrPLhKmv89UaNaaFi9yWl7JMO9vDj3hfKCpg/Q0ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xm1HePxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xm1HePxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0409DC4CEE3;
	Sun, 13 Jul 2025 23:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450051;
	bh=XunXJWON2MRW9kg3L07G/GgP8M55kEu2sEkDBTkTD5Y=;
	h=Date:To:From:Subject:From;
	b=xm1HePxME21D7Ja8br9V13O/KAxob9FAkld+GXrpvjZPgM6SOjieqzssgX9jXFsYv
	 G8E/cWx4UnoyrUX6O+H6BKg5oyVYc26LQ8FT+p2sEzgPrqf4r882Ph1apnv/Yf+QHS
	 wA/MkCtJKcjFrhcufqlszY3wfvOLk5ghvZfwm8qg=
Date: Sun, 13 Jul 2025 16:40:50 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,Liam.Howlett@oracle.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple-tree-add-some-comments.patch removed from -mm tree
Message-Id: <20250713234051.0409DC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple tree: add some comments
has been removed from the -mm tree.  Its filename was
     maple-tree-add-some-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
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


