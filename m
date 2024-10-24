Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD87856446
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729736267; cv=none; b=O+wbgixETKj74lvwNPmy9ICM3FHXsrnrEWgFuyspcAlIRbglQN6AuApgPDcNurq2AvLwbCb7ssK+By2Oh8f9pDiCxn398mc2OWmRj6aySCFAh3wuvQt+tT0nwvs4PQsCjVzlo4bUuUsg/NxMlZw/EPJ66Hk2F4NFo2c7LU8hXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729736267; c=relaxed/simple;
	bh=Zt/MrIvWnKDmyWZHOh51ia+nVovhWOppC2mImCB2eDA=;
	h=Date:To:From:Subject:Message-Id; b=MYOYYu+uvrmyMeq3UtwA44kT9nCwxveEWfOBoaFQUC5msEscoOVuJSRYJ+EbxZ6zVZsdY4DTtSxKqyyaGNNzHNVCKLznHpEoAkZMKTenNJsjHFe2HiQPvPg8OP3YRcQHPToVF/TljYx6NtWmLhp27C/vrMDhZOBrnkAIoXTBuYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBq9/9JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBq9/9JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D14C4CEC6;
	Thu, 24 Oct 2024 02:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729736267;
	bh=Zt/MrIvWnKDmyWZHOh51ia+nVovhWOppC2mImCB2eDA=;
	h=Date:To:From:Subject:From;
	b=fBq9/9JMokr2mFI2DZTWfC3pUaA63lqI2Lpa3d9VhT4zJYu0ET7LhkT3jo0Rq0Bht
	 Z58P24K/HOyHQ0JMf5I376aPfCl85Ifhq4gVPl9+waAlAUc2UpXcxINLVZH8aAsbPU
	 Z3fz4lvD+HjxRtcs+itHYINXEl4D3WU+sGE9jXzQ=
Date: Wed, 23 Oct 2024 19:17:47 -0700
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-lib-list_sort-remove-unnecessary-header-includes.patch added to mm-nonmm-unstable branch
Message-Id: <20241024021747.A3D14C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/lib/list_sort: remove unnecessary header includes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-lib-list_sort-remove-unnecessary-header-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-lib-list_sort-remove-unnecessary-header-includes.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: tools/lib/list_sort: remove unnecessary header includes
Date: Sat, 12 Oct 2024 12:28:27 +0800

Since lib/list_sort.c no longer requires ARRAY_SIZE() and memset(), the
includes for kernel.h, bug.h, and string.h have been removed.  Similarly,
tools/lib/list_sort.c also does not need to include these headers, so they
have been removed as well.

Link: https://lkml.kernel.org/r/20241012042828.471614-3-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/lib/list_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/lib/list_sort.c~tools-lib-list_sort-remove-unnecessary-header-includes
+++ a/tools/lib/list_sort.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/string.h>
 #include <linux/list_sort.h>
 #include <linux/list.h>
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are

lib-kconfigdebug-move-int_pow-test-option-to-runtime-testing-section.patch
lib-makefile-make-union-find-compilation-conditional-on-config_cpusets.patch
lib-list_sort-remove-unnecessary-header-includes.patch
tools-lib-list_sort-remove-unnecessary-header-includes.patch
perf-tools-update-expected-diff-for-lib-list_sortc.patch

