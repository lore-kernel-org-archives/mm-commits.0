Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F2B155399
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 21:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143107; cv=none; b=BJodmaejWhsm7mrJhV9hiWbvj8+DCPMUVb/cNT4ohy8ZuuYWTPVxOlDstqoPvfEX73C6JpIg9keiqpRaEkcsBjLq+H4MJgbeITfvYlQ0jjIxbSAdAJXarUapoHgmT0FTE333S4E2Qtda2RLUFtZcZ4+LYjRFazn1lCXdn87QqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143107; c=relaxed/simple;
	bh=ZlCGtZQPY2cpn9eQGp355dspeKmp5YZh7fLqxRT2Gq0=;
	h=Date:To:From:Subject:Message-Id; b=u5VlR1DCHY+vp3ojaBAL0J/3FFn3eF+U3Tncvsx94XT+Nf9c53mmgvv/tdDLxHJdGz8uOE46JwhNyJmviHMHMfl2DPLW7pVSFsLXi7tYOP5FTMdACfTl84mNveEBc/jCUJmEnwz4DB4GThQ3oNjj0UTlXF9MzxDaSMY9Z1+rTy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Suyy7OOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Suyy7OOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1089C2BD10;
	Tue, 11 Jun 2024 21:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718143106;
	bh=ZlCGtZQPY2cpn9eQGp355dspeKmp5YZh7fLqxRT2Gq0=;
	h=Date:To:From:Subject:From;
	b=Suyy7OOAWDx+TEYdk1KCUeTWtxaJ9bLipH9tfyNOSZPv8rQK2gQfJBUCgNxnuupMr
	 bFH9lJLwpzaNUyDilZ5oSlrO109uUoBdSwn7ydYjt5vQcjZUedajM75PZN6YNwrSXH
	 kQuinNN4vLD5fmOdtd7uN1uLWXkOsrpwQFqwKQdQ=
Date: Tue, 11 Jun 2024 14:58:26 -0700
To: mm-commits@vger.kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch added to mm-unstable branch
Message-Id: <20240611215826.C1089C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix
Date: Thu, 6 Jun 2024 13:01:50 +0800

fix transhuge.rst indentation

Link: https://lkml.kernel.org/r/b189d815-998b-4dfd-ba89-218ff51313f8@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/transhuge.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -338,6 +338,7 @@ and its value for each mTHP is essential
 An 'inherit' option is added to ensure compatibility with these global settings.
 Conversely, the options 'force' and 'deny' are dropped, which are rather testing
 artifacts from the old ages.
+
 always
     Attempt to allocate <size> huge pages every time we need a new page;
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch

