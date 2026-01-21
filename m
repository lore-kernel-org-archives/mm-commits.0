Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2752228DB56
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967369; cv=none; b=l1HZg71GumdMIKYvXg40L7U3okMTUxAOW8gf0My8z7yFQ03lfvNugm0UE/B6SHWD4oNmE5PBl2XLvbuNy6hBykPenN8m9Psxlgu0VKh2pVCpOJ1wHI+t04+Zb37VtL3lSLI5rqIWGSOpL4CHAR5syCraQadrercngGCCpy4GLYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967369; c=relaxed/simple;
	bh=TTsWEPKXbxTZZYCurlZ9fX0Y70hL4DYSLEJUATI65Xo=;
	h=Date:To:From:Subject:Message-Id; b=HyUOUHz0gdL7u4VKorS7enOQLSdySWN/qvKlTy3UfJ/4TMAggUUsKQ41pwFAQF/c01WHuAYGH0qquQm+OETRmU58TwaeFJee5GBXyxFUQ92tCwTgyJ0k7hyf3nmAb1aCyfCGRNl8GlUrOA9iLzi3hN9y3NS7Rq0EfY1g1BdE2PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZA11lLQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZA11lLQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74827C19423;
	Wed, 21 Jan 2026 03:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967368;
	bh=TTsWEPKXbxTZZYCurlZ9fX0Y70hL4DYSLEJUATI65Xo=;
	h=Date:To:From:Subject:From;
	b=ZA11lLQzAHXWBMtdVpojzIpF7Ei5v6qYQ4QyoHr+81YWufGMoskI7/XeX9gNrqtHv
	 lNcuOP09dnp5h8dlHSfTTgH/35igJUCW8iMyFvzTzR+/mn8WcVP+1uUTsdNWOa5LJ/
	 JY/XIU4EziVrG0YKpNVmOMFgVVLih2V6wXNpbLx0=
Date: Tue, 20 Jan 2026 19:49:27 -0800
To: mm-commits@vger.kernel.org,mario.limonciello@amd.com,chaitanyamishra.ai@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch removed from -mm tree
Message-Id: <20260121034928.74827C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/kstrtox: fix kstrtobool() docstring to mention enabled/disabled
has been removed from the -mm tree.  Its filename was
     lib-kstrtox-fix-kstrtobool-docstring-to-mention-enabled-disabled.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


