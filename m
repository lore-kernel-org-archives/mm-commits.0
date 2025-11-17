Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EC71A3179
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343205; cv=none; b=gaQWnONjeim8EQYyK38SVaxqgFMW4Xh6SBz7fFBS5n30IYGj2Q915xXcYyzImzDMmmAk+JuEhGhEzXTWfFDZy/4xkWfZux9HQDm8aT/+Bk8Yf3ZUZM/FEE1UFqnYsbecvMGML+pcNaMjRcrmX6pPju0pgRucprCJzivQ2IsSyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343205; c=relaxed/simple;
	bh=h1GgTh/NAF4Hsn+Nhc8vcFqYAIiMYoX2wGSIH5PCnnc=;
	h=Date:To:From:Subject:Message-Id; b=hHajev24gYlmFGegzMfbIgEsLD92bIFeMHH18hPyAo3dxeoI8wCAjACyg3K9jBRA3wk99BzupGI6N07YrOI2ryrMX/SvpUJjb0HveH/jDBIFL6+I2GjGU+Txccs5jAmZLrWAFMHqyQWLLvVDHXs0tspuzgrdYti4osz5uGFGTDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oYXszwea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oYXszwea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB49C113D0;
	Mon, 17 Nov 2025 01:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343205;
	bh=h1GgTh/NAF4Hsn+Nhc8vcFqYAIiMYoX2wGSIH5PCnnc=;
	h=Date:To:From:Subject:From;
	b=oYXszweaUS0emsyli4FH8njuq9zNQl5d32rU12MdNLEe3FOUfOdRZHTzFIxgfzmlZ
	 xo0ntAFeqeGxhaoo5eqm5QRCiJJWeUt1Wqqk2JWZTwUDYUsqE2rkm1F9goiImDMjpD
	 WAoENCQZ1Av+w3Gz2ZqyPLaTyG0ebk+spkUthpZg=
Date: Sun, 16 Nov 2025 17:33:24 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,david.hunter.linux@gmail.com,swarajgaikwad1925@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch removed from -mm tree
Message-Id: <20251117013325.0AB49C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove misleading todo comment in nid_show()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Subject: mm/damon/sysfs: remove misleading todo comment in nid_show()
Date: Tue, 21 Oct 2025 21:53:24 +0000

The TODO comment in nid_show() suggested returning an error if the goal
was not using nid.  However, this comment was found to be inaccurate and
misleading.This patch removes the TODO comment without changing any
existing behavior.

This change follows feedback from SJ who pointed out [1] that wiring-order
independence is expected and the function should simply show the last set
value.  and [2] checkpatch.pl complain about number of chars per line

No functional code changes were made.

Tested with KUnit:
- Built kernel with KUnit and DAMON sysfs tests enabled.
- Executed KUnit tests:
  ./tools/testing/kunit/kunit.py run --kunitconfig ./mm/damon/tests/
- All 25 tests passed, including damon_sysfs_test_add_targets.

Link: https://lkml.kernel.org/r/20251021215323.29734-2-swarajgaikwad1925@gmail.com
Link: https://lore.kernel.org/lkml/20251020151315.66260-1-sj@kernel.org/ [1]
Link: https://lore.kernel.org/lkml/20251021010847.68473-1-sj@kernel.org/ [2]
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-remove-misleading-todo-comment-in-nid_show
+++ a/mm/damon/sysfs-schemes.c
@@ -1121,7 +1121,6 @@ static ssize_t nid_show(struct kobject *
 	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
 			damos_sysfs_quota_goal, kobj);
 
-	/* todo: return error if the goal is not using nid */
 
 	return sysfs_emit(buf, "%d\n", goal->nid);
 }
_

Patches currently in -mm which might be from swarajgaikwad1925@gmail.com are


