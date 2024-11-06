Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADB814EC7E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854713; cv=none; b=Xnf9sN8X1h/9u/qNZkDrXQRtF3FpqMPKe1WqvrnX9Q67hKrmP7vuXr5bi3MRrJu9hv6vjGieALHi/y5m3+rPub4gUXARpqcQWOwYiJp+qz8UnyCp1ilkvmTxKS+WFW7eFitBnWOAeCHgHky6uzuG1hHC66kng5oW/Ub9T1uM14o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854713; c=relaxed/simple;
	bh=QqZ8WxxgHIXZIT3PdszERHOqrAXs9leJYNEou5UNr4w=;
	h=Date:To:From:Subject:Message-Id; b=VFq1CrI6JE5h1JjwbocHnmmOyBDCjeUc+PbSMhM9aYcMTde0NnMdj3jF43fSjegwJPvIMBCmQ+CYbC8lomb66wKIecPAErpAJEnCZYM4iitYmDdpOBIvQx0kUeoZdpPOD1VA68O77nP38yLdP6/YxbGCDrNPuaNY5qntC3EF8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y0bZYwW8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y0bZYwW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20DBC4CECF;
	Wed,  6 Nov 2024 00:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854712;
	bh=QqZ8WxxgHIXZIT3PdszERHOqrAXs9leJYNEou5UNr4w=;
	h=Date:To:From:Subject:From;
	b=y0bZYwW8MXOZxEitum9LBGj0r1UMS65WkkZcgtPRMV4JhzLNKjSGgqjtYi3lOesln
	 t1XS1u1lu4Ir9ka4FYSZMqJuxYHyBWpv4BeuXLQor+OMvMFtma/Svm3ccgOyaApMim
	 S/fL5O4Gv26zKhBCo0UEL3ZUBKkz5/bQObAbn6Hw=
Date: Tue, 05 Nov 2024 16:58:32 -0800
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch removed from -mm tree
Message-Id: <20241106005832.D20DBC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: i is always less than or equal to mas_end
has been removed from the -mm tree.  Its filename was
     maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: maple_tree: i is always less than or equal to mas_end
Date: Wed, 11 Sep 2024 14:27:58 +0000

Patch series "refine mas_mab_cp()".

By analysis of the code, one condition check can be removed and one case
would hit a redundant assignment.


This patch (of 2):

mas_mab_cp() copy range [mas_start, mas_end] inclusively from a
maple_node to maple_big_node. This implies mas_start <= mas_end.

Based on the relationship of mas_start and mas_end, we can have the
following four cases:

                 | mas_start == mas_end |  mas_start < mas_end
  ---------------+----------------------+----------------------
  mas_start == 0 |         1            |          2
  ---------------+----------------------+----------------------
  mas_start != 0 |         3            |          4

We can see in all these four cases, i is always less than or equal to
mas_end after finish the loop:

  Case 1: After assign pivot 0, i is set to 1, which is bigger than
          mas_end 0. So it jumps to complete and skip the check.
  Case 2: After assign pivot 0, i is set to 1.
          ∵ (mas_start < mas_end) && (mas_start == 0)
             ==>  (1 <= mas_end)
          ∵ (i == 1) && (1 <= mas_end)
             ==>  (i <= mas_end)
          ∴ Before loop, we have (i <= mas_end). And we still hold this
             if it skips the loop. For example, (i == mas_end).

          Now let's see what happens in the loop:
          ∵ piv_end = min(mas_end, mt_pivots[mt])
             ==>  (piv_end <= mas_end)
	  ∵ loop condition is (i < piv_end)
	     ==>  (i <= piv_end) on finish the loop both normally or break
          ∵ (i <= piv_end) && (piv_end <= mas_end)
             ==>  (i <= mas_end)
          ∴ After loop, we still get (i <= mas_end) in this case
  Case 3: This case would skip both if clause and loop. So when it comes
          to the check, i is still mas_start which equals to mas_end.
  Case 4: This case would skip the if clause.
          ∵ (mas_start < mas_end) && (i == mas_start)
             ==>  (i < mas_end)
          ∴ Before loop, we have (i < mas_end).
          The loop process is similar with Case 2, so we get the same
	  result.

Now we can conclude in all cases, we get (i <= mas_end) when doing
check. Then it is not necessary to do the check.

Link: https://lkml.kernel.org/r/20240911142759.20989-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20240911142759.20989-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/lib/maple_tree.c~maple_tree-i-is-always-less-than-or-equal-to-mas_end
+++ a/lib/maple_tree.c
@@ -1949,8 +1949,7 @@ static inline void mas_mab_cp(struct ma_
 			goto complete;
 	}
 
-	if (likely(i <= mas_end))
-		b_node->pivot[j] = mas_safe_pivot(mas, pivots, i, mt);
+	b_node->pivot[j] = mas_safe_pivot(mas, pivots, i, mt);
 
 complete:
 	b_node->b_end = ++j;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mlock-set-the-correct-prev-on-failure.patch
maple_tree-print-empty-for-an-empty-tree-on-mt_dump.patch
maple_tree-the-return-value-of-mas_root_expand-is-not-used.patch
maple_tree-not-necessary-to-check-index-last-again.patch
maple_tree-refine-mas_store_root-on-storing-null.patch
maple_tree-add-a-test-checking-storing-null.patch

