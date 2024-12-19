Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42424AD5A
	for <mm-commits@vger.kernel.org>; Thu, 19 Dec 2024 00:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734568160; cv=none; b=C4YsKSzxtKOkjvvCsHuMFLIUqdI5VjhnyPyWGPArVr/rnd2XjyHkr/Ym/MTMvDP5iQqSzHxJkBHNn90gd2Jd+dtbZSgk2AnN5bfPgEBeW2bFT4ehC/ZxapxcQZwQgZEdkFaXZCvwjZQ7D33CKFqk3jzJ8yzeWgk/0TyCV4DJxmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734568160; c=relaxed/simple;
	bh=z8cMPaL8ex/MQq0DAFMuyxWwFLm5jpomIyXiUjzrd7g=;
	h=Date:To:From:Subject:Message-Id; b=mT1NopArPZ+WA3J4tgiTMCYWS4kfGB5UX+9ASlzC8CfTtQowTuW1Y7Ata/6dzjMpsAdjYFx01gG3pNoAd0UDV83imcjgVcf/LaOCN0OPSysEYeDNTDnWH5NhQnnhzk+EGrFKW6F4GgPrXGJBeqKgnEOocc74r8pZOT/9G/X8kqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zISkfX+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zISkfX+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB2EC4CECD;
	Thu, 19 Dec 2024 00:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734568159;
	bh=z8cMPaL8ex/MQq0DAFMuyxWwFLm5jpomIyXiUjzrd7g=;
	h=Date:To:From:Subject:From;
	b=zISkfX+Q+v3B6MO3d6IM8ZP5oLCI0q0EoeZPsJtdgzrKZ6llVQSl5GgY56JMn7fT8
	 9hDZHI6h9mpBE3wIHpIJRS+r5a86FglbrW2w3RgcDAJmZOSJPeMsoHw3t+iAQ3faX1
	 itYpogExsdOw/C9Gj2ADTihwLBeYsWuwvmsU9830=
Date: Wed, 18 Dec 2024 16:29:19 -0800
To: mm-commits@vger.kernel.org,joel.granados@kernel.org,hch@lst.de,martink@posteo.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-fix-removal-warning-for-deprecated-initrd-loading.patch added to mm-nonmm-unstable branch
Message-Id: <20241219002919.AEB2EC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init: fix removal warning for deprecated initrd loading
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-fix-removal-warning-for-deprecated-initrd-loading.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-fix-removal-warning-for-deprecated-initrd-loading.patch

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
From: Martin Kepplinger <martink@posteo.de>
Subject: init: fix removal warning for deprecated initrd loading
Date: Wed, 18 Dec 2024 12:36:38 +0000

This won't be removed in 2021, no matter how hard we try.

Link: https://lkml.kernel.org/r/20241218123638.34907-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_initrd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/do_mounts_initrd.c~init-fix-removal-warning-for-deprecated-initrd-loading
+++ a/init/do_mounts_initrd.c
@@ -89,7 +89,7 @@ static void __init handle_initrd(char *r
 	extern char *envp_init[];
 	int error;
 
-	pr_warn("using deprecated initrd support, will be removed in 2021.\n");
+	pr_warn("using deprecated initrd support, will be removed soon.\n");
 
 	real_root_dev = new_encode_dev(ROOT_DEV);
 	create_dev("/dev/root.old", Root_RAM0);
_

Patches currently in -mm which might be from martink@posteo.de are

init-fix-removal-warning-for-deprecated-initrd-loading.patch

