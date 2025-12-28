Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACA246797
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 19:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766949590; cv=none; b=eQA+oA4yYwGaxZW1qrIqDGD5gQQ53SSbP3VubAxDDTTktWUkrwqIoXX2ihdBOM1WLOIqPnWzo2cjV2DKRyjtCJqpPxVDBh4N5LFiBKZLYXZ471SC8LfOD1A5/S/V0dJ/BQw+1EorvmY4w3PLF3pjbSvni7X+GKtOHPXfuKndSc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766949590; c=relaxed/simple;
	bh=qybocJgM2xMENVgj+BjMrVdQvt0AnZnK2rk92OIOBdM=;
	h=Date:To:From:Subject:Message-Id; b=c8myEqOpMKm7UD3oVuk2KJala5PnZVGGJybGA21rTLyuPEHh7yzu8AbvT6ZJa1GqCKSnATVETpIs5zQm+FEbHNUhY2uO59hNLyx8hrVB843fWSZkJqmIgcE7af9/eolkWQUbAa86UMQ1hAqtZ/qRH8If80icsd0+Y/XJF83Ski8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWgM3h0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWgM3h0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BB1C4CEFB;
	Sun, 28 Dec 2025 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766949589;
	bh=qybocJgM2xMENVgj+BjMrVdQvt0AnZnK2rk92OIOBdM=;
	h=Date:To:From:Subject:From;
	b=NWgM3h0iHyNXafgOILSBVXMYtIknCMjkWtZQPMTxjh9mewOFNwq3ZUBhF7F51ovLM
	 GCz141TMlo3G8Jn2lkXaSU7cKZOHQQMtdvJqqhUXAv5D3aAFxu7eB0xSN1bniVBseL
	 Xm4dHkzqWyiY5SoJbzxk0fzLdh3XcGEUHd0LycLo=
Date: Sun, 28 Dec 2025 11:19:48 -0800
To: mm-commits@vger.kernel.org,mario.limonciello@amd.com,chaitanyamishra.ai@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch added to mm-nonmm-unstable branch
Message-Id: <20251228191949.67BB1C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
Subject: lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled
Date: Sat, 27 Dec 2025 14:52:29 +0530

Commit ae5b3500856f ("kstrtox: add support for enabled and disabled in
kstrtobool()") added support for 'e'/'E' (enabled) and 'd'/'D' (disabled)
inputs, but did not update the docstring accordingly.

Update the docstring to include 'Ee' (for true) and 'Dd' (for false) in
the list of accepted first characters.

Link: https://lkml.kernel.org/r/20251227092229.57330-1-chaitanyamishra.ai@gmail.com
Fixes: ae5b3500856f ("kstrtox: add support for enabled and disabled in kstrtobool()")
Signed-off-by: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/kstrtox.c~lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled
+++ a/lib/kstrtox.c
@@ -340,8 +340,8 @@ EXPORT_SYMBOL(kstrtos8);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'YyTt1NnFf0', or
- * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * This routine returns 0 iff the first character is one of 'EeYyTt1DdNnFf0',
+ * or [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
  * pointed to by res is updated upon finding a match.
  */
 noinline
_

Patches currently in -mm which might be from chaitanyamishra.ai@gmail.com are

lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch

