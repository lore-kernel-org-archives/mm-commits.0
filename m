Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B631D2627EA
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741714622; cv=none; b=rjVEmbIRrnwT+LpYYX7Zkpcppw4kbaY8F+vWSAV76gDfAGroeWM6tNwUOPRH7F9PCDWu+JSn+U/HuqDtQ/c6xbQUJNBq9vTD9dewpOIgX+lstmRBjKS0bo0nVx/Ut2Yq2ELuXdsgUBQQp6canfYkoGpME0XqrV3WGagpvXMVqHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741714622; c=relaxed/simple;
	bh=Xp5WPVNtYMDUvLW1ZQY+HYiqoNdlk7H92X7dswxvW90=;
	h=Date:To:From:Subject:Message-Id; b=KtMvoH3x1d0QAnbVkbZ3khczuZ8jvkXQkO4RWMHUfXuDlJxR2O88GNgQgkxJNAcof4FXajKeiHoS0MJ4SDymESv4z2h7FS0FrEIPFAPGbSAZYcN6R0G5tStbJbXRBR5xUXYktXqEXLs+AcLjxRQEHCXiHQ0cQ/w+ot8O91HRYcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QWNaYEw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QWNaYEw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88604C4CEE9;
	Tue, 11 Mar 2025 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741714622;
	bh=Xp5WPVNtYMDUvLW1ZQY+HYiqoNdlk7H92X7dswxvW90=;
	h=Date:To:From:Subject:From;
	b=QWNaYEw1D+NWjYp0nNz0vkuqzEs4AcbgAbiWf4tm38u37o15Hn8hU+WKh1p0Th3Pf
	 i8yIxgEtPl6lm6xd80RnB1+Kb7iT0ibvgj9kh9e/8HBv1Ba8OM9YfspLCte2SLRkTc
	 jPG5UgHdPWuwO0el8Nqul6srUXHQJ2A989vq+5y0=
Date: Tue, 11 Mar 2025 10:37:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch added to mm-unstable branch
Message-Id: <20250311173702.88604C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: ensure uffd-wp-mremap gets pages of each size
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch

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
Subject: selftests/mm: ensure uffd-wp-mremap gets pages of each size
Date: Tue, 11 Mar 2025 13:18:21 +0000

This test allocates a page of every available size and doesn't have any
SKIP logic if the allocation fails.  So, ensure it's available and skip
the test if we can't do so.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-10-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   23 +++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -325,9 +325,30 @@ CATEGORY="userfaultfd" run_test ${uffd_s
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem-private 20 16
-CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
+# uffd-wp-mremap requires at least one page of each size.
+have_all_size_hugepgs=true
+declare -A nr_size_hugepgs
+for f in /sys/kernel/mm/hugepages/**/nr_hugepages; do
+	old=$(cat $f)
+	nr_size_hugepgs["$f"]="$old"
+	if [ "$old" == 0 ]; then
+		echo 1 > "$f"
+	fi
+	if [ $(cat "$f") == 0 ]; then
+		have_all_size_hugepgs=false
+		break
+	fi
+done
+if $have_all_size_hugepgs; then
+	CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
+else
+	echo "# SKIP ./uffd-wp-mremap"
+fi
 
 #cleanup
+for f in "${!nr_size_hugepgs[@]}"; do
+	echo "${nr_size_hugepgs["$f"]}" > "$f"
+done
 echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 CATEGORY="compaction" run_test ./compaction_test
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

