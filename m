Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B425D1E9
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773183750; cv=none; b=Tk4lnwrKON6AYSAwrG5wQeIF5VHisb132JsXa0k2aaASKMoQu6UJ2vdrTPG1cPbUOyoxT0+qU2dFM0c0DkIwkFc4hha3YVYz+hAUqkHntUmnwqafUSsUtnUm9knejN2SYA7N9ORof4zB65FIQCNG1YfBHL5uWzX8AUMGz3arfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773183750; c=relaxed/simple;
	bh=roSeLMo0z7iIbOyvP6iC74R9RrPOW5dHSVKsM1bgSTg=;
	h=Date:To:From:Subject:Message-Id; b=SFlDcovRAwSsGawI7oJD8ePkioRmqljInr1rKudQf+Nue81iMmz5HWvszrHzfd9qjupS65ygVe7PQ+Xf6dj7F+3fMDu4ajWyJHcffmYtG4R90viSJUzPmU1104DSqSgJsL5+rqk5N44cKxwCmAq/47il6aKVS27w+onJXbJCJQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LDDfjaKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LDDfjaKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E4C19425;
	Tue, 10 Mar 2026 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773183750;
	bh=roSeLMo0z7iIbOyvP6iC74R9RrPOW5dHSVKsM1bgSTg=;
	h=Date:To:From:Subject:From;
	b=LDDfjaKRWYNwKF2CDf9kHRFjRkHZZA2KIw/FiAWP1jUMAlE+IJWLF70fm8QpU+HM7
	 iwezpcJuSDHNPTV3do6ZWC6lP2PC9gmmjaX/GKEpKRfoId3AydpOFqYlSLTrwrPb7g
	 86lM7phidM3cZ9+rhMAg9ME9rGocF5ABxtEisG8g=
Date: Tue, 10 Mar 2026 16:02:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] build_bugh-correct-function-parameters-names-in-kernel-doc.patch removed from -mm tree
Message-Id: <20260310230230.426E4C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: build_bug.h: correct function parameters names in kernel-doc
has been removed from the -mm tree.  Its filename was
     build_bugh-correct-function-parameters-names-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: build_bug.h: correct function parameters names in kernel-doc
Date: Sun, 1 Mar 2026 16:51:44 -0800

Use the correct function (or macro) names to avoid kernel-doc warnings:

Warning: include/linux/build_bug.h:38 function parameter 'cond' not
 described in 'BUILD_BUG_ON_MSG'
Warning: include/linux/build_bug.h:38 function parameter 'msg' not
 described in 'BUILD_BUG_ON_MSG'
Warning: include/linux/build_bug.h:76 function parameter 'expr' not
 described in 'static_assert'

Link: https://lkml.kernel.org/r/20260302005144.3467019-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/build_bug.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/build_bug.h~build_bugh-correct-function-parameters-names-in-kernel-doc
+++ a/include/linux/build_bug.h
@@ -32,7 +32,8 @@
 /**
  * BUILD_BUG_ON_MSG - break compile if a condition is true & emit supplied
  *		      error message.
- * @condition: the condition which the compiler should know is false.
+ * @cond: the condition which the compiler should know is false.
+ * @msg: build-time error message
  *
  * See BUILD_BUG_ON for description.
  */
@@ -60,6 +61,7 @@
 
 /**
  * static_assert - check integer constant expression at build time
+ * @expr: expression to be checked
  *
  * static_assert() is a wrapper for the C11 _Static_assert, with a
  * little macro magic to make the message optional (defaulting to the
_

Patches currently in -mm which might be from rdunlap@infradead.org are


