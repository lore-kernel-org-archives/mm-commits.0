Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2292A2627FC
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714621; cv=none; b=T5Od1U7Sd6t9fX6q8Jbq5z0ZRm8fQL5NmYXImyMXC7Z10Hhr6nGL7TygWgx2WykzbYZVm02/jJm+n88xB3A2l+mhYWQe95Hn/tgzotw/KxqhmknHvMUXAzXKTsR4tgU4m8qvBx64+yp4o+p4GEGfdt67lQ9NdhIvz1+0pSnFfiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714621; c=relaxed/simple;
	bh=0hKpqLNf6p9wI0AUgfVTLLz4dZ7rJdF6o4ls0SCmqxs=;
	h=Date:To:From:Subject:Message-Id; b=By3qwtIXRzyuNY/JwZVGpBy1RMO06pa4+Bik074U9MmTxiYbL+dwPtuiDkoY7/rWfAw9Wqiunogm7fYxlmp/GOHD6b5xR0X6v79wbE0b/f1TiGWqTnC+/KUPLiUl3WXiuwmIns8rzbcaU27dZ/ooNx2w1pQxXHS+g3ivvaZgHWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sRH2ME3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sRH2ME3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93642C4CEE9;
	Tue, 11 Mar 2025 17:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714620;
	bh=0hKpqLNf6p9wI0AUgfVTLLz4dZ7rJdF6o4ls0SCmqxs=;
	h=Date:To:From:Subject:From;
	b=sRH2ME3PmuNlvRsxgQAkvMZwjoglH2D2hf8UEAbNvW+/N48dfhRyqbEhfSYNhvRwJ
	 FojgaETIbh/IEYTv4UvbuQ5rpoeCabRVqVXm6hAhcRR+Vs2XXYB8+9zLfCe+CNOf3v
	 Y8cQoCjOlpVDI9YsDWC8CckJXH1GXCwoLCPLUzmk=
Date: Tue, 11 Mar 2025 10:36:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-drop-unnecessary-sudo-usage.patch added to mm-unstable branch
Message-Id: <20250311173700.93642C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: drop unnecessary sudo usage
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-drop-unnecessary-sudo-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-drop-unnecessary-sudo-usage.patch

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
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm: drop unnecessary sudo usage
Date: Tue, 11 Mar 2025 13:18:20 +0000

This script must be run as root anyway (see all the writing to privileged
files in /proc etc).

Remove the unnecessary use of sudo to avoid breaking on single-user
systems that don't have sudo.  This also avoids confusing readers.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-9-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-drop-unnecessary-sudo-usage
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -402,7 +402,7 @@ CATEGORY="madv_populate" run_test ./madv
 
 if [ -x ./memfd_secret ]
 then
-(echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
_

Patches currently in -mm which might be from jackmanb@google.com are

mm-mmu_gather-update-comment-on-rcu-freeing.patch
selftests-mm-report-errno-when-things-fail-in-gup_longterm.patch
selftests-mm-skip-uffd-stress-if-userfaultfd-not-available.patch
selftests-mm-skip-uffd-wp-mremap-if-userfaultfd-not-available.patch
selftests-mm-uffd-rename-nr_cpus-nr_parallel.patch
selftests-mm-print-some-details-when-uffd-stress-gets-bad-params.patch
selftests-mm-dont-fail-uffd-stress-if-too-many-cpus.patch
selftests-mm-skip-map_populate-on-weird-filesystems.patch
selftests-mm-skip-gup_longterm-tests-on-weird-filesystems.patch
selftests-mm-drop-unnecessary-sudo-usage.patch
selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch
selftests-mm-skip-mlock-tests-if-nobody-user-cant-read-it.patch
selftests-mm-mlock-print-error-on-failure.patch
mm-page_alloc-warn-on-nr_reserved_highatomic-underflow.patch
mm-page_alloc-clarify-terminology-in-migratetype-fallback-code.patch
mm-page_alloc-clarify-should_claim_block-commentary.patch
scripts-gdb-add-lx_per_cpu_ptr.patch

