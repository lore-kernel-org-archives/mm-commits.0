Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE928C07
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600558; cv=none; b=jvbh3XVCYQpfL6LybnX2ceR5adHLsdyUaFfJirRFORI+wdQ9Cf7a0FIxd1hP5zA6mSqaQvcVMaFy+sIqGxnRixIX1U6DSmXiTJxKOp5C+Gdox4bHu26FpAtGrW7RHoNuQCMd1AMzSxkKQVSjYSz/SRB7vzHN23Jfdd6lBOi6c4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600558; c=relaxed/simple;
	bh=yL73nldMRh//ugQy3gDOvCoC7LGxJUdRK99cMoz7lbM=;
	h=Date:To:From:Subject:Message-Id; b=VFshva/ZJZXyo1TcjbOsXA8Y2BShEYHZDsmokCxwTe3wq/sE0EXpq1ibZqWQqWP5ouNLOhn1/aD8fYcWsvxCbR60na0Mav/AU2UggO6b1yEJI5eDPuCkiSPg29NKLoM5VBLAGxuoFMEWMIsLnQ+QHQHvY/BHl/qTkZm3tAnveI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dxkoHYkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dxkoHYkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8B2C433F1;
	Tue,  5 Mar 2024 01:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600557;
	bh=yL73nldMRh//ugQy3gDOvCoC7LGxJUdRK99cMoz7lbM=;
	h=Date:To:From:Subject:From;
	b=dxkoHYkTNVOPgbjtNK8SlAvUWcDhQK1LiNz4Ou7joeH6NqJER20/b0ImF/VPpvnl+
	 pPDoOJZ0Dw++ZFaiuqBgyywkx34bZg8mUXjz6e+uZyJmQ7UnlgIu26UtBuE5m4CZ56
	 rx94eJr4EStMoYIvhD7qf8tUnwk1nLT3gdknKQzM=
Date: Mon, 04 Mar 2024 17:02:37 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-fix-typo-in-function-name.patch removed from -mm tree
Message-Id: <20240305010237.CC8B2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: fix typo in function name
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-fix-typo-in-function-name.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Kaiser <martin@kaiser.cx>
Subject: lib/test_vmalloc.c: fix typo in function name
Date: Mon, 26 Feb 2024 20:11:57 +0100

Fix a typo and change the function name to init_test_configuration.  Both
caller and definition have the same typo, so the current code already
works.

Link: https://lkml.kernel.org/r/20240226191159.39509-2-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-fix-typo-in-function-name
+++ a/lib/test_vmalloc.c
@@ -501,7 +501,7 @@ static int test_func(void *private)
 }
 
 static int
-init_test_configurtion(void)
+init_test_configuration(void)
 {
 	/*
 	 * A maximum number of workers is defined as hard-coded
@@ -531,7 +531,7 @@ static void do_concurrent_test(void)
 	/*
 	 * Set some basic configurations plus sanity check.
 	 */
-	ret = init_test_configurtion();
+	ret = init_test_configuration();
 	if (ret < 0)
 		return;
 
_

Patches currently in -mm which might be from martin@kaiser.cx are


