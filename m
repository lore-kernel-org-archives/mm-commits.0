Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62A2853E9
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756249629; cv=none; b=VkEd83h/BX1+aBaZiFD6WjwcfGcJ1l9FApj3DF4+EqlVtUYAAS6CAypRAfFzt8mKVzDwRgu8XQgdUwF1kBsCB7vwpLbCR+21IutiBlOfM4cA5cHDy6XUPPS20sMXm3tXXqQ6cwT8v5249dmZgm/AHCnWGftsp/N4N65VbevxS8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756249629; c=relaxed/simple;
	bh=qQ9nP6MnfkHhHdoowhQStH6GeMzmxYTSzd9fLv12eb8=;
	h=Date:To:From:Subject:Message-Id; b=CFtc1NQtif03W5bKreSOGIW/KVZweP0/VhTWb6ruPOZ2lu/5/+HGdVlbQLySI7R/51Gr34++Vd3C/pECbbPX5x1XFaYhzD/2H1aIjVSoWVmFMpvuYhJ5YZqpF9t/v3Kl+uSn6k11+Q5ZIN7bj+Qmq/zaE+n0dOjmACzS0yY3SGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aBfc3quJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aBfc3quJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B8FC4CEF1;
	Tue, 26 Aug 2025 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756249628;
	bh=qQ9nP6MnfkHhHdoowhQStH6GeMzmxYTSzd9fLv12eb8=;
	h=Date:To:From:Subject:From;
	b=aBfc3quJHW+4tsyqDMBOdbNQ5l2gLtlFJd9ps1zS8qXYfHdjmI182XLYjxOYU2ojw
	 olF3fdh8cY+ZpTvzZnDHM/eDx/AgbLdLrdnJ7AA/zKofr3Wv63ycNMZd/3dOnVL0IK
	 ol/N4SqmM2UykEi8R15++3b/KLLifM9nbRPibkuc=
Date: Tue, 26 Aug 2025 16:07:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vgupta@kernel.org,lorenzo.stoakes@oracle.com,lkp@intel.com,liuye@kylinos.cn,dev.jain@arm.com,david@redhat.com,chrisl@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch added to mm-unstable branch
Message-Id: <20250826230708.65B8FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
Date: Tue Aug 26 04:06:31 PM PDT 2025

don't include mm.h due to include file ordering mess

Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/arcregs.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arc/include/asm/arcregs.h~mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix
+++ a/arch/arc/include/asm/arcregs.h
@@ -146,8 +146,6 @@
 
 #ifndef __ASSEMBLER__
 
-#include <linux/mm.h>
-
 #include <soc/arc/arc_aux.h>
 
 /* Helpers */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix.patch
mm-replace-20-page_shift-with-common-macros-for-pages-mb-conversion-fix-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch

