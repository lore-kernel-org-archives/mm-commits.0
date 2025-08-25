Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458D1514E4
	for <mm-commits@vger.kernel.org>; Mon, 25 Aug 2025 23:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756163025; cv=none; b=YGtk7knYVUKj2gYu0qOeGb+0VwJ0uZtT0RJsvCay5lglFNuYTe+obSY5+HLBpGeq9t48kbIPIJRIEE1/ga0cYqrHLdD9UjaOtFyhJPlNeonTLPsTju3DphqY0j7Xv79S3w/1U5VVTeJ6J/ARSZ35UgZng83ELfu6vOTlSb1VLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756163025; c=relaxed/simple;
	bh=vfI+LnIQNuEpCSusL8W8IiKNXD+G39XkieKgrnwCCjg=;
	h=Date:To:From:Subject:Message-Id; b=RB/t3RHkXV4tJgrJ0P+5HGjadsY/6Z3DhqTpAqwJ4AMZ4bo8Km8XOrldgC92jbhlsfEbhL+yymkXdcoyUDmE+eO5GHJeFbQTccVeDUJvqt27dXokJj5uCNpKuPMVn01PnSxzxnzd1Hc6t2bqIMXfl1uX7flas75rXhWrWqlksCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TMOUEEFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TMOUEEFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9068C4CEED;
	Mon, 25 Aug 2025 23:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756163025;
	bh=vfI+LnIQNuEpCSusL8W8IiKNXD+G39XkieKgrnwCCjg=;
	h=Date:To:From:Subject:From;
	b=TMOUEEFvVNBMVBCsNy9kktKwVMySwXZTMOkpyTrVkd4gV17AF+DvYf2kHHlR6G33U
	 MBiyFDZnx3W0pRhpSM1kuM/W1U2BeIgWaZMZNq14xczOQ2j5NK5FKVWs8ySKGFC5pZ
	 ArP738RuHGcYbfWkJdAXg8lp/foLs/S0fM1izarI=
Date: Mon, 25 Aug 2025 16:03:44 -0700
To: mm-commits@vger.kernel.org,liaoyuanhong@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_core-remove-redundant-0-value-initialization.patch added to mm-nonmm-unstable branch
Message-Id: <20250825230344.E9068C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_core: remove redundant 0 value initialization
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec_core-remove-redundant-0-value-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_core-remove-redundant-0-value-initialization.patch

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
From: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: kexec_core: remove redundant 0 value initialization
Date: Mon, 25 Aug 2025 20:33:05 +0800

The kimage struct is already zeroed by kzalloc(). It's redundant to
initialize image->head to 0.

Link: https://lkml.kernel.org/r/20250825123307.306634-1-liaoyuanhong@vivo.com
Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/kexec_core.c~kexec_core-remove-redundant-0-value-initialization
+++ a/kernel/kexec_core.c
@@ -233,7 +233,6 @@ struct kimage *do_kimage_alloc_init(void
 	if (!image)
 		return NULL;
 
-	image->head = 0;
 	image->entry = &image->head;
 	image->last_entry = &image->head;
 	image->control_page = ~0; /* By default this does not apply */
_

Patches currently in -mm which might be from liaoyuanhong@vivo.com are

maple_tree-remove-redundant-semicolons.patch
lib-digsig-remove-unnecessary-memset.patch
x86-crash-remove-redundant-0-value-initialization.patch
kexec_core-remove-redundant-0-value-initialization.patch

