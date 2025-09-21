Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3DA21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489969; cv=none; b=tE+GYt+j+oUbc5vw+7uc6NmQm/C4NwKHVGLvf403eet+hxxjWnts6WxYtr6cFqp98ESw4wbDlNUBYeyoRbCZzwGxbZzDewiVue3rFiH6Wbmj2Bg+/M64F4ZR7dHCQGEie9OY0zNe9MW+xJSRfX6bSREelAlH8bDfo1U8vxUCOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489969; c=relaxed/simple;
	bh=hSPHLYFlA0A2JV3FIsCatPW+ngfhrteYk7Rcpd7RALE=;
	h=Date:To:From:Subject:Message-Id; b=ZyTqQ7L+0ZwtCV02+FbZNdHccRAmF5TtyTimrPp60e6wB0GYhfXAZ1vm1SyyrovdtcSZ9zY7H8xuYRh+49c2ZRgFMz5BpCLDMfkLRHcpxHWxvE4wrsUg5MOMNPTphJP//r7/iHjBw8D77ZOlhv5oqgDGZLK80QIpDO2PYsKeCHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ilk+tY/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ilk+tY/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DDEC4CEE7;
	Sun, 21 Sep 2025 21:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489968;
	bh=hSPHLYFlA0A2JV3FIsCatPW+ngfhrteYk7Rcpd7RALE=;
	h=Date:To:From:Subject:From;
	b=Ilk+tY/3anhaUuxsOPziBZ0ZNHFdz/Ig6xScKCLHYQBWEfwRn0evSI+p8cZGId/pJ
	 ym/F4kUfUnaxP0Xnx6p7YQ5dhD1xx38k13Q/4j2AtRBW9PG8qGyyGGo7941l3AtfkK
	 R14n7n6PCf6jQ7w+Dtfexizwyg6nNnFzfNpLCVoc=
Date: Sun, 21 Sep 2025 14:26:08 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-hugepages-cleanup-too-early.patch removed from -mm tree
Message-Id: <20250921212608.94DDEC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix hugepages cleanup too early
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-hugepages-cleanup-too-early.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: fix hugepages cleanup too early
Date: Fri, 12 Sep 2025 09:37:09 +0800

Patch series "Fix va_high_addr_switch.sh test failure", v3.

These three patches fix the va_high_addr_switch.sh test failure on x86_64.

Patch 1 fixes the hugepage setup issue that nr_hugepages is reset too
early in run_vmtests.sh and break the later va_high_addr_switch testing.

Patch 2 adds hugepage setup in va_high_addr_switch test, so that it can
still work if vm_runtests.sh changes the hugepage setup someday.

Patch 3 fixes the test failure caused by the hint addr align method change
in hugetlb_get_unmapped_area().


This patch (of 3):

The nr_hugepgs variable is used to keep the original nr_hugepages at the
hugepage setup step at test beginning.  After userfaultfd test, a cleaup
is executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
/proc/sys//vm/nr_hugepages are reset to 'original' value before
userfaultfd test starts.

Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
the value before userfaultfd test starts.  'va_high_addr_swith.sh' tests
runs after that will possibly see no hugepages available for test, and got
EINVAL when mmap(HUGETLB), making the result invalid.

And before pkey tests, nr_hugepgs is changed to be used as a temp variable
to save nr_hugepages before pkey test, and restore it after pkey tests
finish.  The original nr_hugepages value is not tracked anymore, so no way
to restore it after all tests finish.

Add a new variable orig_nr_hugepgs to save the original nr_hugepages, and
and restore it to nr_hugepages after all tests finish.  And change to use
the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after
hugepage setup, it's also the value before userfaultfd test starts, and
the correct value to be restored after userfaultfd finishes.  The
va_high_addr_switch.sh broken will be resolved.

Link: https://lkml.kernel.org/r/20250912013711.3002969-1-chuhu@redhat.com
Link: https://lkml.kernel.org/r/20250912013711.3002969-2-chuhu@redhat.com
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-hugepages-cleanup-too-early
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -174,13 +174,13 @@ fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	orig_nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
 	tries=2
 	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
 		lackpgs=$((needpgs - freepgs))
 		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
+		if ! echo $((lackpgs + orig_nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
 			echo "Please run this test as root"
 			exit $ksft_skip
 		fi
@@ -191,6 +191,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_K
 		done < /proc/meminfo
 		tries=$((tries - 1))
 	done
+	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
@@ -540,6 +541,10 @@ CATEGORY="page_frag" run_test ./test_pag
 
 CATEGORY="rmap" run_test ./rmap
 
+if [ "${HAVE_HUGEPAGES}" = 1 ]; then
+	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
+fi
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
_

Patches currently in -mm which might be from chuhu@redhat.com are


