Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95416285CA6
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126381; cv=none; b=VxYEFHFkwe9eZzt6lCAh7OwAi/7tths+x3H32q1XEnw3dIZEAYNMflnOw0yGOPIsLYqnrEuzWuc+2l3Fzin7FjBV1Cw/q+a5xxMWhgg2mePoOaN+Ju9ZypMRgvgLIP7gnCxn9PvfC0GYWJuzryP0TpsrmyH7q0h4SrS7oQgwcOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126381; c=relaxed/simple;
	bh=z3nS+jA6wv+0wxSjKOLXc8MEKwWF8MaIqwzPm3tkd00=;
	h=Date:To:From:Subject:Message-Id; b=kwA/pCd3k1Y1KXrQAH/TjnrhtejKAzOQNvmi2W85ida8J5WlMzCAKRkDHRfLQxPHLcYzHnoDOe+O4FBL1A1glynvsOZioSbc/IId8Cg3JiHsd/VodpIjaqGUjCPjeIC9pGrIQyFz0Jcs9SZJxAJaDoWXOk/I8bRTMEF4m7rz2vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkUvFH/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkUvFH/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB37C4CEE3;
	Thu, 10 Jul 2025 05:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126381;
	bh=z3nS+jA6wv+0wxSjKOLXc8MEKwWF8MaIqwzPm3tkd00=;
	h=Date:To:From:Subject:From;
	b=xkUvFH/jYviZPWm2gA86eA3jGPfOEQz4vHVTusfj6G3LOEESBF7TFD1DU7bb+QEIP
	 2ODfs7MS3FhegrMYGWzLquhDVu5ZjhUlXGOHreVkBquHCR09dMS7ndsMdlErl2e5tF
	 WrAIBgxSFYgm7yq6l6wdn8x1qABvcvtsdPtfuSME=
Date: Wed, 09 Jul 2025 22:46:20 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,oliver.sang@intel.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-status-setup-on-restore-to-active.patch removed from -mm tree
Message-Id: <20250710054621.6AB37C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix status setup on restore to active
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-status-setup-on-restore-to-active.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix status setup on restore to active
Date: Tue, 24 Jun 2025 11:48:22 -0400

During the initial call with a maple state, an error status may be set
before a valid node is populated into the maple state node.  Subsequent
calls with the maple state may restore the state into an active state with
no node set.  This was masked by the mas_walk() always resetting the
status to ma_start and result in an extra walk in this rare scenario.

Don't restore the state to active unless there is a value in the structs
node.  This also allows mas_walk() to be fixed to use the active state
without exposing an issue.

User visible results are marginal performance improvements when an active
state can be restored and used instead of rewalking the tree.

Stable is not Cc'ed because the existing code is stable and the
performance gains are not worth the risk.

Link: https://lore.kernel.org/all/20250611011253.19515-1-richard.weiyang@gmail.com/
Link: https://lore.kernel.org/all/20250407231354.11771-1-richard.weiyang@gmail.com/
Link: https://lore.kernel.org/all/202506191556.6bfc7b93-lkp@intel.com/
Link: https://lkml.kernel.org/r/20250624154823.52221-1-Liam.Howlett@oracle.com
Fixes: a8091f039c1e ("maple_tree: add MAS_UNDERFLOW and MAS_OVERFLOW states")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Wei Yang <richard.weiyang@gmail.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202506191556.6bfc7b93-lkp@intel.com
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-status-setup-on-restore-to-active
+++ a/lib/maple_tree.c
@@ -4927,7 +4927,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
+	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
 	entry = mas_state_walk(mas);
@@ -5655,6 +5655,17 @@ int mas_expected_entries(struct ma_state
 }
 EXPORT_SYMBOL_GPL(mas_expected_entries);
 
+static void mas_may_activate(struct ma_state *mas)
+{
+	if (!mas->node) {
+		mas->status = ma_start;
+	} else if (mas->index > mas->max || mas->index < mas->min) {
+		mas->status = ma_start;
+	} else {
+		mas->status = ma_active;
+	}
+}
+
 static bool mas_next_setup(struct ma_state *mas, unsigned long max,
 		void **entry)
 {
@@ -5678,11 +5689,11 @@ static bool mas_next_setup(struct ma_sta
 		break;
 	case ma_overflow:
 		/* Overflowed before, but the max changed */
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		break;
 	case ma_underflow:
 		/* The user expects the mas to be one before where it is */
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
@@ -5803,11 +5814,11 @@ static bool mas_prev_setup(struct ma_sta
 		break;
 	case ma_underflow:
 		/* underflowed before but the min changed */
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		break;
 	case ma_overflow:
 		/* User expects mas to be one after where it is */
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
@@ -5972,7 +5983,7 @@ static __always_inline bool mas_find_set
 			return true;
 		}
 
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
@@ -5981,7 +5992,7 @@ static __always_inline bool mas_find_set
 		if (unlikely(mas->last >= max))
 			return true;
 
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


