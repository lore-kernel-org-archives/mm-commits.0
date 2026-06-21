Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF318370ACC
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067196; cv=none; b=SCinT5N8ZRYcDLGlaJdtrPikpkqLv/6F8yymsDVFqW01YDkVq0Bvo6Vs8fR5Op+En5xW+qZ9iy2tcUip5XsXEhrSlHoEnUsMNafTscIldz9zTUfLqXCv4ajFC8jlQBk2JBYcKmoZWO2AaNU8kdlMovjZVoRazy4lumXzV5kbZhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067196; c=relaxed/simple;
	bh=2rePqLoG/uRPDcnUb/SzFUO0Yid+XiHt65NsLN6G8b4=;
	h=Date:To:From:Subject:Message-Id; b=DZMT2hsnj7sW7X8HZZTqE6dLQpA5YjZHpxw3xAYWnSSCP4dpj6Tuc/Bc3PJO5dVDnDiFoHo5T0pwbz86ogM/EslmDVjDmwfWeFRNDTSAsSeqnICkJjLgX/4MOMHTPhUr5Tcknz3lT6CbYsUoo35JQFqmJZZWSIFGXQc0fhzHx8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FGC9RAhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FGC9RAhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DD21F000E9;
	Sun, 21 Jun 2026 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067195;
	bh=cXsX+d+vKtodBQhVNWZH+cFbuvYwXCVg+wDDLTkdLj8=;
	h=Date:To:From:Subject;
	b=FGC9RAhJWGJJ4kSobM4l01Hg6l4a+zX4+KA/Y3boZWID+/7uD/rWZqlDlpVHR39cG
	 YvWNaP5hhR2g1dJGD7niwvcpZf1vQoRwbKNC9lnAEdwd9qUrDF8LfZYcXTqhQheEC2
	 QQaxu9ANnrJzuxue5IbmCCbbE/XAvFS1pADa39Qc=
Date: Sun, 21 Jun 2026 11:39:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch removed from -mm tree
Message-Id: <20260621183955.82DD21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
Date: Thu, 21 May 2026 12:17:43 +0530

The test modifies nr_hugepages during execution and restores it from
cleanup() and again reconfigure it setup, which is invoked multiple times
across test flow.  This can lead to repeated allocation/freeing of
hugepages.

With set -e, failures in cleanup (e.g., rmdir/umount) can also cause early
exit before restoring the original value at the end.

Move restoration of the original nr_hugepages value to a trap handler
registered for EXIT, INT, and TERM signals so it is always restored on all
exit paths.  This also avoids unnecessary allocation churn across repeated
cleanup/setup cycles.

Link: https://lore.kernel.org/29db637c3c6ba6c168f6b33f59f059a0b39c35c8.1779296493.git.sayalip@linux.ibm.com
Fixes: 585a9145886a ("selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-restore-default-nr_hugepages-value-via-exit-trap-in-hugetlb_reparenting_testsh
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -12,6 +12,8 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
+
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -56,7 +58,6 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
@@ -240,4 +241,3 @@ if [[ $do_umount ]]; then
   rm -rf $CGROUP_ROOT
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


