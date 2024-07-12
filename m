Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82C212FF8B
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824913; cv=none; b=WE76Y3AAg1Ospwke29rJg0YgA2ogyfYL2PO0obAiG71wov2vScPAhBFUSCPxYOwxDfqNHYNXtXI3UXCiuk3Jkqb6zkS8ZJNhiy7VtPRXJlY8kQOHS8MvAzelct2bgm50OdcnZlcUe5fsQS8N5a/h7PxBVpvJH8b4vWHjG3W9y9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824913; c=relaxed/simple;
	bh=vf411jJiS+BALpEoUzyImCxMzC60kbYvpCxU1KfOjdQ=;
	h=Date:To:From:Subject:Message-Id; b=jfgLtNtBRh7Uk1UrqwEejMKmyISfq5g4LUL2Fso0g0U8bTOL9rkAUy8BFNTT54DvtdqO/GOJ6Eeeb2VlizKj8PBsuR3zv7pfdfuJN8qK2/TVUnPAAVVlwnryjlVwnFvxbyMrj1QsDAl86BIqua0dlOvM/5EpGfkxdJAY+Qgta04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MtHF0Chx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MtHF0Chx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40B7C32782;
	Fri, 12 Jul 2024 22:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824913;
	bh=vf411jJiS+BALpEoUzyImCxMzC60kbYvpCxU1KfOjdQ=;
	h=Date:To:From:Subject:From;
	b=MtHF0Chx/o59bYOSIwL9vtlOXCLRANaZ8LQb56R+zA5N+MZjKdL4GPMiomO+8dyv6
	 ItlsU7b+r2Bcq5UvNm2uCngXT5CY7sZnrLfKppg7po3YrUx6cxl1JmZjVAUwRypHgw
	 5lbaCnILNVB//rHVPkfC+Ne2SzV2o+Bs4S/oV0r8=
Date: Fri, 12 Jul 2024 15:55:13 -0700
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,kees@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmemleak-replace-strncpy-with-strscpy.patch removed from -mm tree
Message-Id: <20240712225513.A40B7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kmemleak: replace strncpy() with strscpy()
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-replace-strncpy-with-strscpy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <kees@kernel.org>
Subject: mm/kmemleak: replace strncpy() with strscpy()
Date: Tue, 9 Jul 2024 17:13:08 -0700

Replace the depreciated[1] strncpy() calls with strscpy().  Uses of
object->comm do not depend on the padding side-effect.

Link: https://github.com/KSPP/linux/issues/90 [1]
Link: https://lkml.kernel.org/r/20240710001300.work.004-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-replace-strncpy-with-strscpy
+++ a/mm/kmemleak.c
@@ -657,10 +657,10 @@ static struct kmemleak_object *__alloc_o
 	/* task information */
 	if (in_hardirq()) {
 		object->pid = 0;
-		strncpy(object->comm, "hardirq", sizeof(object->comm));
+		strscpy(object->comm, "hardirq");
 	} else if (in_serving_softirq()) {
 		object->pid = 0;
-		strncpy(object->comm, "softirq", sizeof(object->comm));
+		strscpy(object->comm, "softirq");
 	} else {
 		object->pid = current->pid;
 		/*
@@ -669,7 +669,7 @@ static struct kmemleak_object *__alloc_o
 		 * dependency issues with current->alloc_lock. In the worst
 		 * case, the command line is not correct.
 		 */
-		strncpy(object->comm, current->comm, sizeof(object->comm));
+		strscpy(object->comm, current->comm);
 	}
 
 	/* kernel backtrace */
_

Patches currently in -mm which might be from kees@kernel.org are

tsacct-replace-strncpy-with-strscpy.patch

