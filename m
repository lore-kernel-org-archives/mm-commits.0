Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79490392836
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068075; cv=none; b=UV8IE1bc90RVrDSINLfggAGd7VNlpIDqSMgF21u41N4hVAcP4RWqrcQ13IMEBNQiLudiBrQqzX1V7Oi3Odw++SmAimVibZkt1kpzzbklgIk86vOeMHP24P3VBmWCePjacXUn9F9yyfoY10lWYFoUYbHkYNY6duedU4mMeXg73w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068075; c=relaxed/simple;
	bh=IKc3T87mngaW8BmVuey4ytL93VxDM2Dr+uEiZ4z4igM=;
	h=Date:To:From:Subject:Message-Id; b=uUaEMffBEHkxnlkZy8ESTDui487Y5PEK2iWAvv6HtKnToN9ENtSjgmAqc2wVYPY8nXm3VBQH3E7EnPwSdXf4iH2D+sAluMmhMzfZc8/E9lQmBiCtMEECQ5XfeWma/MLuGLUcgzZm1PRpzGgPrxz2jC8ibXL99nCEIOqFMY5lU1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JURFzmyM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JURFzmyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E5D1F00A3F;
	Fri,  7 Aug 2026 02:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068071;
	bh=B6IwpkccVsxzZf61nAUn+t0tgGbgc/Ftj/Wl7NhzdZg=;
	h=Date:To:From:Subject;
	b=JURFzmyMcsK7qASQXQHIVRYqfcrgVfVvjybSfn+00N3KB1lzvv84OcQiY3wYLblIV
	 RWj6mX2nivU837vS1K010YmaNc8ZcEXYhW/tbZqNIQJMN8Omb2XeIQGj9boC9WvsNQ
	 810uwww59FGkardWzF8iieTL6+Lw6/FvCGDYgj3M=
Date: Thu, 06 Aug 2026 19:01:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch removed from -mm tree
Message-Id: <20260807020111.12E5D1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: do not directly access damon_ctx->ops
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: do not directly access damon_ctx->ops
Date: Tue, 14 Jul 2026 07:35:42 -0700

damon_ctx->ops field is intended to be used by only the DAMON core layer. 
DAMON_SYSFS is directly reading the field to find if it is for physical
address monitoring, though.  Use the API function for the purpose,
damon_target_has_pid(), instead.

Link: https://lore.kernel.org/20260714143544.101305-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-do-not-directly-access-damon_ctx-ops
+++ a/mm/damon/sysfs.c
@@ -2051,7 +2051,7 @@ static int damon_sysfs_add_targets(struc
 	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
-	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+	if (!damon_target_has_pid(ctx) && sysfs_targets->nr > 1)
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
_

Patches currently in -mm which might be from sj@kernel.org are


