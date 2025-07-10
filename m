Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4682B286D56
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127160; cv=none; b=eL5T4dVl54tDziLZyPkuaeoOIOxwA3bu6w0TyWsEqLy2HG9uBlwiNkVczTwzjUC1Dsv6o6MkBKqcRadkGrxaQjrwK1hq61TaesoTijLJV6xtXd6u0DZikmmFBL2oCrkMSjOU5/EGk4MR9bhdQ76Fp4UY/iaUOMfuL4v6DDSQfes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127160; c=relaxed/simple;
	bh=7NqwdM035jCUIqbFCQbvv1OP5CeUCeBAHKfswYL0hvg=;
	h=Date:To:From:Subject:Message-Id; b=QTDTnqXaYkQWrHZJK9rSXcgYNW4bDzN8QSnnGCN88iBYelz72azfeG1gvlX4yNaEAeAf3lA/5bvi/4o3R42cKyIA8jfiis6+P/LEqPWT2itHnopxSZmOtJiz4yxzDWq57TybS2RAvb2QR1FUSPNvm0zW7D+wJ9/cJ4TDk0lh+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQV1JuHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQV1JuHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A752C4CEE3;
	Thu, 10 Jul 2025 05:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752127160;
	bh=7NqwdM035jCUIqbFCQbvv1OP5CeUCeBAHKfswYL0hvg=;
	h=Date:To:From:Subject:From;
	b=WQV1JuHFMZcRkXOvCERA8Pdvp5PFqgZ7/HWGBG8SEc8aoFJOuxhdw9OiA8IPxPm8Z
	 UMZg/CB1QfjCGPVrE5/S2CW4vKX7ESFXRKddzqL4kc9HsrSH2UcACKlqEU+FG7LZ5W
	 +ziN7t1I6sRarElAm6+LvgkgclymSLja5xzVE4IU=
Date: Wed, 09 Jul 2025 22:59:19 -0700
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@gmail.com,n9winx@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch removed from -mm tree
Message-Id: <20250710055920.1A752C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: fix typo in comment of kcov_fault_in_area
has been removed from the -mm tree.  Its filename was
     kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Nanxin <n9winx@163.com>
Subject: kcov: fix typo in comment of kcov_fault_in_area
Date: Sun, 15 Jun 2025 20:32:37 +0800

change '__santizer_cov_trace_pc()' to '__sanitizer_cov_trace_pc()'

Link: https://lkml.kernel.org/r/20250615123237.110144-1-n9winx@163.com
Signed-off-by: Wei Nanxin <n9winx@163.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Macro Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kcov.c~kcov-fix-typo-in-comment-of-kcov_fault_in_area
+++ a/kernel/kcov.c
@@ -552,7 +552,7 @@ static int kcov_get_mode(unsigned long a
 
 /*
  * Fault in a lazily-faulted vmalloc area before it can be used by
- * __santizer_cov_trace_pc(), to avoid recursion issues if any code on the
+ * __sanitizer_cov_trace_pc(), to avoid recursion issues if any code on the
  * vmalloc fault handling path is instrumented.
  */
 static void kcov_fault_in_area(struct kcov *kcov)
_

Patches currently in -mm which might be from n9winx@163.com are


