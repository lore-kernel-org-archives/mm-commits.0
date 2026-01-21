Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE8361663
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966090; cv=none; b=qq52bWtZ7F0jWCWSJcIFTXPYtMMPm7yP2ShK8bVF12g0n7nJgRWuhD33KXSi2lskeNnLtrwZg1Vy8GVEGsPHfM5erblZILmKL+Mo+C1l7az3nqNn0BLlUlDmed+BsieMtjCGEZZWDHJPjFtiOFjWTmomhKhO78oSckfWn2LIUYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966090; c=relaxed/simple;
	bh=djVwbJPPS02nXrKFywkuRJYAOCocGOtN6T6jzwttTdo=;
	h=Date:To:From:Subject:Message-Id; b=HlbgRnZCbd/0BFFQ0oulXcXqKZy8sU0Vkh1xknKyYltHyq9z2GLoM4QXWihpo7sMatLN3ERvQsbM5t8C2mJpXnK9w5fof53r4k2dGyQwsIzVsY5T5FIoRBo1ra9FyNpzdb6I13Um7fgHGaVEH1OpcFaj/3CD4gl0C9V49TaTcqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=04CysLGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="04CysLGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44184C16AAE;
	Wed, 21 Jan 2026 03:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966090;
	bh=djVwbJPPS02nXrKFywkuRJYAOCocGOtN6T6jzwttTdo=;
	h=Date:To:From:Subject:From;
	b=04CysLGNeXSy8b45nBW1L4/RWox/qw1XZdF2g75IgxExo549321JvQ7HmioUygq7V
	 rBy7/XTKaM4hcazoSW31ortGvPjDMOSuholy3IFKtVlL9ohNMJc9hbYi0qNhPchN6+
	 /MjSTNVbmkqtuTcMU/rt5q78j++FMSDPi/Y7XpfQ=
Date: Tue, 20 Jan 2026 19:28:09 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,urezki@gmail.com,surenb@google.com,shuah@kernel.org,rppt@kernel.org,raquini@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,akpm@linux-foundation.org,audra@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-minor-fixes-to-test_vmallocc.patch removed from -mm tree
Message-Id: <20260121032810.44184C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc.c: minor fixes to test_vmalloc.c
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-minor-fixes-to-test_vmallocc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Audra Mitchell <audra@redhat.com>
Subject: lib/test_vmalloc.c: minor fixes to test_vmalloc.c
Date: Mon, 1 Dec 2025 13:18:48 -0500

If PAGE_SIZE is larger than 4k and if you have a system with a large
number of CPUs, this test can require a very large amount of memory
leading to oom-killer firing.  Given the type of allocation, the kernel
won't have anything to kill, causing the system to stall.

Add a parameter to the test_vmalloc driver to represent the number of
times a percpu object will be allocated.  Calculate this in
test_vmalloc.sh to be 90% of available memory or the current default of
35000, whichever is smaller.

Link: https://lkml.kernel.org/r/20251201181848.1216197-1-audra@redhat.com
Signed-off-by: Audra Mitchell <audra@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c                         |   11 ++++--
 tools/testing/selftests/mm/test_vmalloc.sh |   31 +++++++++++++++++--
 2 files changed, 35 insertions(+), 7 deletions(-)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-minor-fixes-to-test_vmallocc
+++ a/lib/test_vmalloc.c
@@ -58,6 +58,9 @@ __param(int, run_test_mask, 7,
 		/* Add a new test case description here. */
 );
 
+__param(int, nr_pcpu_objects, 35000,
+	"Number of pcpu objects to allocate for pcpu_alloc_test");
+
 /*
  * This is for synchronization of setup phase.
  */
@@ -317,24 +320,24 @@ pcpu_alloc_test(void)
 	size_t size, align;
 	int i;
 
-	pcpu = vmalloc(sizeof(void __percpu *) * 35000);
+	pcpu = vmalloc(sizeof(void __percpu *) * nr_pcpu_objects);
 	if (!pcpu)
 		return -1;
 
-	for (i = 0; i < 35000; i++) {
+	for (i = 0; i < nr_pcpu_objects; i++) {
 		size = get_random_u32_inclusive(1, PAGE_SIZE / 4);
 
 		/*
 		 * Maximum PAGE_SIZE
 		 */
-		align = 1 << get_random_u32_inclusive(1, 11);
+		align = 1 << get_random_u32_inclusive(1, PAGE_SHIFT - 1);
 
 		pcpu[i] = __alloc_percpu(size, align);
 		if (!pcpu[i])
 			rv = -1;
 	}
 
-	for (i = 0; i < 35000; i++)
+	for (i = 0; i < nr_pcpu_objects; i++)
 		free_percpu(pcpu[i]);
 
 	vfree(pcpu);
--- a/tools/testing/selftests/mm/test_vmalloc.sh~lib-test_vmallocc-minor-fixes-to-test_vmallocc
+++ a/tools/testing/selftests/mm/test_vmalloc.sh
@@ -13,6 +13,9 @@ TEST_NAME="vmalloc"
 DRIVER="test_${TEST_NAME}"
 NUM_CPUS=`grep -c ^processor /proc/cpuinfo`
 
+# Default number of times we allocate percpu objects:
+NR_PCPU_OBJECTS=35000
+
 # 1 if fails
 exitcode=1
 
@@ -27,6 +30,8 @@ PERF_PARAM="sequential_test_order=1 test
 SMOKE_PARAM="test_loop_count=10000 test_repeat_count=10"
 STRESS_PARAM="nr_threads=$NUM_CPUS test_repeat_count=20"
 
+PCPU_OBJ_PARAM="nr_pcpu_objects=$NR_PCPU_OBJECTS"
+
 check_test_requirements()
 {
 	uid=$(id -u)
@@ -47,12 +52,30 @@ check_test_requirements()
 	fi
 }
 
+check_memory_requirement()
+{
+	# The pcpu_alloc_test allocates nr_pcpu_objects per cpu. If the
+	# PAGE_SIZE is on the larger side it is easier to set a value
+	# that can cause oom events during testing. Since we are
+	# testing the functionality of vmalloc and not the oom-killer,
+	# calculate what is 90% of available memory and divide it by
+	# the number of online CPUs.
+	pages=$(($(getconf _AVPHYS_PAGES) * 90 / 100 / $NUM_CPUS))
+
+	if (($pages < $NR_PCPU_OBJECTS)); then
+		echo "Updated nr_pcpu_objects to 90% of available memory."
+		echo "nr_pcpu_objects is now set to: $pages."
+		PCPU_OBJ_PARAM="nr_pcpu_objects=$pages"
+	fi
+}
+
 run_performance_check()
 {
 	echo "Run performance tests to evaluate how fast vmalloc allocation is."
 	echo "It runs all test cases on one single CPU with sequential order."
 
-	modprobe $DRIVER $PERF_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $PERF_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel message buffer to see the summary."
 }
@@ -63,7 +86,8 @@ run_stability_check()
 	echo "available test cases are run by NUM_CPUS workers simultaneously."
 	echo "It will take time, so be patient."
 
-	modprobe $DRIVER $STRESS_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $STRESS_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel ring buffer to see the summary."
 }
@@ -74,7 +98,8 @@ run_smoke_check()
 	echo "Please check $0 output how it can be used"
 	echo "for deep performance analysis as well as stress testing."
 
-	modprobe $DRIVER $SMOKE_PARAM > /dev/null 2>&1
+	check_memory_requirement
+	modprobe $DRIVER $SMOKE_PARAM $PCPU_OBJ_PARAM > /dev/null 2>&1
 	echo "Done."
 	echo "Check the kernel ring buffer to see the summary."
 }
_

Patches currently in -mm which might be from audra@redhat.com are


