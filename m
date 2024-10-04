Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE541154C0C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 23:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728086250; cv=none; b=cgh/hd38r1RlL1WsIhRUGXkKqY3Fg2LVgtweZH1QkcdsZ6cYJv76LI7MrXvHVL0nTyH0FtPB0B1O8TwGPnhkTtVi8VAh+TuXjHI+AdFkAcboTZKepO/OMJRD/ZW1QFupuxXXdvclsTpG7tat+gEZ+lKZlhmIdFEg0zzFcDtevNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728086250; c=relaxed/simple;
	bh=rNo59V7fwY7v5e7i03qAA0/05atHPfwWjcvgyHsb4Dk=;
	h=Date:To:From:Subject:Message-Id; b=p1XLohLTz8L2MxzHNTUjVhJqtWtE33+MsvESAw23xkmInoqzIBn+WzMtKFWcwC1DchDlISjmav+UG1L3Swh9ARk029zefSLcphriaqv75jvx6hxrqjZdNnU3o59SKoniYzwe/JHAZv5F3qTycU4pbY2292SF+8q2wfYPXUo/L3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uL4fvKSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uL4fvKSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C0FC4CEC6;
	Fri,  4 Oct 2024 23:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728086250;
	bh=rNo59V7fwY7v5e7i03qAA0/05atHPfwWjcvgyHsb4Dk=;
	h=Date:To:From:Subject:From;
	b=uL4fvKSlXhHelar5fAjkKhlw07/9oqGtEO+zwZvhOBBKa22ToA1BQfwd0Ck+jNIDb
	 ZvmYLgsDh21HmQjvaWXxZRTXunudKM5cjvWzVc8JFVsDsjyd4P5UJ+vSebTKFNEqO9
	 J+SI9lt+ZZKMBUbxRPa3bwW1z1GA2oIjn1xAHfYk=
Date: Fri, 04 Oct 2024 16:57:29 -0700
To: mm-commits@vger.kernel.org,brunofrancadevsec@gmail.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] lib-math-fix-spelling-mistake-bsae-base.patch removed from -mm tree
Message-Id: <20241004235730.38C0FC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/math: fix spelling mistake "bsae" -> "base"
has been removed from the -mm tree.  Its filename was
     lib-math-fix-spelling-mistake-bsae-base.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: lib/math: fix spelling mistake "bsae" -> "base"
Date: Mon, 30 Sep 2024 08:47:36 +0100

There is a spelling mistake in a literal string. Fix it.

Link: https://lkml.kernel.org/r/20240930074736.48878-1-colin.i.king@gmail.com
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Bruno Sobreira França <brunofrancadevsec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/math/tests/int_log_kunit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/math/tests/int_log_kunit.c~lib-math-fix-spelling-mistake-bsae-base
+++ a/lib/math/tests/int_log_kunit.c
@@ -24,7 +24,7 @@ static const struct test_case_params int
 
 static const struct test_case_params intlog10_params[] = {
 	{0, 0, "Log base 10 of 0"},
-	{1, 0, "Log bsae 10 of 1"},
+	{1, 0, "Log base 10 of 1"},
 	{6, 13055203, "Log base 10 of 6"},
 	{10, 16777225, "Log base 10 of 10"},
 	{100, 33554450, "Log base 10 of 100"},
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


