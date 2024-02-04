Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B388C8820
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031238; cv=none; b=CcLUjsjyT5juHIVluIvelpN3YX3l3F0B/St02UeQycEo69/6NVIizWYGFi4yERXKtYGNZWfjwJl7nEE0K+Zj/JlQda5E5Fa2oQX2MYhrwQir3jjfPFJiAuNtEO6ANLFOu78wvFyalyUh6l5dVE7P3F8EQoAv838DFsz2+z8Gxuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031238; c=relaxed/simple;
	bh=JFDPgNZ5ScDZUFAJHSfFW04v2N8AGfHftRW2H1gQELw=;
	h=Date:To:From:Subject:Message-Id; b=htKy2sZuIBUuutYAPzBr+X7k8ddJFQhgzGXw2krVFJU+ynxIq1bGxpatMC04U8fB9wEQpMgckbe+h2JhHQDm9mchVH4/m3RRLutZwx9qN4RE/Y/BpLPUgsak77X2Kp/dPbzvw4H/9C1EPsz4wtZL97k42LbqnhoTl1HzMegl55Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7Olwo8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7Olwo8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE3EC433C7;
	Sun,  4 Feb 2024 07:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031238;
	bh=JFDPgNZ5ScDZUFAJHSfFW04v2N8AGfHftRW2H1gQELw=;
	h=Date:To:From:Subject:From;
	b=M7Olwo8GjCNf4PfCVAN5afq0IqFba17bkJy1W0UY9/d1rl55S2a0jCawXgvxK+z6u
	 sQu1ryEo6elanZdwUuKMikYQ5bstzS0H/t9d9+Tp55bY3YsbIstm5Qkuw4neeG/xm1
	 7dD457WYyaJcl+aqgPEVuMpM396izQpyWaIzeZl4=
Date: Sat, 03 Feb 2024 23:20:37 -0800
To: mm-commits@vger.kernel.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-reduce-dependencies-on-linux-kernelh.patch added to mm-unstable branch
Message-Id: <20240204072038.7CE3EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: reduce dependencies on <linux/kernel.h>
has been added to the -mm mm-unstable branch.  Its filename is
     mm-reduce-dependencies-on-linux-kernelh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-reduce-dependencies-on-linux-kernelh.patch

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
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm: reduce dependencies on <linux/kernel.h>
Date: Fri, 2 Feb 2024 22:23:18 +0100

"page_counter.h" does not need <linux/kernel.h>. <linux/limits.h> is enough
to get LONG_MAX.

Files that include page_counter.h are limited. They have been compile
tested or checked.

$ git grep page_counter\.h
include/linux/hugetlb_cgroup.h: struct page_counter hugepage[HUGE_MAX_HSTATE];
	--> all files that include it have been compile tested

include/linux/memcontrol.h:#include <linux/page_counter.h>
	--> <linux/kernel.h> has been added, to be safe

include/net/sock.h:#include <linux/page_counter.h>
	--> already include <linux/kernel.h>

mm/hugetlb_cgroup.c:#include <linux/page_counter.h>
mm/memcontrol.c:#include <linux/page_counter.h>
mm/page_counter.c:#include <linux/page_counter.h>
	--> compile tested

Link: https://lkml.kernel.org/r/adfdbe21c4d06400d7bd802868762deb85cae8b6.1706908921.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h   |    1 +
 include/linux/page_counter.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-reduce-dependencies-on-linux-kernelh
+++ a/include/linux/memcontrol.h
@@ -14,6 +14,7 @@
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
 #include <linux/jump_label.h>
+#include <linux/kernel.h>
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
--- a/include/linux/page_counter.h~mm-reduce-dependencies-on-linux-kernelh
+++ a/include/linux/page_counter.h
@@ -4,7 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/cache.h>
-#include <linux/kernel.h>
+#include <linux/limits.h>
 #include <asm/page.h>
 
 struct page_counter {
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are

mm-reduce-dependencies-on-linux-kernelh.patch

