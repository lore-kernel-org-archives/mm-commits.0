Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343132500AE
	for <mm-commits@vger.kernel.org>; Mon, 25 Nov 2024 04:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732509989; cv=none; b=Jr05EXA4kCELnMRVQr6FTZ9UGRE+1p2TyHRsuCjmyLxhU8lDlaoWNorELN3LvPcB1QQkBZJy8uHdfd0k1/guezxw7A1q3f2BZnJ9tTtg95LjZj8IV3PFwgwJhnKyU9VUZHke7vXqLo88ZKXkmSXhLY1M35o+9G+aNfpuIzIv/CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732509989; c=relaxed/simple;
	bh=JN2GIgh6Mb6oKByUG7qEbIZgfp6skMyMR5t+GOg0DAc=;
	h=Date:To:From:Subject:Message-Id; b=OCwqB5Z3fr/OUf6l4/vuHyq9jvu4D7ydlHyIJxpnAN6sSi2OPb/tBoWcxF06wTjI+7toj0PEitGCVr1hDHkxWkljlI4RZc7QB4LTwItXVyyS4dgKMFiXc65Ri8YMweFAPBaoCLYyBx1U40wopphuukkXGddJYVVGCsvkoYXFqNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dirAk86a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dirAk86a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79989C4CECE;
	Mon, 25 Nov 2024 04:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732509987;
	bh=JN2GIgh6Mb6oKByUG7qEbIZgfp6skMyMR5t+GOg0DAc=;
	h=Date:To:From:Subject:From;
	b=dirAk86aq8OuZZue1mnAJ+nD6faSMYxPbM3MkBC1SR2z1SlKvpQItCbi8s2+PVlFy
	 0RnFD1TLKmTTiHdX7H3tN67PuIqo/NuqaTpkgqfdaodhqQGTRcz2NSNvYilK85pgui
	 xTyAW0es1JbjrM4/ipEM99P/JNKGXb19RbxP4u2g=
Date: Sun, 24 Nov 2024 20:46:17 -0800
To: mm-commits@vger.kernel.org,pratyushmittal@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rhashtable-fix-the-typo-for-preemptible.patch added to mm-nonmm-unstable branch
Message-Id: <20241125044625.79989C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rhashtable: fix the typo for preemptible
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rhashtable-fix-the-typo-for-preemptible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rhashtable-fix-the-typo-for-preemptible.patch

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
From: Pratyush Mittal <pratyushmittal@gmail.com>
Subject: lib/rhashtable: fix the typo for preemptible
Date: Sat, 23 Nov 2024 02:29:29 -0800

Fix the spelling of the mis-spelled word

Link: https://lkml.kernel.org/r/20241123102929.11660-1-pratyushmittal@gmail.com
Signed-off-by: Pratyush Mittal <pratyushmittal@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rhashtable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/rhashtable.c~lib-rhashtable-fix-the-typo-for-preemptible
+++ a/lib/rhashtable.c
@@ -665,7 +665,7 @@ EXPORT_SYMBOL_GPL(rhashtable_insert_slow
  * structure outside the hash table.
  *
  * This function may be called from any process context, including
- * non-preemptable context, but cannot be called from softirq or
+ * non-preemptible context, but cannot be called from softirq or
  * hardirq context.
  *
  * You must call rhashtable_walk_exit after this function returns.
_

Patches currently in -mm which might be from pratyushmittal@gmail.com are

lib-rhashtable-fix-the-typo-for-preemptible.patch

