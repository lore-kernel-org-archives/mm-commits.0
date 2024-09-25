Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5141EB36
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727258563; cv=none; b=gTocZdHEo9t9jNAtOP0Mysj+p1px6p9+DviwaAgh9BJH72TbmnXjzKGZuEXEzEYo0hmpNi1q40b5UyBGmBcqwoglQ/CHTb+hHJjXJ+4m0pnFw4+P2Hq3TvAnsf4AQlwBWcdDMfK/xO98sxJQKa5hCQoln3EAYlCw2jRZdlUr75g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727258563; c=relaxed/simple;
	bh=m41ClxIqRYjsfKg0RcVL6Lh14U3/GraobjIECFfk4E8=;
	h=Date:To:From:Subject:Message-Id; b=DrEl6cA4iLQh0DqFDE+G4wFFIXL9wGuE/CptNQsKSM0c+olegKxCRwzTJ/Og0xNnY58dLjdTB/91flosd0fA2cGxhgRvkxR0gMKHZMPfO0oltsiTvDRnP6WL8CLeIXrxFuFFyU5NOC73/YZCDddOX9MeyTaZZFZdap8FOksU4mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WE953Fva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WE953Fva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C5CC4CEC3;
	Wed, 25 Sep 2024 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727258563;
	bh=m41ClxIqRYjsfKg0RcVL6Lh14U3/GraobjIECFfk4E8=;
	h=Date:To:From:Subject:From;
	b=WE953FvaYKIFiwc6rOMI62z8cz2mq3mRz5wDioIsIk+lRm/NYcKdu0Rr6NY08P0Nz
	 XFVDqKnszpzk54LwI4qnIw4WxnnNfOvO2FiW3KPjltWeIydSmQoxEeJ6CTqFnNJER/
	 m4q4sZVItLXf2n6hqe9E20IJtko2oOA407+6Acys=
Date: Wed, 25 Sep 2024 03:02:42 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch added to mm-unstable branch
Message-Id: <20240925100243.25C5CC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: i is always less than or equal to mas_end
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch

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

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch

