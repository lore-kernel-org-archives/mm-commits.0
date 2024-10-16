Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2638A1D2715
	for <mm-commits@vger.kernel.org>; Wed, 16 Oct 2024 22:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729117057; cv=none; b=uWgoYJBRAyCye+Sctygb8iyTyLGztPtQ9E7yC0NE6bGPUXmaaDSp8j4aW8oxVfihQKOUPtLs+g14bL+Gasvj6GYqLqPg3iC6/Fq/guQYvYb74rsRWDM1abS7t2ARwYsNEP4w2r0bE7N8CUObMFVl9Fs9IRdwpm9OjMBCRohvPyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729117057; c=relaxed/simple;
	bh=uhKUkMsK6/VeVgbi3o9V1Lq7Z4zV40rHTcXwCwK/ZZY=;
	h=Date:To:From:Subject:Message-Id; b=AQY8LobHVEXwXwlXMF0f5RnYMweDP/+Y80s3o6ymbZYbIFfKrJ6l0NbNAY+OkiBL3yg/FIXegNSv9Ic5cQELb4aPqVY7iuJgrbio+UhcHMuj+bq0AhnBqF1tmZ9Ul3vo7SctpbVh+XnAC677WEV8M1GWwvEqdNw59J2r2fxCAAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kk90uOdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kk90uOdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B8BC4CEC5;
	Wed, 16 Oct 2024 22:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729117056;
	bh=uhKUkMsK6/VeVgbi3o9V1Lq7Z4zV40rHTcXwCwK/ZZY=;
	h=Date:To:From:Subject:From;
	b=kk90uOdAc92XZqWT7ipDSzKX1OtAwh1p49Y28ql82e8FnfJCwYLBz3sNHrI2nWz/n
	 6P9QM6iU3kuLwMpzbwd0/A3+9pGK1GQk7M9KV06PWPXA4JMwwiJwOX9jngVhz23AkD
	 L/nMs++wA3U+ojhb6IIUtd6NrEh1JdUkFQUtmUYs=
Date: Wed, 16 Oct 2024 15:17:36 -0700
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-use-str_true_false-helper-function.patch added to mm-unstable branch
Message-Id: <20241016221736.97B8BC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: use str_true_false() helper function
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-use-str_true_false-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-str_true_false-helper-function.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm: swap: use str_true_false() helper function
Date: Wed, 16 Oct 2024 16:10:41 +0200

Remove hard-coded strings by using the helper function str_true_false().

Link: https://lkml.kernel.org/r/20241016141040.79168-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap-use-str_true_false-helper-function
+++ a/mm/swap_state.c
@@ -889,8 +889,7 @@ struct folio *swapin_readahead(swp_entry
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%s\n",
-			  enable_vma_readahead ? "true" : "false");
+	return sysfs_emit(buf, "%s\n", str_true_false(enable_vma_readahead));
 }
 static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 				      struct kobj_attribute *attr,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-swap-use-str_true_false-helper-function.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

