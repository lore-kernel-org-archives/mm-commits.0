Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEF21A2398
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 23:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738194552; cv=none; b=n1cZIEfrqQ5OGvmujMAw69ZzdglSXNVOYVzonRXEOAOXAqqwmc8/uatflA0+s2PHOP0AQJA42t32UXW9O/R8uE6Q5jhG9ZpjEFoTs3D/Sj4w4LT84kgwRLq3Na4iIxi1p2h+q3kX9ak5g3UxEEg7TF3dmf96ITTcjKYYyIJV6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738194552; c=relaxed/simple;
	bh=xQuqmXUke3sZmtP5X/1sSA9BNx4QtSTK1KP3LuF4VFk=;
	h=Date:To:From:Subject:Message-Id; b=nChqt/m+yOAm/0PSg3ESh2B+9ad3FIEugUETjEyPqXeyrn1vLxSU/ZsR+gQ+NLdwOjSpsQOT8P4HENEcyOYb3LjYhO/l+m+TwYnpOkSjemxH9RMLR9m9KzstyiFsMhrk/xbe/njZbX4SfzUPKAbpnD/nStWRhIqnejAyofIUvek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y7hIU/e2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y7hIU/e2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DF7C4CED1;
	Wed, 29 Jan 2025 23:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738194552;
	bh=xQuqmXUke3sZmtP5X/1sSA9BNx4QtSTK1KP3LuF4VFk=;
	h=Date:To:From:Subject:From;
	b=Y7hIU/e22FHiEEn7NPnNYb0Nua7oNjo+4UtLpWp9pEfeAkPsCf2jF9a0kWlfdylhb
	 97URSUQQVSot/eBQfpcIoX6MQzy4OM0xAkTP+XLq0c7vciXEb0to/4Z0Cgmil1C1V0
	 zrDdIWTE0m5iofibjGBq1gaey9ViOIUvXQJHXU0o=
Date: Wed, 29 Jan 2025 15:49:11 -0800
To: mm-commits@vger.kernel.org,fvdl@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20250129234912.22DF7C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes.patch

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
Subject: mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes
Date: Wed Jan 29 03:47:56 PM PST 2025

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#376: 
new file mode 100644

WARNING: Improper SPDX comment style for 'mm/hugetlb_cma.h', please use '/*' instead
#643: FILE: mm/hugetlb_cma.h:1:
+// SPDX-License-Identifier: GPL-2.0

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#643: FILE: mm/hugetlb_cma.h:1:
+// SPDX-License-Identifier: GPL-2.0

total: 0 errors, 3 warnings, 481 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Frank van der Linden <fvdl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cma.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb_cma.h~mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes
+++ a/mm/hugetlb_cma.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_HUGETLB_CMA_H
 #define _LINUX_HUGETLB_CMA_H
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
mm-hugetlb-move-hugetlb-cma-code-in-to-its-own-file-checkpatch-fixes.patch
xfs-convert-timeouts-to-secs_to_jiffies-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

