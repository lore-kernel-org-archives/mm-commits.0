Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554136F8F4
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067189; cv=none; b=sPknoWrIAP6i2WvqE/Beww4QCc6vF/IzHmM47iYk+rISAYa9/dXStjLYvpKwRSaizUupDeXSIV0IKxCDx6oQJtv0HhRyYLBhmVfZHudQAMYTv1Dje+PhcL2GLVFzcYwwe9GnkksJPR+tY2DLILmIT7Y0eyrzw75VINxioc0hAN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067189; c=relaxed/simple;
	bh=z1vrwOy/pbb/K5muvAxP4gFwO/WK2zG78XSSDQ01PVk=;
	h=Date:To:From:Subject:Message-Id; b=UXDTNcQSzQljyxj7fAOOBjfjW2RIDOsyrYMQniG352a+WPtBEZp9+D2r00RYIsGBcmtIu3tkWf+8dwU0FW++H74OXQlxjWpt1yqwlJwWLWKPjwIFMA7WPCshvOiM+raKfatbJ3jrxjyZdFK+v75rhunx17wAQkBPjlpJP8/pRps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJb1aElp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJb1aElp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11471F00A3A;
	Sun, 21 Jun 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067187;
	bh=ozLvmaw14yfvV7kAt5iuJNbDKhsHUcXtOENJMhEOdQQ=;
	h=Date:To:From:Subject;
	b=gJb1aElpvGBeFgfYNtCXyZterlhSXOePgJTmqf5W6S8sb+bmXtv7E8tb2dBmPqgg1
	 ROoT/WjMrJM5LwtKNO9VD0QzUrXD3TbCtjobufp7SbQXW1mTpRPMa8ymK64WdgGuul
	 5fB2+kX1g87j/GcYQ6W46afSk2Jtq403f0ko+cZc=
Date: Sun, 21 Jun 2026 11:39:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch removed from -mm tree
Message-Id: <20260621183947.C11471F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: free memory if available memory is low
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: run_vmtests.sh: free memory if available memory is low
Date: Mon, 11 May 2026 19:28:38 +0300

Currently when running THP and HugeTLB tests, if HAVE_HUGEPAGES is set
run_test() drops caches, compacts memory and runs the test.  But if
HAVE_HUGEPAGES is not set it skips the tests entirely, even if THP tests
have nothing to do with HAVE_HUGEPAGES.

Replace the check if HAVE_HUGEPAGES is set with a check of how much memory
is available.  If there is less than 256 MB of available memory, drop
caches and run compaction and then continue to run a test regardless of
HAVE_HUGEPAGES value.

Link: https://lore.kernel.org/20260511162840.375890-55-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -234,19 +234,17 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
-		local skip=0
-
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
-			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
+			mem_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
+			mem_Mb=$((mem_kb / 1024))
+
+			if (( $mem_Mb < 256 )); then
 				echo 3 > /proc/sys/vm/drop_caches
 				sleep 2
 				echo 1 > /proc/sys/vm/compact_memory
 				sleep 2
-			else
-				echo "hugepages not supported" | tap_prefix
-				skip=1
 			fi
 		fi
 
@@ -255,12 +253,8 @@ run_test() {
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-		if [ "${skip}" != "1" ]; then
-			("$@" 2>&1) | tap_prefix
-			local ret=${PIPESTATUS[0]}
-		else
-			local ret=$ksft_skip
-		fi
+                ("$@" 2>&1) | tap_prefix
+                local ret=${PIPESTATUS[0]}
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
_

Patches currently in -mm which might be from rppt@kernel.org are


