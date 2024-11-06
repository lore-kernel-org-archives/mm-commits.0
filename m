Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA2F1311AC
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854700; cv=none; b=cPsszCWJ8OiBEVVi1w2R+pu7tpwYx1Gj6cGgTp0Jt+qZKHEss7DNYxHNMSpjJ7r4vEINyX/GAB4QgmFYhtCMfs8hZsBAsOKyjcbfG44r5v3By7XewNDkh/ef7yjE1k7j/8GL8hYAhqbfvFVZKdvwTmPqxFjkL4gD6pS4OFYvp2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854700; c=relaxed/simple;
	bh=/NWyr1uEGfoLsXXKrZyBTO2T3VQj/twsUpvjgXOTRvA=;
	h=Date:To:From:Subject:Message-Id; b=b14Sl+51GUXVyhpN5uQsbopAmiDz2ZdBrm25xARXjAqJb7v6FTW4pPr5EVbrsUrLDgsmkbOveVgVQ7ZAa50ro3LQCoBGOwuI+O5U2HkE4U/MKx/onNSqtHew3OYsOS3mPK6kcvoMPHu+qFH/rvUcRt1/ot+g9dWNp06t6ufJINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AzHh6FLJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AzHh6FLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B09C4CECF;
	Wed,  6 Nov 2024 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854699;
	bh=/NWyr1uEGfoLsXXKrZyBTO2T3VQj/twsUpvjgXOTRvA=;
	h=Date:To:From:Subject:From;
	b=AzHh6FLJQ2zkAqLWMHacFt7KrDfhHuYsDBFTFpxq1rldJofGgfiJcsNfE0WkWnGF4
	 J6cuTMT7lU/lGljkzicEWWoNQVZpn2vZo4XO5eDteT+vygrBcdSjWIaQhnCiOAORJi
	 oZzThl539H78XISwt+Z+E9Q73hkyArBqjtHl6eDQ=
Date: Tue, 05 Nov 2024 16:58:18 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,ruanjinjie@huawei.com,leocstone@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fix-sparse-warning-for-zero-initializer.patch removed from -mm tree
Message-Id: <20241106005819.31B09C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fix sparse warning for zero initializer
has been removed from the -mm tree.  Its filename was
     mm-damon-fix-sparse-warning-for-zero-initializer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leo Stone <leocstone@gmail.com>
Subject: mm/damon: fix sparse warning for zero initializer
Date: Sun, 22 Sep 2024 19:25:18 -0700

sparse warns about zero initializing an array with {0,}, change it to
the equivalent {0}.

Fixes the sparse warning:
mm/damon/tests/vaddr-kunit.h:69:47: warning: missing braces around initializer

Link: https://lkml.kernel.org/r/xriwklcwjpwcz7eiavo6f7envdar4jychhsk6sfkj5klaznb6b@j6vrvr2sxjht
Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Signed-off-by: Leo Stone <leocstone@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/vaddr-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/vaddr-kunit.h~mm-damon-fix-sparse-warning-for-zero-initializer
+++ a/mm/damon/tests/vaddr-kunit.h
@@ -66,7 +66,7 @@ failed:
 static void damon_test_three_regions_in_vmas(struct kunit *test)
 {
 	static struct mm_struct mm;
-	struct damon_addr_range regions[3] = {0,};
+	struct damon_addr_range regions[3] = {0};
 	/* 10-20-25, 200-210-220, 300-305, 307-330 */
 	struct vm_area_struct vmas[] = {
 		(struct vm_area_struct) {.vm_start = 10, .vm_end = 20},
_

Patches currently in -mm which might be from leocstone@gmail.com are


