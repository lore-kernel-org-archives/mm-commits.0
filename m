Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A429335541
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025876; cv=none; b=SmaCHUy+G+LREMDLYMmA3Ql8SCewBx8fI8FBwZkaGaBFo/w57pj8qezBJTlqeRPuW1xt1YnPWYj7cWtuOxdp35IaNekvnU6FyzALZqE8aAxOEcn0xfdJN9sWQ30NspMUXtU3HYYs8xlEcrVxvRYpTBskwYbAgySorvHb4ybHAyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025876; c=relaxed/simple;
	bh=H/Nea50qVoBB/E7ygf6952T8bNpvLCwovT0O2XsVZpY=;
	h=Date:To:From:Subject:Message-Id; b=fkzX9DvZseTONcZ2aTZHDK3WSUZqSuWO15V64DviYHF24MyVFhSoCdCTYByJFskXc/20M+BXplXzvSZJcPdCYdW5TJfhMcZ9jAHaDZ7w2IhYQnOxzLQSZ0VbWmz4ygSY5zAmlyXU9DlqFupWlp7KqEBxCgui0ZmUTxhKpd/mRGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ywFgZFIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ywFgZFIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA90C4CEF1;
	Mon, 24 Nov 2025 23:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025876;
	bh=H/Nea50qVoBB/E7ygf6952T8bNpvLCwovT0O2XsVZpY=;
	h=Date:To:From:Subject:From;
	b=ywFgZFIeKnRYtrfS7D0J/HW94w52nGVim8YbK6HaP/miTaGyC5rjkxbitK57c9ow5
	 uRO+b02fuefqAIWeSej85XR8uyo7S/Wmt11en1g6aZyIqDV6aI+qRObvzbH1ms0pM/
	 2DiyG/junevCVUewgMfZw6CAUgocwbcT08lO33Cc=
Date: Mon, 24 Nov 2025 15:11:15 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,dan.carpenter@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch removed from -mm tree
Message-Id: <20251124231116.4DA90C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/sysfs-kunit: fix use after free on error path
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: mm/damon/tests/sysfs-kunit: fix use after free on error path
Date: Fri, 21 Nov 2025 16:36:38 +0300

Re-order these frees to avoid dereferencing "sysfs_target" after it has
been freed.

Link: https://lkml.kernel.org/r/aSBq5uSPIqsqH8zO@stanley.mountain
Fixes: ee131696794c ("mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/tests/sysfs-kunit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/tests/sysfs-kunit.h~mm-damon-tests-sysfs-kunit-fix-use-after-free-on-error-path
+++ a/mm/damon/tests/sysfs-kunit.h
@@ -76,8 +76,8 @@ static void damon_sysfs_test_add_targets
 	if (!ctx) {
 		kfree(sysfs_targets->targets_arr);
 		kfree(sysfs_targets);
-		kfree(sysfs_target);
 		kfree(sysfs_target->regions);
+		kfree(sysfs_target);
 		kunit_skip(test, "ctx alloc fail");
 	}
 
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are


