Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649A113B297
	for <mm-commits@vger.kernel.org>; Wed, 21 Aug 2024 21:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275683; cv=none; b=e+aoExVXxnnvYZaYu+KXb0iCJ2lm82HjLYHuG/OQ3pOOZROIBIkfnPmYILszmDYnXJ5k18Wl9cHonXqREI7h6qtINID5sJn/q0QW/gATcKd0ZT7+Vi8IaePjfekgNx9f8X//VgE0EVhJwuidz99KK1l8WgkSSuMDfeZPUv11w6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275683; c=relaxed/simple;
	bh=uOOFGHhmkvlSXTehesp+Bgszs2P/fXJ/QrmcEj1P9aQ=;
	h=Date:To:From:Subject:Message-Id; b=Y9tu4F53q7R/Zbde6+cLZ8rsTl3DfWO0pdhSU8jHv+kCEAsyULhnSUo4GYrFxgI5OArshWiiGzq7UW5gt8TUF8qbMXFKFz3Y/fAYcUp+0l6m1/NwO4Ba+CmZBhvZ5nvEZ2L9c0RrlnjZZugQEvmVDJ0vi97bMiwOm7SN5VehaPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C01zctXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C01zctXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38D5C4AF0E;
	Wed, 21 Aug 2024 21:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724275682;
	bh=uOOFGHhmkvlSXTehesp+Bgszs2P/fXJ/QrmcEj1P9aQ=;
	h=Date:To:From:Subject:From;
	b=C01zctXRzwJ+E/jTzAAiNR9xURaPAI8lfp1YRPc/HjWCx5PPfqtU2vzhMQyMzhJH7
	 gtwRhVklls4fTYji54ugZjSCA9knwy0ud70FMsvvfWIlJ0+PHEqU5JdD96Dff8N5e+
	 VVBiF4xTYAMzynDpNg8bGoWsaFVejwhvgxUzEJhM=
Date: Wed, 21 Aug 2024 14:28:01 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,muchun.song@linux.dev,mcasquer@redhat.com,almasrymina@google.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-fix-charge_reserved_hugetlbsh-test.patch added to mm-unstable branch
Message-Id: <20240821212802.C38D5C4AF0E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: fix charge_reserved_hugetlb.sh test
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests/mm: fix charge_reserved_hugetlb.sh test
Date: Wed, 21 Aug 2024 14:31:15 +0200

Currently, running the charge_reserved_hugetlb.sh selftest we can
sometimes observe something like:

  $ ./charge_reserved_hugetlb.sh -cgroup-v2
  ...
  write_result is 0
  After write:
  hugetlb_usage=0
  reserved_usage=10485760
  killing write_to_hugetlbfs
  Received 2.
  Deleting the memory
  Detach failure: Invalid argument
  umount: /mnt/huge: target is busy.

Both cases are issues in the test.

While the unmount error seems to be racy, it will make the test fail:
	$ ./run_vmtests.sh -t hugetlb
	...
	# [FAIL]
	not ok 10 charge_reserved_hugetlb.sh -cgroup-v2 # exit=32

The issue is that we are not waiting for the write_to_hugetlbfs process to
quit.  So it might still have a hugetlbfs file open, about which umount is
not happy.  Fix that by making "killall" wait for the process to quit.

The other error ("Detach failure: Invalid argument") does not seem to
result in a test error, but is misleading.  Turns out write_to_hugetlbfs.c
unconditionally tries to cleanup using shmdt(), even when we only
mmap()'ed a hugetlb file.  Even worse, shmaddr is never even set for the
SHM case.  Fix that as well.

With this change it seems to work as expected.

Link: https://lkml.kernel.org/r/20240821123115.2068812-1-david@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Mario Casquero <mcasquer@redhat.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    2 
 tools/testing/selftests/mm/write_to_hugetlbfs.c       |   21 +++++-----
 2 files changed, 13 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-fix-charge_reserved_hugetlbsh-test
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -254,7 +254,7 @@ function cleanup_hugetlb_memory() {
   local cgroup="$1"
   if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
     echo killing write_to_hugetlbfs
-    killall -2 write_to_hugetlbfs
+    killall -2 --wait write_to_hugetlbfs
     wait_for_hugetlb_memory_to_get_depleted $cgroup
   fi
   set -e
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-fix-charge_reserved_hugetlbsh-test
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -28,7 +28,7 @@ enum method {
 
 /* Global variables. */
 static const char *self;
-static char *shmaddr;
+static int *shmaddr;
 static int shmid;
 
 /*
@@ -47,15 +47,17 @@ void sig_handler(int signo)
 {
 	printf("Received %d.\n", signo);
 	if (signo == SIGINT) {
-		printf("Deleting the memory\n");
-		if (shmdt((const void *)shmaddr) != 0) {
-			perror("Detach failure");
+		if (shmaddr) {
+			printf("Deleting the memory\n");
+			if (shmdt((const void *)shmaddr) != 0) {
+				perror("Detach failure");
+				shmctl(shmid, IPC_RMID, NULL);
+				exit(4);
+			}
+
 			shmctl(shmid, IPC_RMID, NULL);
-			exit(4);
+			printf("Done deleting the memory\n");
 		}
-
-		shmctl(shmid, IPC_RMID, NULL);
-		printf("Done deleting the memory\n");
 	}
 	exit(2);
 }
@@ -211,7 +213,8 @@ int main(int argc, char **argv)
 			shmctl(shmid, IPC_RMID, NULL);
 			exit(2);
 		}
-		printf("shmaddr: %p\n", ptr);
+		shmaddr = ptr;
+		printf("shmaddr: %p\n", shmaddr);
 
 		break;
 	default:
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk-fix.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch
mm-rmap-minimize-folio-_nr_pages_mapped-updates-when-batching-pte-unmapping.patch
mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

