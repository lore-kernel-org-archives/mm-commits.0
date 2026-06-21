Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84AA36F8F0
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067193; cv=none; b=TUT1Cl8GnHErS5SciExzdOBkU4Cgj3zJbTcMrXRnwMwpWqZPz/hSYEwF08LFkNNYkXRB1L89YxWfrwXb/1NzJ31O8mGusCityc7rQUCMag8frahA+BoWC8Xl9obKJZtPw3k1/AgFtDbvgxY4jOyvf2GABFX1Qb/iXUay3eovxGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067193; c=relaxed/simple;
	bh=K1OrjPggNt0eEHzR5zWxs+9kdjJygXvmy5BLYLKUXT0=;
	h=Date:To:From:Subject:Message-Id; b=XUuNzzd2Bve5m22m51g2kRkyeyPpHD5DSoAb5rpNEJ9K1xhq/XZJ9Gh+wXS+HkhyuDoqtb1o8BDxc8CDl4QDG5Dg0WnDq+aD3c97L2Wv9d9EYtXH0JH79lWi5oK15UCdtFxGwbfjAH9goCukQEJ+tLQkD0zQ5SlpvLKa6IXoDCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aMxGiwjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aMxGiwjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBDB1F00A3A;
	Sun, 21 Jun 2026 18:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067192;
	bh=q8eBrSRTRnz+d2hkYncmngEKVaAbQAND7G5bFFjBgIs=;
	h=Date:To:From:Subject;
	b=aMxGiwjU9Mn5AO17BIRpwIlI9QRojSZwdYwgelok0JFI7/3r1j8OVAypk9ClXTz6t
	 lixaM4d+SI26KJ8LtCVwXiTAOhy8x8QWz/27i9pp30TRT9piCcOR3tj/4pObit3lAs
	 yEZnTQRqdon9Rc4ugYYMH1rmMaOabTMZ2wAotPaE=
Date: Sun, 21 Jun 2026 11:39:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch removed from -mm tree
Message-Id: <20260621183952.ABBDB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
Date: Thu, 21 May 2026 12:03:27 +0530

Patch series "selftests/mm: fix failures and robustness improvements", v7.

Powerpc systems with a 64K base page size exposed several issues while
running mm selftests. Some tests assume specific hugetlb configurations,
use incorrect interfaces, or fail instead of skipping when the required
kernel features are not available.

This series fixes these issues and improves test robustness.


This patch (of 13):

cleanup() resets nr_hugepages to 0 on every invocation, while the test
reconfigures it again in the next iteration.  This leads to repeated
allocation and freeing of large numbers of hugepages, especially when the
original value is high.

Additionally, with set -e, failures in earlier cleanup steps (e.g., rmdir
or umount returning EBUSY while background activity is still ongoing) can
cause the script to exit before restoring the original value, leaving the
system in a modified state.

Introduce a trap on EXIT, INT, and TERM to restore the original
nr_hugepages value once at script termination.  This avoids unnecessary
allocation churn and ensures the original value is reliably restored on
all exit paths.

Link: https://lore.kernel.org/cover.1779296493.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/5b8fbb29cd6ceffe6752e0af104f60cec072aa10.1779296493.git.sayalip@linux.ibm.com
Fixes: 7d695b1c3695 ("selftests/mm: save and restore nr_hugepages value")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-charge_reserved_hugetlbsh
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -17,6 +17,7 @@ if ! command -v killall >/dev/null 2>&1;
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -70,7 +71,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -599,4 +599,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


