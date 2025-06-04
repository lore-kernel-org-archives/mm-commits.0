Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6044256D
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 02:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749004920; cv=none; b=ZYrVgF1g59uSpshY2OcH4SF3yaEu2lw2gJjp2AFZOqTJG17ZVVLHqBTejdD9ohuj6nl7c1I1VKZVThya3M6ahmYZ5jSlENN79VluuS8Yd09nu6YPGkoX9y59gFh32rRu0ufT9+iKZ8coxORFTkWgQAteT/t1HztWhWVKg0eLayQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749004920; c=relaxed/simple;
	bh=8y2ujZKlHYI94AjnDhmDFb5cVuflnwCQrV6AYMqxnQc=;
	h=Date:To:From:Subject:Message-Id; b=avlIX1Afal8H49P6f8X7H+haUxyFvG4oOgeiHn2yyy24KQttrlivwEgfKzHdQ726Fgdzny21PMcB/614xOwb9ma6VQbKsQUUbZGowVtIbw2obIOQaKpYCBYASUvUx/S6QoWrBccYjmcNCfLLgugdmwGJ5T4qRu9/guW0dqvfhPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vfemMd5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vfemMd5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7E0C4CEED;
	Wed,  4 Jun 2025 02:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749004920;
	bh=8y2ujZKlHYI94AjnDhmDFb5cVuflnwCQrV6AYMqxnQc=;
	h=Date:To:From:Subject:From;
	b=vfemMd5d7AT1YF2oWYkEX9/LJFBD5vY2R7Nc3SwpishgI4+Z4iMpupOgCuZzV4keQ
	 RvsUGLxeEtbThUma7iFxET8OWz6WlqB/480H+lSrAhzXmW3Dps1BLN1W490t7af9g3
	 yBcZnVzMJ4x9+tKjD5z317PFz5IkAzK+x2B4+jow=
Date: Tue, 03 Jun 2025 19:41:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rppt@kernel.org,lorenzo.stoakes@oracle.com,pmenzel@molgen.mpg.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kconfig-use-verb-use-in-plural-form-in-description.patch added to mm-new branch
Message-Id: <20250604024200.4F7E0C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: Kconfig: use verb *use* in plural form in description
has been added to the -mm mm-new branch.  Its filename is
     mm-kconfig-use-verb-use-in-plural-form-in-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kconfig-use-verb-use-in-plural-form-in-description.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: mm: Kconfig: use verb *use* in plural form in description
Date: Tue, 3 Jun 2025 08:13:03 +0200

*workloads* is plural requiring the verb *use* in plural form.

Link: https://lkml.kernel.org/r/20250603061303.479551-2-pmenzel@molgen.mpg.de
Fixes: e13e7922d034 ("mm: add CONFIG_PAGE_BLOCK_ORDER to select page block order")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/Kconfig~mm-kconfig-use-verb-use-in-plural-form-in-description
+++ a/mm/Kconfig
@@ -1023,7 +1023,7 @@ config PAGE_BLOCK_ORDER_CEIL
 	  (see include/linux/pageblock-flags.h for details).
 
 	  Reducing pageblock order can negatively impact THP generation
-	  success rate. If your workloads uses THP heavily, please use this
+	  success rate. If your workloads use THP heavily, please use this
 	  option with caution.
 
 	  Don't change if unsure.
_

Patches currently in -mm which might be from pmenzel@molgen.mpg.de are

mm-kconfig-use-verb-use-in-plural-form-in-description.patch

