Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353DF4D90CC
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535373; cv=none; b=K9goOLTo1EYK1Lz5ybgyJ4eZbF9eDDq/MztIv19yTD1S3fjKZVnqCdMtiwTs5QXVNMwhIyeNTOnT6KPe2HawrLo4q4uAh8CnBXemK8TJkMq1/hmgFS0w9a6p9Pn6MkhU0RQ7VBOnUQzU//SJAhtwsZrnaFo5Xnrw0WUoA+x7ft4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535373; c=relaxed/simple;
	bh=yjPB0uNvRc8kgLgFV39Y8jc+d5HwVlqK3qqozXyW7lU=;
	h=Date:To:From:Subject:Message-Id; b=eS6z4DCJ655vzvOfm6AmezxID6YGBQLg9yi7xJHpxEBtfUZV26/WDYttsXdkN6Pw9J63m3tclh3IiaF97kWblEZq6cDLGohlmaQRe11HNEqwgXeBtvr9re+QJKpALk/3UE9HBcZaNoA+ChJZ/498PAUmedC1XvU49O7cGpQuTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XxCP3JoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XxCP3JoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC70C2BCF5;
	Mon, 11 May 2026 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535373;
	bh=yjPB0uNvRc8kgLgFV39Y8jc+d5HwVlqK3qqozXyW7lU=;
	h=Date:To:From:Subject:From;
	b=XxCP3JoQ7qws4d2i+2oCAkMLos8EpoXWVEEUR8zuRTmdew8mo5zLFSnRrhYlCs5xE
	 uTt7lmmpkknFO18V4boaHv+r5m9bwMUcLQVLjUYreY2vGTN2t4u9CyC8umD/go3UeK
	 vcPjzDevxJnvRQAK8qbiTNp5UbVC+dgzoTnzOXJI=
Date: Mon, 11 May 2026 14:36:12 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch added to mm-new branch
Message-Id: <20260511213613.0EC70C2BCF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: free memory if available memory is low
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch

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

maintainers-add-tree-for-kdump-and-kexec.patch
maintainers-add-kexec-list-to-live-update-entry.patch
sh-fix-fallout-from-zero_page-consolidation.patch
selftests-mm-hugetlb-read-hwpoison-add-sigbus-handler.patch
selftests-mm-migration-dont-assume-huge-page-is-twomeg.patch
selftests-mm-migration-make-nthreads-represent-number-of-working-threads.patch
selftests-mm-migration-properly-cleanup-forked-processes.patch
selftests-mm-run_vmtestssh-dont-gate-thp-and-ksm-tests-on-have_hugepages.patch
selftests-mm-merge-map_hugetlb-into-hugepage-mmap.patch
selftests-mm-rename-hugepage-tests-to-hugetlb.patch
selftests-mm-hugetlb-shm-use-kselftest-framework.patch
selftests-mm-hugetlb-vmemmap-use-kselftest-framework.patch
selftests-mm-hugetlb-madvise-use-kselftest-framework.patch
selftests-mm-hugetlb_madv_vs_map-use-kselftest-framework.patch
selftests-mm-hugetlb-read-hwpoison-use-kselftest-framework.patch
selftests-mm-khugepaged-group-tests-in-an-array.patch
selftests-mm-khugepaged-use-ksefltest-framework.patch
selftests-mm-ksm_tests-use-kselftest-framework.patch
selftests-mm-protection_keys-use-descriptive-test-names-in-the-output.patch
selftests-mm-protection_keys-use-kselftest-framework.patch
selftests-mm-uffd-common-use-kselftest-framework.patch
selftests-mm-uffd-stress-use-kselftest-framework.patch
selftests-mm-uffd-unit-tests-use-kselftest-framework.patch
selftests-mm-va_high_addr_switch-use-kselftest-framework.patch
selftests-mm-add-atexit-and-signal-handlers-to-thp_settings.patch
selftests-mm-rename-thp_settings-to-hugepage_settings.patch
selftests-mm-move-hugetlb-helpers-to-hugepage_settings.patch
selftests-mm-hugepage_settings-use-unsigned-long-in-detect_hugetlb_page_size.patch
selftests-mm-hugepage_settings-add-apis-to-get-and-set-nr_hugepages.patch
selftests-mm-hugepage_settings-rename-and-rework-get_free_hugepages.patch
selftests-mm-hugepage_settings-add-apis-for-hugetlb-setup-and-teardown.patch
selftests-mm-move-read_file-read_num-and-write_num-to-vm_util.patch
selftests-mm-vm_util-add-helpers-to-set-and-restore-shm-limits.patch
selftests-mm-compaction_test-use-hugetlb-helpers.patch
selftests-mm-cow-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_longterm-add-setup-of-hugetlb-pages.patch
selftests-mm-gup_test-add-setup-of-hugetlb-pages.patch
selftests-mm-hmm-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-hugepage_dio-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_fault_after_madv-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-madvise-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mmap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-shm-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-soft-offline-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb-vmemmap-add-setup-of-hugetlb-pages.patch
selftests-mm-migration-add-setup-of-hugetlb-pages.patch
selftests-mm-pagemap_ioctl-add-setup-of-hugetlb-pages.patch
selftests-mm-protection_keys-use-library-code-for-hugetlb-setup.patch
selftests-mm-thuge-gen-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-stress-use-hugetlb_save-and-alloc-huge-pages.patch
selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch
selftests-mm-uffd-wp-mremap-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switch-add-setup-of-hugetlb-pages.patch
selftests-mm-va_high_addr_switchsh-drop-huge-pages-setup.patch
selftests-mm-run_vmtestssh-free-memory-if-available-memory-is-low.patch
selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

