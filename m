Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A461AF0BB
	for <mm-commits@vger.kernel.org>; Wed,  1 Apr 2026 04:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775016365; cv=none; b=JnzYFH2uwcRdTJQ3w/j1kJwUYbpUCG0cOWbZhi0NiZ3YYqicJOC6KZ9Id3VxYYruC7okpqAA+IB1Gi2F/qyGNsqQFss5WfdEVmEYYJoKaaFR3+7rG+1yD12/DY+egWw2J0233FEnfukUdxYhuRat9OHM+7mqwvMaWT/wtDSPEpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775016365; c=relaxed/simple;
	bh=ak4MFT2p0YDd1OYxi211y+XvCl6ZxJbwhluHyqhLTWg=;
	h=Date:To:From:Subject:Message-Id; b=LCHXYcWcJ4MVRy1x8eSlk7YHLd1NtAO+twXHErocMXzvNCVu8eb/XjodwnJ81scW1sAcU19Rf+NrlZcSTq7wQmr0VgX0EZlTsr2u6wu+uCuB6gr0sdT3o2Tym/1Z7l1KnjvArYStnxQgXVmQXbry73+HFIr8nQVZe2xU0uZxWME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UPYxigCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UPYxigCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98360C4CEF7;
	Wed,  1 Apr 2026 04:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775016364;
	bh=ak4MFT2p0YDd1OYxi211y+XvCl6ZxJbwhluHyqhLTWg=;
	h=Date:To:From:Subject:From;
	b=UPYxigCpWbPfvNtzUyIlDiIcSHVGCYpridrueHE7MQ1H11UR7bSuDTeFpMUXnhX9Z
	 nA7iTQtrb75GcTtojBn1AquvRu/fl5Dl/G+YzV/n4qbmM0t9o+4vGR6CSY2mkWML1D
	 CrR59RFHgfIgPbWxL0eh9ISJKPAXfvt/X62v/jiI=
Date: Tue, 31 Mar 2026 21:06:04 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,devnexen@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch added to mm-unstable branch
Message-Id: <20260401040604.98360C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
Date: Tue Mar 31 09:04:03 PM PDT 2026

include file.h for fput()

Cc: David Carlier <devnexen@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/userfaultfd.c~shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix
+++ a/mm/userfaultfd.c
@@ -11,6 +11,7 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
+#include <linux/file.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

liveupdate-initialize-incoming-flb-state-before-finish-fix.patch
shmem-userfaultfd-implement-shmem-uffd-operations-using-vm_uffd_ops-fix-fix.patch
selftests-mm-skip-hugetlb_dio-tests-when-dio-alignment-is-incompatible-checkpatch-fixes.patch
lib-list_sort-remove-dummy-cmp-calls-to-speed-up-merge_final-fix.patch

