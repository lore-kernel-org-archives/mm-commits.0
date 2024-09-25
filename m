Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE8F1EB36
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 10:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727258565; cv=none; b=dA8iHlGZCzbHvWytb7oPfrhD/+MadRk7q8o1gF56J9SYnNQYX39tZXk7AwtgXrX14yN66jTn5HM/0NLT0xHI2grdjlqczZhNK9WaC9UEmrlKQHjEwyjlnbrb8zrX/5fde7ISYtQlJp/VfGWvRxpwK1HFOxT+rp+mZMAhVcEbqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727258565; c=relaxed/simple;
	bh=XQY+GtrYxX3ZGhuqc5ZP41znWqWLoi7sPKnWzhwwBgE=;
	h=Date:To:From:Subject:Message-Id; b=tWnn1x3Hs1KX6GrZJH+LUhP80hdiiGVV1emo1BOQHdhB4nCGRySNdJ81R+mIUZmCfAuL7uc0Dtf7Uv7qozZaLcyET5S/AL04EeIxgY3mf6V7PQB6VwrCtQsG+XmsQ4aShxqcMpDa8lAayTHB5I7B2m4Tq9IUlJgums6SuNSJj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtCoo3JD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtCoo3JD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EC4C4CEC3;
	Wed, 25 Sep 2024 10:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727258565;
	bh=XQY+GtrYxX3ZGhuqc5ZP41znWqWLoi7sPKnWzhwwBgE=;
	h=Date:To:From:Subject:From;
	b=CtCoo3JDzcYd8ZZtllD6N50BUZLmik6iMIX1MwMoQDyyY5Rsw0ZXzUVXSRTps/vKy
	 RTar95Hm6cSN/YRsNYA+Hqv4dCTzWBrSCKHWc5H0vz15elTIRpAXjFdagnT942OBRC
	 LWFiBS+PWI4dyM69nQjKHpKZ3yQoIIuclht9kjyg=
Date: Wed, 25 Sep 2024 03:02:44 -0700
To: mm-commits@vger.kernel.org,Liam.Howlett@Oracle.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-goto-complete-directly-on-a-pivot-of-0.patch added to mm-unstable branch
Message-Id: <20240925100244.E8EC4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: goto complete directly on a pivot of 0
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-goto-complete-directly-on-a-pivot-of-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-goto-complete-directly-on-a-pivot-of-0.patch

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
Subject: maple_tree: goto complete directly on a pivot of 0
Date: Wed, 11 Sep 2024 14:27:59 +0000

When we break the loop after assigning a pivot, the index i/j is not
changed.  Then the following code assign pivot, which means we do the
assignment with same i/j by mas_safe_pivot.

Since the loop condition is (i < piv_end), from which we can get i is less
than mt_pivots[mt].  It implies mas_safe_pivot() return pivot[i] which is
the same value we get in loop.

Now we can conclude it does a redundant assignment on a pivot of 0.  Let's
just go to complete to avoid it.

Link: https://lkml.kernel.org/r/20240911142759.20989-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-goto-complete-directly-on-a-pivot-of-0
+++ a/lib/maple_tree.c
@@ -1943,7 +1943,7 @@ static inline void mas_mab_cp(struct ma_
 	for (; i < piv_end; i++, j++) {
 		b_node->pivot[j] = pivots[i];
 		if (unlikely(!b_node->pivot[j]))
-			break;
+			goto complete;
 
 		if (unlikely(mas->max == b_node->pivot[j]))
 			goto complete;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

maple_tree-i-is-always-less-than-or-equal-to-mas_end.patch
maple_tree-goto-complete-directly-on-a-pivot-of-0.patch

