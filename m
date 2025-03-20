Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A71EA7DE
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 21:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505618; cv=none; b=jGpo7Pw/4Ee00LmiE3fUs01ip1ZP7gvVOcj9RQF9HriqMKTKjSuopLTC2+F+h/q4W2T70VcJ5KaxoJg5AigIBRx5Y+U6d917oamp5fqraGPO5xmNcmidqk/+HhkI0oDTReErm3Lzy5T5h7y/KdVStH4rcbF1iXsNQqo4EA75W6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505618; c=relaxed/simple;
	bh=v9Ej8uP4O8izZPTHZAVHd5rjrEFkUsD+nZqhPFxaw/o=;
	h=Date:To:From:Subject:Message-Id; b=Z/YMoIh4+JTsajxQACC9yWWhMJE8wvGJ7fWXFWSFyXszHdGp1R7W7VkRpNPX63R6KanmbPP/7Obb70B3EgVUi0CHsMPZscYquH1oF7d51e6aAnzmuj1LXUA1rt/zWBeBfHi9oUQvd4InVNMEmbVyWStrFL6fmsDDqKa+sbKrfmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rn37m9Y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rn37m9Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8D5C4CEDD;
	Thu, 20 Mar 2025 21:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742505618;
	bh=v9Ej8uP4O8izZPTHZAVHd5rjrEFkUsD+nZqhPFxaw/o=;
	h=Date:To:From:Subject:From;
	b=rn37m9Y1Nacv1NoAVYloxMGrynVGfvN71wY3zyXffB8gKMGBdbnDsgHfSa/2KGm4f
	 xI7FTDgk00j23J9jrqrX59Jj/UUZzx/VuAVsuRm8TXDhVijvEBOR5bPaXjffAGSfye
	 QeLrVrM5ZWU9xBVkY8tRxIvWKKA8h2b892fno1jQ=
Date: Thu, 20 Mar 2025 14:20:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,chentaotao@didiglobal.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-simplify-control-flow-in-damon_register_ops.patch added to mm-unstable branch
Message-Id: <20250320212018.3D8D5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: simplify control flow in damon_register_ops()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-simplify-control-flow-in-damon_register_ops.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-simplify-control-flow-in-damon_register_ops.patch

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

mm-damon-core-simplify-control-flow-in-damon_register_ops.patch

