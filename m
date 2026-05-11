Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D334D90CC
	for <mm-commits@vger.kernel.org>; Mon, 11 May 2026 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778535375; cv=none; b=fKhvXGjJYHOsXQ19FjiDpCtoWmDQdyqXQWQbohsYMAASiKWMQKDA2pStIE5QYHnfaqIF9sHUv5KRqIeWBHlOR4YL5pGo0GKKvQAu+cFxm6AHYEP6WGexdDY6OuqZv16dVoDZ5f8SrHkzJdSUgs131tVzpnWaR11Tcg7f3LQDcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778535375; c=relaxed/simple;
	bh=oqPsjRmSQK0tLi5tk1/BZXtmdvctfm10wT1l+wwOXLQ=;
	h=Date:To:From:Subject:Message-Id; b=qe7TkoZkdkY35F7erHquMuJeo33bD8CuFh9jFwih/VxLnIPuB06HoPqzzoOnz1d3qouDYultWeN0/h0aJWf6r6f2qdGyXp3Fl89576bgbrdBVPu5BfuE8BYdnsEB03x/Xhqui15grN7xco8Cdwg7ZUi6jG6ilQvgTJqLIFEYoDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S57HALK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S57HALK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA3CC2BCFA;
	Mon, 11 May 2026 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778535375;
	bh=oqPsjRmSQK0tLi5tk1/BZXtmdvctfm10wT1l+wwOXLQ=;
	h=Date:To:From:Subject:From;
	b=S57HALK51qrsbo00A7VrBuay94uPrUH4glKfSgrgTftcwpLwmvzvKt5AJPbGBmfoo
	 NyFWDjKo0fapNTILOyY/UpQvgG0iO/gtn/oHtBhfXqJZSC3lHwGM1FdonJ+fkD6DLR
	 kNEBqpXUR6Z7heaDyfBs2D18RHMWHL4JaUPjj98g=
Date: Mon, 11 May 2026 14:36:14 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch added to mm-new branch
Message-Id: <20260511213615.3AA3CC2BCFA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb.patch

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
Subject: selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
Date: Mon, 11 May 2026 19:28:39 +0300

All the tests that use HugeTLB can detect and setup HugeTLB pages on their
own.

Drop detection and setup of HugeTLB from run_vmtests.sh.

Link: https://lore.kernel.org/20260511162840.375890-56-rppt@kernel.org
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

 tools/testing/selftests/mm/run_vmtests.sh |  125 +-------------------
 1 file changed, 7 insertions(+), 118 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-drop-detection-and-setup-of-hugetlb
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -132,7 +132,7 @@ test_selected() {
 
 run_gup_matrix() {
     # -t: thp=on, -T: thp=off, -H: hugetlb=on
-    local hugetlb_mb=$(( needmem_KB / 1024 ))
+    local hugetlb_mb=256
 
     for huge in -t -T "-H -m $hugetlb_mb"; do
         # -u: gup-fast, -U: gup-basic, -a: pin-fast, -b: pin-basic, -L: pin-longterm
@@ -154,60 +154,6 @@ run_gup_matrix() {
     done
 }
 
-# get huge pagesize and freepages from /proc/meminfo
-while read -r name size unit; do
-	if [ "$name" = "HugePages_Free:" ]; then
-		freepgs="$size"
-	fi
-	if [ "$name" = "Hugepagesize:" ]; then
-		hpgsize_KB="$size"
-	fi
-done < /proc/meminfo
-
-# Simple hugetlbfs tests have a hardcoded minimum requirement of
-# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
-# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
-# both of these requirements into account and attempt to increase
-# number of huge pages available.
-nr_cpus=$(nproc)
-uffd_min_KB=$((hpgsize_KB * nr_cpus * 2))
-hugetlb_min_KB=$((256 * 1024))
-if [[ $uffd_min_KB -gt $hugetlb_min_KB ]]; then
-	needmem_KB=$uffd_min_KB
-else
-	needmem_KB=$hugetlb_min_KB
-fi
-
-# set proper nr_hugepages
-if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	orig_nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	needpgs=$((needmem_KB / hpgsize_KB))
-	tries=2
-	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
-		lackpgs=$((needpgs - freepgs))
-		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + orig_nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
-			echo "Please run this test as root"
-			exit $ksft_skip
-		fi
-		while read -r name size unit; do
-			if [ "$name" = "HugePages_Free:" ]; then
-				freepgs=$size
-			fi
-		done < /proc/meminfo
-		tries=$((tries - 1))
-	done
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$freepgs" -lt "$needpgs" ]; then
-		printf "Not enough huge pages available (%d < %d)\n" \
-		       "$freepgs" "$needpgs"
-	fi
-	HAVE_HUGEPAGES=1
-else
-	echo "no hugetlbfs support in kernel?"
-	HAVE_HUGEPAGES=0
-fi
-
 # filter 64bit architectures
 ARCH64STR="arm64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
 if [ -z "$ARCH" ]; then
@@ -277,29 +223,13 @@ run_test() {
 echo "TAP version 13" | tap_output
 
 CATEGORY="hugetlb" run_test ./hugetlb-mmap
-
-shmmax=$(cat /proc/sys/kernel/shmmax)
-shmall=$(cat /proc/sys/kernel/shmall)
-echo 268435456 > /proc/sys/kernel/shmmax
-echo 4194304 > /proc/sys/kernel/shmall
 CATEGORY="hugetlb" run_test ./hugetlb-shm
-echo "$shmmax" > /proc/sys/kernel/shmmax
-echo "$shmall" > /proc/sys/kernel/shmall
-
 CATEGORY="hugetlb" run_test ./hugetlb-mremap
 CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
-
-if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
-	# For this test, we need one and just one huge page
-	echo 1 > /proc/sys/vm/nr_hugepages
-	CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
-	CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
-	# Restore the previous number of huge pages, since further tests rely on it
-	echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
-fi
+CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
@@ -326,44 +256,11 @@ CATEGORY="gup_test" run_test ./gup_longt
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
-# Hugetlb tests require source and destination huge pages. Pass in almost half
-# the size of the free pages we have, which is used for *each*. An adjustment
-# of (nr_parallel - 1) is done (see nr_parallel in uffd-stress.c) to have some
-# extra hugepages - this is done to prevent the test from failing by racily
-# reserving more hugepages than strictly required.
-# uffd-stress expects a region expressed in MiB, so we adjust
-# half_ufd_size_MB accordingly.
-adjustment=$(( (31 < (nr_cpus - 1)) ? 31 : (nr_cpus - 1) ))
-half_ufd_size_MB=$((((freepgs - adjustment) * hpgsize_KB) / 1024 / 2))
-CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
-CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb 128 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private 128 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem-private 20 16
-# uffd-wp-mremap requires at least one page of each size.
-have_all_size_hugepgs=true
-declare -A nr_size_hugepgs
-for f in /sys/kernel/mm/hugepages/**/nr_hugepages; do
-	old=$(cat $f)
-	nr_size_hugepgs["$f"]="$old"
-	if [ "$old" == 0 ]; then
-		echo 1 > "$f"
-	fi
-	if [ $(cat "$f") == 0 ]; then
-		have_all_size_hugepgs=false
-		break
-	fi
-done
-if $have_all_size_hugepgs; then
-	CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
-else
-	echo "# SKIP ./uffd-wp-mremap"
-fi
-
-#cleanup
-for f in "${!nr_size_hugepgs[@]}"; do
-	echo "${nr_size_hugepgs["$f"]}" > "$f"
-done
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
+CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
 
 CATEGORY="compaction" run_test ./compaction_test
 
@@ -388,12 +285,10 @@ CATEGORY="mremap" run_test ./mremap_test
 CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
+
 if $RUN_DESTRUCTIVE; then
-nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
 enable_soft_offline=$(cat /proc/sys/vm/enable_soft_offline)
-echo 8 > /proc/sys/vm/nr_hugepages
 CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
-echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
@@ -449,7 +344,6 @@ CATEGORY="ksm_numa" run_test ./ksm_tests
 CATEGORY="ksm" run_test ./ksm_functional_tests
 
 # protection_keys tests
-nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 if [ -x ./protection_keys_32 ]
 then
 	CATEGORY="pkey" run_test ./protection_keys_32
@@ -459,7 +353,6 @@ if [ -x ./protection_keys_64 ]
 then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 if [ -x ./soft-dirty ]
 then
@@ -548,10 +441,6 @@ if [ -n "${LOADED_MOD}" ]; then
 	modprobe -r hwpoison_inject > /dev/null 2>&1
 fi
 
-if [ "${HAVE_HUGEPAGES}" = 1 ]; then
-	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
-fi
-
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
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

