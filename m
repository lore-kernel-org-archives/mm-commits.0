Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EF678F24
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755322381; cv=none; b=KKNAtIdZgq3EnDF/wWC+iPdbRX66FIFl4QeZDRNLr5BPEacv7obmFEbiZw/pSV2eg0w1aSYLKuQjeA59+P37GCbUM6Ty1PELygEeyDF5RjoracVo+uye/ABf74YSK5ADrIWIbszLsrJploajFF69vFXzT+DGkW0IWRHtMjMxfmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755322381; c=relaxed/simple;
	bh=i1FGnCK2YBGE/ywp9f1jCtvViqCpzFEPXOtbZ+CLKv0=;
	h=Date:To:From:Subject:Message-Id; b=dZcCh76U9P9m+2Wn7FJcEawQe5JHwOHiAiPLedOW68VOsK11cKz5mCtY45To6Z8Hbai26rMdroFYkbWmP6K8alnChA/tXUfIZuInI22VjsiMjZelYcfGRlnMHJdwNkjfr7REASFpEHQ8MMOi6TJkHjMZThD8DL3MNMGxnbl1xZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9SLKRut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9SLKRut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AC3C4CEEF;
	Sat, 16 Aug 2025 05:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322379;
	bh=i1FGnCK2YBGE/ywp9f1jCtvViqCpzFEPXOtbZ+CLKv0=;
	h=Date:To:From:Subject:From;
	b=p9SLKRutyjNxsz+FcD4FMjotSZxNSZQvQHJo6h5kNeS7iQhUEcpUxaAy80Y3lazXg
	 vG4N9pgZBVDy989ZSd5ftcfwfBW9uaBa/A9k3AeN05dON0TWe2FDAiV3MZRjZ7mERv
	 AhuZnUd7fQtUQB6Em1ITF7WKFjb+faZpRrPwpJj8=
Date: Fri, 15 Aug 2025 22:32:58 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,lorenzo.stoakes@oracle.com,axelrasmussen@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mark-mglru-as-maintained.patch added to mm-hotfixes-unstable branch
Message-Id: <20250816053259.63AC3C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mark MGLRU as maintained
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mark-mglru-as-maintained.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mark-mglru-as-maintained.patch

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
From: Axel Rasmussen <axelrasmussen@google.com>
Subject: MAINTAINERS: mark MGLRU as maintained
Date: Fri, 15 Aug 2025 14:59:14 -0700

The three folks being added here are actively working on MGLRU within
Google, so we can review patches for this feature and plan to contribute
some improvements / extensions to it on an ongoing basis.

With three of us we may have some hope filling Yu Zhao's shoes, since he
has moved on to other projects these days.

Link: https://lkml.kernel.org/r/20250815215914.3671925-1-axelrasmussen@google.com
Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/MAINTAINERS~maintainers-mark-mglru-as-maintained
+++ a/MAINTAINERS
@@ -16062,6 +16062,23 @@ F:	mm/mempolicy.c
 F:	mm/migrate.c
 F:	mm/migrate_device.c
 
+MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Axel Rasmussen <axelrasmussen@google.com>
+M:	Yuanchu Xie <yuanchu@google.com>
+R:	Wei Xu <weixugc@google.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/mm/multigen_lru.rst
+F:	Documentation/mm/multigen_lru.rst
+F:	include/linux/mm_inline.h
+F:	include/linux/mmzone.h
+F:	mm/swap.c
+F:	mm/vmscan.c
+F:	mm/workingset.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@redhat.com>
_

Patches currently in -mm which might be from axelrasmussen@google.com are

maintainers-mark-mglru-as-maintained.patch

