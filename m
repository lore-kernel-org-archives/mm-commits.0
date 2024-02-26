Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC70B131750
	for <mm-commits@vger.kernel.org>; Mon, 26 Feb 2024 22:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708985654; cv=none; b=npWVBuqdP+3aPzvdTnrk/kw/W8BUwlrJZb+PilEL0AZtV3vcZVcpqgonRC73tGX4SJtHYR2zgmkdiQyGZhtehUS1hh/81VAOMvQnOzB7+Xh8MQwJb/Zgu4ms9KYIbUYdM3z2ejLOKTLMSu3YQdQ58bW9cRb7GYck2c7e6ZaVUY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708985654; c=relaxed/simple;
	bh=eEyJKq1bSzQXHt5+t2rdboeASdYBSPa73EkpyQbzWDA=;
	h=Date:To:From:Subject:Message-Id; b=YJ6IWIuPlKyoVWx482SgJDkWD45uChWeOrnTWWuxqyPH9Co4pGSrKKFjvqTt4/Fy0QFwCjNFpL0cZc8oePTjsVwuvCj4xJQm3+P79G+plWw9Z1A27mq6msy5avmFfxg8hZGDGNX2RleL3Omf1WUCpD3tKQYWj254mEXVP0Z0HiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sEaWvTGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sEaWvTGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E59C433F1;
	Mon, 26 Feb 2024 22:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708985654;
	bh=eEyJKq1bSzQXHt5+t2rdboeASdYBSPa73EkpyQbzWDA=;
	h=Date:To:From:Subject:From;
	b=sEaWvTGlaYX0cnc9hqlY/cfVjPf9vRa4WN4tCr9mEwsqY6KXcPJxtiJo+OiKOcp44
	 3sUh8fQE4CuAw3LkwNIgmtUhQWQtwIdXNC7ZN+x/JpGk5o8yhyGjFvAaf1QyDlxZyh
	 6FL3qvaeoj+g55Y205AFF2O20u2kCX16BhfC+gRI=
Date: Mon, 26 Feb 2024 14:14:13 -0800
To: mm-commits@vger.kernel.org,urezki@gmail.com,martin@kaiser.cx,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-use-unsigned-long-constant.patch added to mm-nonmm-unstable branch
Message-Id: <20240226221414.38E59C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc.c: use unsigned long constant
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-test_vmallocc-use-unsigned-long-constant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-use-unsigned-long-constant.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Martin Kaiser <martin@kaiser.cx>
Subject: lib/test_vmalloc.c: use unsigned long constant
Date: Mon, 26 Feb 2024 20:11:59 +0100

Use an unsigned long constant instead of an int constant and a cast.  This
fixes the checkpatch warning

WARNING: Unnecessary typecast of c90 int constant - '(unsigned long) 1' could be '1UL'
+     align = ((unsigned long) 1) << i;

Link: https://lkml.kernel.org/r/20240226191159.39509-4-martin@kaiser.cx
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-use-unsigned-long-constant
+++ a/lib/test_vmalloc.c
@@ -117,7 +117,7 @@ static int align_shift_alloc_test(void)
 	int i;
 
 	for (i = 0; i < BITS_PER_LONG; i++) {
-		align = ((unsigned long) 1) << i;
+		align = 1UL << i;
 
 		ptr = __vmalloc_node(PAGE_SIZE, align, GFP_KERNEL|__GFP_ZERO, 0,
 				__builtin_return_address(0));
_

Patches currently in -mm which might be from martin@kaiser.cx are

lib-test_vmallocc-fix-typo-in-function-name.patch
lib-test_vmallocc-drop-empty-exit-function.patch
lib-test_vmallocc-use-unsigned-long-constant.patch

