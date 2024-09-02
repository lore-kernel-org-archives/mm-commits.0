Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DEA6F2FE
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247842; cv=none; b=oTZMbdBw+Sl+o5FDEto/o8gMjH0sp5ztYkc0LFaHn8q3s0W+GP2xCWYE1EdMgP9AM2WBagKqTunUYpr53Ce6HKtUknX4CGUvynCEYCGvG95reYnYWC7VZjC+MWmmMJRhokV0ezYlRmMEaQqaO+/LmLbpa8g0fh+B9rJYOaZ6bF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247842; c=relaxed/simple;
	bh=ffNRIiYV9pkbOrNhBXLh8NofATqict6v82P7ppZzJkI=;
	h=Date:To:From:Subject:Message-Id; b=i9XannZ0kqLwY/BJZb7lv02M0tFBUMpsUpWP7SxLPQ7E5hMAUjtVToBndwhX7R8b5LRpdUxNPzVuTVRP3FSwubmvTmfkDZ3VBTME+doETjByAvvfbUJOItjnqbg2m9R9+FSmydxfMHJ9Ym8n+OUDq+7HI9Ta5IZ/CUSVr7QCtac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x5K4IkYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x5K4IkYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1806BC4CEC2;
	Mon,  2 Sep 2024 03:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247842;
	bh=ffNRIiYV9pkbOrNhBXLh8NofATqict6v82P7ppZzJkI=;
	h=Date:To:From:Subject:From;
	b=x5K4IkYOeoUfIBrvmAirc+Kq/lEqwIqHbMfPISW/jH2gHAyaNF21joPmlEDpSnbRH
	 +8PRWi6oPUDBZA3HkD8FpJzPMS2ukbxL/xZj7kpdM/X53la4D1NUnKaikyf2F7CD+Z
	 wc0yyYNxZmPa0Neri6ynE7YTZkzjxEBwXkkY0qRY=
Date: Sun, 01 Sep 2024 20:30:41 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch removed from -mm tree
Message-Id: <20240902033042.1806BC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove repeated sanity checks from write helper functions
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-repeated-sanity-checks-from-write-helper-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove repeated sanity checks from write helper functions
Date: Wed, 14 Aug 2024 12:19:42 -0400

These sanity checks are now redundant as they are already checked in
mas_wr_store_type(). We can remove them from mas_wr_append() and
mas_wr_node_store().

Link: https://lkml.kernel.org/r/20240814161944.55347-16-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-repeated-sanity-checks-from-write-helper-functions
+++ a/lib/maple_tree.c
@@ -3816,11 +3816,6 @@ static inline bool mas_wr_node_store(str
 	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
 	bool in_rcu = mt_in_rcu(mas->tree);
 
-	/* Check if there is enough data. The room is enough. */
-	if (!mte_is_root(mas->node) && (new_end < mt_min_slots[wr_mas->type]) &&
-	    !(mas->mas_flags & MA_STATE_BULK))
-		return false;
-
 	if (mas->last == wr_mas->end_piv)
 		offset_end++; /* don't copy this offset */
 	else if (unlikely(wr_mas->r_max == ULONG_MAX))
@@ -4018,17 +4013,9 @@ static inline unsigned char mas_wr_new_e
 static inline bool mas_wr_append(struct ma_wr_state *wr_mas,
 		unsigned char new_end)
 {
-	struct ma_state *mas;
+	struct ma_state *mas = wr_mas->mas;
 	void __rcu **slots;
-	unsigned char end;
-
-	mas = wr_mas->mas;
-	if (mt_in_rcu(mas->tree))
-		return false;
-
-	end = mas->end;
-	if (mas->offset != end)
-		return false;
+	unsigned char end = mas->end;
 
 	if (new_end < mt_pivots[wr_mas->type]) {
 		wr_mas->pivots[new_end] = wr_mas->pivots[end];
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are


