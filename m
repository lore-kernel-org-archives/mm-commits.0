Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBCA225797
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374958; cv=none; b=XDsFYYKWtdLTTUL93tTjHONasrZvfMNYc4O8dfbvqVeWSHR9g3M0bRdAH+jedWgrlgt4ac5mDnP+Nx2Y8EPBhYCyB/LLbHAhbsF6T6pMLwMPQBhfq4T6ILQW5bY1/4Bsu+7QSydQL4VMthSlPq2ImeiMUJtbsM0xdnQA1Q51atM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374958; c=relaxed/simple;
	bh=GP4s7W+TVUEGOuMZZ0Ixi6Zxqk5qy53bit7CJBMGgIw=;
	h=Date:To:From:Subject:Message-Id; b=F9v6FF49FETlA6mSYhg42EfKVE+5L4UFrpuAsWmP/AD+pNmBrhz84I0LkddSOfHv3wEeZUSCcTf8osjS61N7dR3d8IQJaFwDtrxLMCH5Uxb00a1AOls5MYSuIzp1nBz2n8tCAYXhtUjA1da4ZxtUPgzRO8vwSxhOvfeAqOSLN8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M+yqjHX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M+yqjHX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAE4C4CEEA;
	Thu, 19 Jun 2025 23:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374957;
	bh=GP4s7W+TVUEGOuMZZ0Ixi6Zxqk5qy53bit7CJBMGgIw=;
	h=Date:To:From:Subject:From;
	b=M+yqjHX4luCmdw5hBb6OA2ZnRUG2nI8Hw9Va2J2yCmsDy6mA716D6H4A840geNGu2
	 Jx5xYtuVfc+InYMWydjaOgNXllFxy9Ff+W72tZN/HXhbieF/KWRsIYiavnFMZttiMS
	 y5JrVYgzuZSq5DxwzknTKBRJlJPaT23MhAbMI9yc=
Date: Thu, 19 Jun 2025 16:15:57 -0700
To: mm-commits@vger.kernel.org,yukuai3@huawei.com,song@kernel.org,herbert@gondor.apana.org.au,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-lib-raid6-to-software-raid.patch added to mm-nonmm-unstable branch
Message-Id: <20250619231557.DAAE4C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-add-lib-raid6-to-software-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-lib-raid6-to-software-raid.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
Date: Thu Jun 19 04:13:17 PM PDT 2025

Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-lib-raid6-to-software-raid
+++ a/MAINTAINERS
@@ -23057,6 +23057,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
+F:	lib/raid6/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
maintainers-add-lib-raid6-to-software-raid.patch

