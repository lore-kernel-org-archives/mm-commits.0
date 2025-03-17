Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F295B217F24
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188448; cv=none; b=pkenE+NQfxsg08xJrNP920YheZg4XBjZ4wI0iTMyudQx3/O2NununMOVtno9Q9QUqDN/RuY4TKSlz/1oXqKLY7PvldboX/AcE5GZu89I9AoOMy5qrRJNbYGuvVRVQGm/3QEdUTp1cHo8eaDH4DncUbQJKGprj/Cr0s0yWqj4MF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188448; c=relaxed/simple;
	bh=0vR7rd6BQLaqzxVBrgXBsxRhgT0pfYwLiIYdxXrAOys=;
	h=Date:To:From:Subject:Message-Id; b=M7aXtvS7GeZrxCQAsstG85A4c/8Fa98gYyFin7FGsiPiW+Bo9/WcBvJYullxXzFrau/PaIa+2tzh3CRy9UG5Tfcx4GheRVn3PhrjbB+4Qc7nEdnoqU662hWTb/ogpa+/IL5Mm4JT5O7p0xerQnS0/QlJnW0VQMG30xcw01RNBuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uxk6WAgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uxk6WAgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C0DC4CEEC;
	Mon, 17 Mar 2025 05:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188447;
	bh=0vR7rd6BQLaqzxVBrgXBsxRhgT0pfYwLiIYdxXrAOys=;
	h=Date:To:From:Subject:From;
	b=uxk6WAgcze2aP87G5M8E+ULRab55Qy+WJ+XVa3SXIo/Ono9X2hYguWHlRjERPTPU0
	 27iWjsvXH9FPgzpqkQNIo+Ox8coiM+G0GtoDdjZJFuaBQ+OR7Cw5p5uMakRrePXeml
	 F/zNE1E2KZFpzUy1rgVvR09f5ZwsUlymA2zYUNGo=
Date: Sun, 16 Mar 2025 22:14:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch removed from -mm tree
Message-Id: <20250317051407.C8C0DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: ensure uffd-wp-mremap gets pages of each size
has been removed from the -mm tree.  Its filename was
     selftests-mm-ensure-uffd-wp-mremap-gets-pages-of-each-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

scripts-gdb-add-lx_per_cpu_ptr.patch

