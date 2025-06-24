Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BC9254B1F
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799569; cv=none; b=BKA6Gs48wyw6gdAbolE4OhbSk4Vil4YDnoWxjMR4p/cD47tbHgqf6eQ535L0a9btQaSL8yUHZR3XTJVdJVp5rp95XRBFo/qgO2tsudkc58rQXjTRvxXQ+rMeNnQSQXJ2ootiryTqG5Us5uRX89BzcM6BLQBkCUAPhwb/V0ejbIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799569; c=relaxed/simple;
	bh=GMNtgRWniYEUiRokfhRN49obLSnhP3LbY3UyMHbfTl4=;
	h=Date:To:From:Subject:Message-Id; b=J2UAp2wCh4c41aflpkHwAOIUk/xmui/xW6AdfZbn8VD4DI2rx1GSlJJYiO6gcAWGWNGoD5uJbF0OBjVp/1q+imXdnG2FC+8XBn9BISE+Jwhw8W3A+ijGv9xgcSggCYEyQgh6eVHWXOkF34sQsk+bZotpAcH9VF3pICN2EWkWN0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jgMoY/b6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jgMoY/b6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0212C4CEE3;
	Tue, 24 Jun 2025 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750799568;
	bh=GMNtgRWniYEUiRokfhRN49obLSnhP3LbY3UyMHbfTl4=;
	h=Date:To:From:Subject:From;
	b=jgMoY/b6KT+slFczOobcPeSJMYOOeaMJiDYAcM9tTDlFoWJZOWKTWHDNoZtKNV27j
	 bzFI6uAO+KhxxOVfU9O6MVWARf1E2Bud51w0jtEMAKPXgWnGivt/BnWRss5YNX03b1
	 TkP/5q2BKmurJELZBI81aKO0Ns6yCzX6CctJkGU4=
Date: Tue, 24 Jun 2025 14:12:48 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,oliver.sang@intel.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-fix-status-setup-on-restore-to-active.patch added to mm-new branch
Message-Id: <20250624211248.B0212C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: fix status setup on restore to active
has been added to the -mm mm-new branch.  Its filename is
     maple_tree-fix-status-setup-on-restore-to-active.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-fix-status-setup-on-restore-to-active.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: fix status setup on restore to active
Date: Tue, 24 Jun 2025 11:48:22 -0400

During the initial call with a maple state, an error status may be set
before a valid node is populated into the maple state node.  Subsequent
calls with the maple state may restore the state into an active state with
no node set.  This was masked by the mas_walk() always resetting the
status to ma_state and result in an extra walk in this rare scenario.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/lib/maple_tree.c~maple_tree-fix-status-setup-on-restore-to-active
+++ a/lib/maple_tree.c
@@ -4930,7 +4930,7 @@ void *mas_walk(struct ma_state *mas)
 {
 	void *entry;
 
-	if (!mas_is_active(mas) || !mas_is_start(mas))
+	if (!mas_is_active(mas) && !mas_is_start(mas))
 		mas->status = ma_start;
 retry:
 	entry = mas_state_walk(mas);
@@ -5659,6 +5659,17 @@ int mas_expected_entries(struct ma_state
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
@@ -5682,11 +5693,11 @@ static bool mas_next_setup(struct ma_sta
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
@@ -5807,11 +5818,11 @@ static bool mas_prev_setup(struct ma_sta
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
@@ -5976,7 +5987,7 @@ static __always_inline bool mas_find_set
 			return true;
 		}
 
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
@@ -5985,7 +5996,7 @@ static __always_inline bool mas_find_set
 		if (unlikely(mas->last >= max))
 			return true;
 
-		mas->status = ma_active;
+		mas_may_activate(mas);
 		*entry = mas_walk(mas);
 		if (*entry)
 			return true;
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

tools-testing-radix-tree-test-maple-tree-chaining-mas_preallocate-calls.patch
maple_tree-fix-status-setup-on-restore-to-active.patch
maple_tree-add-testing-for-restoring-maple-state-to-active.patch

