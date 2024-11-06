Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7514318BC0F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855633; cv=none; b=TT49SSPuGgM2rL/k3XRvr7rklZ0bJl17gkjuWXVhR21fYrGdomz31SkHt8bvv5fkaQdgTL5dbMzB1nydmXhwz6QJRmZEVvsagSNycGgEv6dIprjkL83wY/YydbgJYtjuqbyl3kjXZ/Ui5Q/rXPZ/jLlFA15/Ar2IZ9OMYZmrsAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855633; c=relaxed/simple;
	bh=MUtK1gnrqGDVfXBpeRvAlrcZPHfUjNYUx37Z6R8GMQI=;
	h=Date:To:From:Subject:Message-Id; b=uMvIskirpnv5FIumOPIGnnO0/Y3B5XvnMeZGNXXJ0GKXUi021vObSRAH8Wmi7yLG5NAdvYq97CqObEous0rXy+2dZxOTAAAEUpK88BsjeyqDUyM4A+9zISFgqKulaUKQ5vD7ml2SkhDV4fFJYjrP9fTudaEdwEBwvYA46wWs6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zh3bWgjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zh3bWgjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402E8C4CECF;
	Wed,  6 Nov 2024 01:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855633;
	bh=MUtK1gnrqGDVfXBpeRvAlrcZPHfUjNYUx37Z6R8GMQI=;
	h=Date:To:From:Subject:From;
	b=Zh3bWgjwRRLoft1UWXbg4jOngLLFx3w9cUCya68/NCTqstP5EkDisZ3vdgOQVHGPx
	 vkvbt3Tpaw0CEWM74y8lAdHLturELB+//ZRFeZwa6t9pW7XcAcpGOh2MYGz6a4r+Zb
	 LKKzmQ1gJM89OXN66IiYsAGtFNZdbl8TNx13LwmI=
Date: Tue, 05 Nov 2024 17:13:52 -0800
To: mm-commits@vger.kernel.org,peterz@infradead.org,namhyung@kernel.org,mingo@redhat.com,mark.rutland@arm.com,kan.liang@linux.intel.com,jserv@ccns.ncku.edu.tw,jolsa@kernel.org,irogers@google.com,adrian.hunter@intel.com,acme@kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-list_sort-remove-unnecessary-header-includes.patch removed from -mm tree
Message-Id: <20241106011353.402E8C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/list_sort: remove unnecessary header includes
has been removed from the -mm tree.  Its filename was
     lib-list_sort-remove-unnecessary-header-includes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/list_sort: remove unnecessary header includes
Date: Sat, 12 Oct 2024 12:28:26 +0800

Patch series "Remove unnecessary header includes from
{tools/}lib/list_sort.c".

Remove outdated and unnecessary header includes from lib/list_sort.c and
tools/lib/list_sort.c.  Additionally, update the hunk exceptions checked
by check_headers.sh to reflect these changes.


This patch (of 3):

After commit 043b3f7b6388 ("lib/list_sort: simplify and remove
MAX_LIST_LENGTH_BITS"), list_sort.c no longer uses ARRAY_SIZE() (which
required kernel.h and bug.h for BUILD_BUG_ON_ZERO via __must_be_array) or
memset() (which required string.h).  As these headers are no longer
needed, removes them.

There are no changes to the generated code, as confirmed by 'objdump -d'. 
Additionally, 'wc -l' shows that the size of lib/.list_sort.o.cmd is
reduced from 259 lines to 101 lines.

Link: https://lkml.kernel.org/r/20241012042828.471614-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20241012042828.471614-2-visitorckw@gmail.com
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

 lib/list_sort.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/lib/list_sort.c~lib-list_sort-remove-unnecessary-header-includes
+++ a/lib/list_sort.c
@@ -1,9 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/kernel.h>
-#include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/string.h>
 #include <linux/list_sort.h>
 #include <linux/list.h>
 
_

Patches currently in -mm which might be from visitorckw@gmail.com are


