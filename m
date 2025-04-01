Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E5721C9F9
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545874; cv=none; b=ONAIrQO9U3J2LV9YGUUmYpgk6mS6KkBF13pqmKOYXRyI4GP+chL9FNqT9s1XKRV1FhMsi57hU1j4lfdOovhlR24iAp8UU0M+Pi4nEN9MT41zpVPBa/WlfP3MQxLBFYONtjEh23jM6llic2xyUUV0PLjCPTFEIMlJ8f14GoCochk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545874; c=relaxed/simple;
	bh=0iiEgVI5MeDj/WHVzVBB7hcqXuO0uvJgb5FjKtnIc5Q=;
	h=Date:To:From:Subject:Message-Id; b=oUSsRjbFqfbunnh9dtHZYyA5Y2ZrytYw5mFDMzYXmtZ7IGcUmTf415sdNSqo4+DW5k3KKAo88Q7joBXhNGowuWXu66mWmrfGLMCWuYA4iiDKRSBCifmBhOxhg3W2zyt9Wcwdw8Bv15qcmW6cxjli6WXp7NZXNZdTwL/azy/6JBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CEoviDCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CEoviDCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63117C4CEE9;
	Tue,  1 Apr 2025 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545874;
	bh=0iiEgVI5MeDj/WHVzVBB7hcqXuO0uvJgb5FjKtnIc5Q=;
	h=Date:To:From:Subject:From;
	b=CEoviDCVpm09JI73aCRaCAo9kPJzFP98Ep9x6a4bZ9N71zAZW7DGy+aD5ZS/Ul8FO
	 rTy7DZJKVDXCXINnpR7qasKAHOyMFVIKzAIv2jRMVnfViFSGIfULThYniH5XLFg4Kz
	 7vRuSmmlvUzuxWhQBXaSbADFAZLkOf5ECJaUfESk=
Date: Tue, 01 Apr 2025 15:17:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,chentaotao@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-simplify-control-flow-in-damon_register_ops.patch removed from -mm tree
Message-Id: <20250401221754.63117C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: simplify control flow in damon_register_ops()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-simplify-control-flow-in-damon_register_ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Taotao Chen <chentaotao@didiglobal.com>
Subject: mm/damon/core: simplify control flow in damon_register_ops()
Date: Thu, 20 Mar 2025 18:44:00 +0800

The function logic is not complex, so using goto is unnecessary.  Replace
it with a straightforward if-else to simplify control flow and improve
readability.

Link: https://lkml.kernel.org/r/Z9vxcPCw8tDsjKw1@OneApple
Signed-off-by: Taotao Chen <chentaotao@didiglobal.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-simplify-control-flow-in-damon_register_ops
+++ a/mm/damon/core.c
@@ -76,14 +76,13 @@ int damon_register_ops(struct damon_oper
 
 	if (ops->id >= NR_DAMON_OPS)
 		return -EINVAL;
+
 	mutex_lock(&damon_ops_lock);
 	/* Fail for already registered ops */
-	if (__damon_is_registered_ops(ops->id)) {
+	if (__damon_is_registered_ops(ops->id))
 		err = -EINVAL;
-		goto out;
-	}
-	damon_registered_ops[ops->id] = *ops;
-out:
+	else
+		damon_registered_ops[ops->id] = *ops;
 	mutex_unlock(&damon_ops_lock);
 	return err;
 }
_

Patches currently in -mm which might be from chentaotao@didiglobal.com are


