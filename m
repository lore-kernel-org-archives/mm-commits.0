Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B101D362135
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966107; cv=none; b=QmGHFfy66gbaD6YLwSpc45qf6w8Px9HTkwvB/GeUjPSd2wXpXcxpyURpDOzKHDclGHe2Ue4U/KPkzIvi13E2UKEmtkBh3in7SMcWeKN9j4SpkOkLhWnTzZVNyVMGyAxckztwgQS4+hAewk41Me2u4oJP2uzYbIs1slPHfahCoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966107; c=relaxed/simple;
	bh=q7OZzTG00aj0e/LQzW+ENS/ipa66fHbCJ6RIEQGLqu4=;
	h=Date:To:From:Subject:Message-Id; b=lIMvce1ulCPtQvBTWesgcp+cANPa7VtmOt7aTCnOiwy+3gAABTh9csU/we502/2Wp8yQXpM9htofLhkfqVz0cKjk4BP7C+xj3IM0i7dofYJA1JY7UyHiF8x5l0L4x7l36cecc70kHvePNUXcyPJi7PAXQ70cNgzt3Joc4IAHfj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=te8WTclC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="te8WTclC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8770EC16AAE;
	Wed, 21 Jan 2026 03:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966107;
	bh=q7OZzTG00aj0e/LQzW+ENS/ipa66fHbCJ6RIEQGLqu4=;
	h=Date:To:From:Subject:From;
	b=te8WTclCbZI2i3BtZxWnc5tmvtqK+NlR7iqQd8Hr/AHbD6KK0L4YGMTrMAkfZnwp8
	 Qa+K2/ruNcNGlg6yIeMzpaJq4R2HxxjbBvgqiBxMPZmmBvYeAQWrVF89M+qMACpNdh
	 Lzt/AXLJC8AdautzQEqJzFrgkDxCw6eRrOz8TJhc=
Date: Tue, 20 Jan 2026 19:28:27 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,longman@redhat.com,david@kernel.org,broonie@kernel.org,liwang@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch removed from -mm tree
Message-Id: <20260121032827.8770EC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/write_to_hugetlbfs: parse -s as size_t
has been removed from the -mm tree.  Its filename was
     selftests-mm-write_to_hugetlbfs-parse-s-as-size_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Wang <liwang@redhat.com>
Subject: selftests/mm/write_to_hugetlbfs: parse -s as size_t
Date: Sun, 21 Dec 2025 20:26:37 +0800

Patch series "selftests/mm: hugetlb cgroup charging: robustness fixes", v3.

This series fixes a few issues in the hugetlb cgroup charging selftests
(write_to_hugetlbfs.c + charge_reserved_hugetlb.sh) that show up on
systems with large hugepages (e.g.  512MB) and when failures cause the
test to wait indefinitely.

On an aarch64 64k page kernel with 512MB hugepages, the test consistently
fails in write_to_hugetlbfs with ENOMEM and then hangs waiting for the
expected usage values.  The root cause is that charge_reserved_hugetlb.sh
mounts hugetlbfs with a fixed size=256M, which is smaller than a single
hugepage, resulting in a mount with size=0 capacity.

In addition, write_to_hugetlbfs previously parsed -s via atoi() into an
int, which can overflow and print negative sizes.

Reproducer / environment:
  - Kernel: 6.12.0-xxx.el10.aarch64+64k
  - Hugepagesize: 524288 kB (512MB)
  - ./charge_reserved_hugetlb.sh -cgroup-v2
  - Observed mount: pagesize=512M,size=0 before this series

After applying the series, the test completes successfully on the above
setup.


This patch (of 3):

write_to_hugetlbfs currently parses the -s size argument with atoi() into
an int.  This silently accepts malformed input, cannot report overflow,
and can truncate large sizes.

=== Error log ===
 # uname -r
 6.12.0-xxx.el10.aarch64+64k

 # ls /sys/kernel/mm/hugepages/hugepages-*
 hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

 #./charge_reserved_hugetlb.sh -cgroup-v2
 # -----------------------------------------
 ...
 # nr hugepages = 10
 # writing cgroup limit: 5368709120
 # writing reseravation limit: 5368709120
 ...
 # Writing to this path: /mnt/huge/test
 # Writing this size: -1610612736        <--------

Switch the size variable to size_t and parse -s with sscanf("%zu", ...). 
Also print the size using %zu.

This avoids incorrect behavior with large -s values and makes the utility
more robust.

Link: https://lkml.kernel.org/r/20251221122639.3168038-1-liwang@redhat.com
Link: https://lkml.kernel.org/r/20251221122639.3168038-2-liwang@redhat.com
Signed-off-by: Li Wang <liwang@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/write_to_hugetlbfs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-write_to_hugetlbfs-parse-s-as-size_t
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -68,7 +68,7 @@ int main(int argc, char **argv)
 	int key = 0;
 	int *ptr = NULL;
 	int c = 0;
-	int size = 0;
+	size_t size = 0;
 	char path[256] = "";
 	enum method method = MAX_METHOD;
 	int want_sleep = 0, private = 0;
@@ -86,7 +86,10 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
 		switch (c) {
 		case 's':
-			size = atoi(optarg);
+			if (sscanf(optarg, "%zu", &size) != 1) {
+				perror("Invalid -s.");
+				exit_usage();
+			}
 			break;
 		case 'p':
 			strncpy(path, optarg, sizeof(path) - 1);
@@ -131,7 +134,7 @@ int main(int argc, char **argv)
 	}
 
 	if (size != 0) {
-		printf("Writing this size: %d\n", size);
+		printf("Writing this size: %zu\n", size);
 	} else {
 		errno = EINVAL;
 		perror("size not found");
_

Patches currently in -mm which might be from liwang@redhat.com are


