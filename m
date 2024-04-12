Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69D484A4F
	for <mm-commits@vger.kernel.org>; Fri, 12 Apr 2024 22:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962479; cv=none; b=OxLNke3qgAdpMMToE0kUD3/pqV9fXldqWeUi5GuE7HVP3Xt0iC2TzGmVh4/V2A0qFNdRERy3wlpuho5sSgHmSs+GpJgK7dgchpdIEVGXb/vVt7flGqMsUM0K/E2pVExKPpe5U7FTChXfnilQ/5B9P++6ZNuSoUzkvBhZtjnXrmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962479; c=relaxed/simple;
	bh=FkEwq+pFB+5ZtNV2Amt6/sEaTaPLOeULdyADeqwtQP0=;
	h=Date:To:From:Subject:Message-Id; b=Qu9MhFjx4HHhgRvN35GEUx/kups40OmueG9kvwofkyihXvvT/Z4RuXLO3Nc6BLttpNBkX+UIJTN1rpM3UBH6mWomAjc68Dd7RXLvDOaNRb5aYQAh5V+iH7DczQc8o7Gyetw+akrXLx6j/3+89wC8CJKVTNzPAu+3FJi3XZdVQiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BbJm8xFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BbJm8xFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7985C113CC;
	Fri, 12 Apr 2024 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712962478;
	bh=FkEwq+pFB+5ZtNV2Amt6/sEaTaPLOeULdyADeqwtQP0=;
	h=Date:To:From:Subject:From;
	b=BbJm8xFaduRZllhjR09qvWZBtGE9RrM8LmAf4URZiT2fmTfl32qZ4PH5bFioYwJpB
	 P1sq9TZPOsREjgjCvxrnNIKKYetuo0Z6vh4/WLzShFrOVI+0tpUWtQjtAwYtW/ptid
	 KGQdC5A+fIIAJDhYRF/BwplQw0kNIzwVO4v5r3nM=
Date: Fri, 12 Apr 2024 15:54:37 -0700
To: mm-commits@vger.kernel.org,edliaw@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-harness-remove-use-of-line_max-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240412225438.B7985C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests-harness-remove-use-of-line_max-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-harness-remove-use-of-line_max-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-harness-remove-use-of-line_max-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: selftests-harness-remove-use-of-line_max-fix
Date: Fri Apr 12 03:53:51 PM PDT 2024

remove limits.h include, per Edward

Cc: Edward Liaw <edliaw@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kselftest_harness.h |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/testing/selftests/kselftest_harness.h~selftests-harness-remove-use-of-line_max-fix
+++ a/tools/testing/selftests/kselftest_harness.h
@@ -56,7 +56,6 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

selftests-harness-remove-use-of-line_max-fix.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries-fix.patch
mm-hold-ptl-from-the-first-pte-while-reclaiming-a-large-folio-fix.patch
sh-remove-use-of-pg_arch_1-on-individual-pages-fix.patch
mm-gup-drop-folio_fast_pin_allowed-in-hugepd-processing-fix.patch
mm-allow-anon-exclusive-check-over-hugetlb-tail-pages-fix.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess-checkpatch-fixes.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

