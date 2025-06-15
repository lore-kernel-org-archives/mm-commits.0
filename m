Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F9F33086
	for <mm-commits@vger.kernel.org>; Sun, 15 Jun 2025 21:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750023436; cv=none; b=K1d6LAf8UKE9CnWVzFIpvZpxoiAwf23WWn8EFc2HpZUG0RWXRXpZCUGATDdM/0t4XvFcyj6vpi9vvHy+ahC4Lu3V0SpqZZIFmGzkdb3gr5HD2WagXGclkLr07r/kYohlRa7770W4vQxKUAq5SJwkvf0/kwBxyp0b5DOW9eknxZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750023436; c=relaxed/simple;
	bh=/y5iVgvm+hTN1budEd/JOQfh4SHQ/j/xLf96AmQSwIM=;
	h=Date:To:From:Subject:Message-Id; b=MfbKS/rQyEKJ3avzmVrQ4nA6mBsWNm/0VB/rCJ7Rgdra5p2m6YDeSnJbivbU/V4X9of33Ezf3kyVW286ECpr5Mj78w1nFRlmzv58dkblsvmmLmmHd6cCHdwfUDY2UxezG6O4LDDJYdk5zjUduXZBGZz0Aq46DxyDn0rVwxJ/l14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hxZiA9jh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hxZiA9jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B7C4CEE3;
	Sun, 15 Jun 2025 21:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750023435;
	bh=/y5iVgvm+hTN1budEd/JOQfh4SHQ/j/xLf96AmQSwIM=;
	h=Date:To:From:Subject:From;
	b=hxZiA9jhqRnb3mKwUU6Qd4nFoeNfDGV/Rgs4KC8aFN+Q9Mp+u3jECjqDwPzbe4dbk
	 MTrgMwTqhhZqfs226rFmykovCEfgBY5EsfdJO7mrLz5n/+VU1bIei2gMRKS/xynNIC
	 SY/KDfuooOkWsnqTnJ9YXVdS4vvm1i+FeWa6UhxI=
Date: Sun, 15 Jun 2025 14:37:14 -0700
To: mm-commits@vger.kernel.org,elver@google.com,andreyknvl@gmail.com,n9winx@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch added to mm-nonmm-unstable branch
Message-Id: <20250615213715.5D1B7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kcov: fix typo in comment of kcov_fault_in_area
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch

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

kcov-fix-typo-in-comment-of-kcov_fault_in_area.patch

