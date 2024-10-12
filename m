Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F7538B
	for <mm-commits@vger.kernel.org>; Sat, 12 Oct 2024 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728771142; cv=none; b=IgzPn1OckItfmM9/wGoNV3+NnwqvaiJOfzh0fglPWY/iQNLFeWpVZcFO6UrqE547YWh6c7ko/BiUM0LIgT+zRz+Q7ZyxAmFmtLIqVS9BGQk96X6drmyvDQvLv6WZEuX+OM4Xooldvji0uvKSbisBQQsspcxS5RlbBV78PwCaXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728771142; c=relaxed/simple;
	bh=2XrHgE+DHdEi5wnT81QpmYzNkTLlVKCmfXAJ0k0rzuU=;
	h=Date:To:From:Subject:Message-Id; b=rDdLmhMzMqOMLHkIM89cSNH/2HzMRoOkuGS/63VoFTJLkt5li75YjdXIDkVPIZO5gLY9/eEkN7Vq4U3bPKs0d+Mjhv9NgmS3iwCsi6IpnvCj3Lsc/FLsEEzSrB71fs9lvALL6ib3/zosse7xnYp0i3ECd16jqObW86lhW9lOT6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zLhYqQ7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zLhYqQ7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C271C4CEC6;
	Sat, 12 Oct 2024 22:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728771142;
	bh=2XrHgE+DHdEi5wnT81QpmYzNkTLlVKCmfXAJ0k0rzuU=;
	h=Date:To:From:Subject:From;
	b=zLhYqQ7om7p3DJE5i1tMpwf4Z09kS6Cu3v5nZFB+qpKZ7niL8BfU4qeT/t4NxQ8eZ
	 BZ7Imdpx0EfxRPDTqmVNjFLGzJKvuCyhiR4eqpV86UWpny+WjJE+uR4W6uVasD4cL/
	 tiykBA/NcNkFLWuazcvfgB7yOifEumbPtn6nmZbk=
Date: Sat, 12 Oct 2024 15:12:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,Liam.Howlett@oracle.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] maple_tree-remove-conditionals-to-detect-wr_node_store.patch removed from -mm tree
Message-Id: <20241012221222.5C271C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove conditionals to detect wr_node_store
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-conditionals-to-detect-wr_node_store.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sidhartha <sidhartha.kumar@oracle.com>
Subject: maple_tree: remove conditionals to detect wr_node_store
Date: Wed, 9 Oct 2024 11:20:07 -0400

In mas_wr_store_type(), we check if new_end < mt_slots[wr_mas->type].  If
this check fails, we know that after this, new_end is >= mt_min_slots. 
Checking this again when we detect a wr_node_store later in the function
is reduntant.  Because this check is part of an OR statement, the
statement will always evaluate to true, therefore we can just get rid of
it.

Link: https://lkml.kernel.org/r/20241009152007.2096-1-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Suggested-by; Wei Yang <richard.weiyang@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/lib/maple_tree.c~maple_tree-remove-conditionals-to-detect-wr_node_store
+++ a/lib/maple_tree.c
@@ -4252,14 +4252,7 @@ static inline void mas_wr_store_type(str
 		return;
 	}
 
-	if (mte_is_root(mas->node) || (new_end >= mt_min_slots[wr_mas->type]) ||
-		(mas->mas_flags & MA_STATE_BULK)) {
-		mas->store_type = wr_node_store;
-		return;
-	}
-
-	mas->store_type = wr_invalid;
-	MAS_WARN_ON(mas, 1);
+	mas->store_type = wr_node_store;
 }
 
 /**
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-check-for-ma_state_bulk-on-setting-wr_rebalance.patch
maple_tree-refactor-mas_wr_store_type.patch

