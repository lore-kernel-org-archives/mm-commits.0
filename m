Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3941C76408
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103949; cv=none; b=i0z2lPKf8KF4uYSpgRGWiA4EJh2MRC5c+n3RUGeIxygKAz5Zpl/ih1prxkDo8+XxPgZ9FTj35DhmvQ07sikIF9OALSzpgdlqebdMuwCQalt3Kem1X7jG1vN6dDBQ/P9DJT7WjpS7VFe16wH4aGM2HzMp0j5d7FoHuj8n5k+wfHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103949; c=relaxed/simple;
	bh=HvOrFYySAYfDGfqTI/3XVafmnE3ibfRUEQ9YPv1hMns=;
	h=Date:To:From:Subject:Message-Id; b=NiL8tnE99tnJJCFiT0ZiK+BhbXvkFIbQAnoK3q3vie4nD0pS1K3Ij2r/TSbzS088aYKltbCMd9uw8VyQ7OZFSOtA0PMrcmIX9k59BPACYc+3CYE3A57y7G3kaFb0ob8KCvrz7mpBGo/iOJ6nzJ1kr2RCPSF+6zZucipSqUcdcJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E2EgfqnR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E2EgfqnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F83FC113CD;
	Fri, 26 Apr 2024 03:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103949;
	bh=HvOrFYySAYfDGfqTI/3XVafmnE3ibfRUEQ9YPv1hMns=;
	h=Date:To:From:Subject:From;
	b=E2EgfqnROm4KUD2Y8qvcoSBTF2YId+LyZYyFo/CNt2w4OpFDdor/wqC46ondXhNLw
	 IeyqSjy5TnjNOpMvHGp2u1ZTgQrDcZcFrKD6S7tdgzWv2NbOlqUYSC3l/Ztsqv0ccc
	 qLkr22KHLoTQSB68eM1GFw/DVZQlPawAkAQ+/0HM=
Date: Thu, 25 Apr 2024 20:59:08 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,ryan.roberts@arm.com,npache@redhat.com,muchun.song@linux.dev,david@redhat.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch removed from -mm tree
Message-Id: <20240426035909.0F83FC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
has been removed from the -mm tree.  Its filename was
     selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: selftests/mm: run_vmtests.sh: fix hugetlb mem size calculation
Date: Thu, 21 Mar 2024 17:50:47 -0400

The script calculates a mininum required size of hugetlb memories, but
it'll stop working with <1MB huge page sizes, reporting all zeros even if
huge pages are available.

In reality, the calculation doesn't really need to be as complicated
either.  Make it simpler and work for KB-level hugepages too.

[peterx@redhat.com: run_vmtests.sh: fix hugetlb mem size calculation]
  Link: https://lkml.kernel.org/r/20240403200324.1603493-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240321215047.678172-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Nico Pache <npache@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-hugetlb-mem-size-calculation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -152,9 +152,13 @@ done < /proc/meminfo
 # both of these requirements into account and attempt to increase
 # number of huge pages available.
 nr_cpus=$(nproc)
-hpgsize_MB=$((hpgsize_KB / 1024))
-half_ufd_size_MB=$((((nr_cpus * hpgsize_MB + 127) / 128) * 128))
-needmem_KB=$((half_ufd_size_MB * 2 * 1024))
+uffd_min_KB=$((hpgsize_KB * nr_cpus * 2))
+hugetlb_min_KB=$((256 * 1024))
+if [[ $uffd_min_KB -gt $hugetlb_min_KB ]]; then
+	needmem_KB=$uffd_min_KB
+else
+	needmem_KB=$hugetlb_min_KB
+fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
@@ -294,7 +298,8 @@ CATEGORY="userfaultfd" run_test ./uffd-u
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
 # Hugetlb tests require source and destination huge pages. Pass in half
-# the size ($half_ufd_size_MB), which is used for *each*.
+# the size of the free pages we have, which is used for *each*.
+half_ufd_size_MB=$((freepgs / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

