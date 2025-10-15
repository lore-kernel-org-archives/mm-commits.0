Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA402DC79E
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563303; cv=none; b=ZJ3qx5rQzdh75likzasxnVWOre+RAAMVa+6YxpxsaxCy0nlSYE+TYptVtUxOanCAe8ub14ktVSsrZVY0rH0sO+9CNVVH8XFIoT63qye3S0aK3muCcak4Ipv8e2zxVG1SrvgaOxr02/8lTaH/Tu9r0MMgrQWyTTPzmuvbaDXOLZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563303; c=relaxed/simple;
	bh=0j7XBS+vMOn4ph3hArrZs7BfiPbA0B4mcSihX01oKMQ=;
	h=Date:To:From:Subject:Message-Id; b=B5/OElQt2/KTOAGSSXdXpLa1lCG7D1g58hKDXKng1DWkbl7RpPp+QF8mfLocxd4DFkicwb6k+P/9k9n/sS1E4QzwvvCKc1JT7ljsvDS18Cj8+g3b/CATN7C4oDcTmd46u5TWRqhWGXHiDnln23cf4VIG3faU8hHBSXX32IhP1+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxVlkkV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxVlkkV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A99FC4CEF8;
	Wed, 15 Oct 2025 21:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760563303;
	bh=0j7XBS+vMOn4ph3hArrZs7BfiPbA0B4mcSihX01oKMQ=;
	h=Date:To:From:Subject:From;
	b=cxVlkkV+kREQawkz87RW5aPUmIuLsr32NoYZ7TpRk70zOw7p3FfogDpmo3H+1nH+A
	 dmnzf6BkQ60xrGItSC6/Uyq6Lb1DibOnSZEW1W//77gxO+t1MlSU0BY5XgtNcunYFo
	 yQHYYUxf6NQZ/Ol98t5wnjkSnuVL19sZeMERfdVQ=
Date: Wed, 15 Oct 2025 14:21:42 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,dev.jain@arm.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-use-stdboolh-in-page_owner_sortc.patch added to mm-new branch
Message-Id: <20251015212143.2A99FC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: use <stdbool.h> in page_owner_sort.c
has been added to the -mm mm-new branch.  Its filename is
     tools-mm-use-stdboolh-in-page_owner_sortc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-use-stdboolh-in-page_owner_sortc.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: tools/mm: use <stdbool.h> in page_owner_sort.c
Date: Wed, 15 Oct 2025 17:38:50 +0800

Use standard <stdbool.h> instead of manually defining bool, true and false.

Link: https://lkml.kernel.org/r/20251015093851.109663-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-use-stdboolh-in-page_owner_sortc
+++ a/tools/mm/page_owner_sort.c
@@ -13,6 +13,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
@@ -23,9 +24,6 @@
 #include <linux/types.h>
 #include <getopt.h>
 
-#define bool int
-#define true 1
-#define false 0
 #define TASK_COMM_LEN 16
 
 struct block_list {
_

Patches currently in -mm which might be from liuye@kylinos.cn are

tools-mm-use-stdboolh-in-page_owner_sortc.patch

