Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CA449E12D
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081867; cv=none; b=AGeM8mYnoYbMOuPBAKZ4vl04NN7wt9G3j8Z2l8uy7VZHIe74Jt7V3SvOOR8Ah1bYzN6Mv6E1XkhvsV5oZ9hWyyTg2/l9bNj9JqC+4zk7GMsRoKQZLWUJP7l6zINR8Fj9VJw9SY20M40wAfaJPbo60zwSOc77RQVohcF0A66PEe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081867; c=relaxed/simple;
	bh=UoUpSkWjz2CrYNpWNVYTI8QKtR2h7C8uLPyQuCmBQq8=;
	h=Date:To:From:Subject:Message-Id; b=QlO1eK1y3RVSob5VJUsQL7OdXDijc73hxpDGoVsdSowjREdHJg9KTtuqA8Kc1uYdUPvG8lSHtAtBoYYhttyclW57ZfgUld8dLrD7ygv2O2GV69h7yTtUM6+p0IlPCG7eIQhvAz+2/oP2Ph38+L0zu88iq3dEYVGvZkHpBmG5e7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sp92e86e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sp92e86e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B641F000FF;
	Thu, 10 Sep 2026 23:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081865;
	bh=Ir81sE/qSKhNQgOL7i+SS/gXkG2ERdNXUFN6hpwPLMs=;
	h=Date:To:From:Subject;
	b=sp92e86eRF43RXjwBaw+tVwMs4jcjRAsXXZ+FghEFNCnvX4IxWzJh7TAexlSh34th
	 Aj1g3BadOpwsKVNwE2S196MGUi0OZ84mcG3Hv0dDFgRYQnDNlmxWQgLd5dKgezV1CM
	 JV24H6YrwBL9ouR1uY3WTInlSHEvHm08cBxESt74=
Date: Thu, 10 Sep 2026 16:11:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,james.bottomley@HansenPartnership.com,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch added to mm-new branch
Message-Id: <20260910231105.28B641F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix ptrace PEEKDATA check in memfd_secret test
Date: Thu, 10 Sep 2026 14:44:15 +0800

try_ptrace() treats PTRACE_PEEKDATA return value as a boolean check.  A
successful read returns non-zero data (memory filled with 0x55), causing
the test to incorrectly report PASS when secret memory protection is
broken.

Check the return value against -1 instead.  The test should only pass when
PTRACE_PEEKDATA fails, which means secret memory protection works.

Link: https://lore.kernel.org/20260910064415.71623-1-hongfu.li@linux.dev
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hongfu Li <lihongfu@kylinos.cn>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/memfd_secret.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/memfd_secret.c~selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test
+++ a/tools/testing/selftests/mm/memfd_secret.c
@@ -145,7 +145,8 @@ static void try_ptrace(int fd, int pipef
 		exit(KSFT_FAIL);
 	}
 
-	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
+	/* PEEKDATA on secret memory must fail, else protection is broken. */
+	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
 		exit(KSFT_PASS);
 
 	exit(KSFT_FAIL);
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
mm-hugetlb-fix-resv_huge_pages-double-decrement-in-memfd-error-path.patch
mm-memcontrol-remove-unused-memcg-parameter-in-calculate_high_delay.patch
selftests-mm-khugepaged-consolidate-error-exits-via-kselftest-helpers.patch
mm-page_owner-preserve-original-free_pid-free_tgid-during-folio-migration.patch
mm-memfd-fix-hugetlb-reservation-accounting-in-error-paths.patch
selftests-mm-fix-ptrace-peekdata-check-in-memfd_secret-test.patch

