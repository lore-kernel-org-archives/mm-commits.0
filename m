Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6A137919
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645213; cv=none; b=S+K8Xo5O6U/jh+I+aI6g2F4SQM0yVOGOlvkd89npKi8XJEE2dHrr+bF0LTnPV+YUPdpMkEP29wbW2VAh/BQIXu1h/hh8qsXeIbYbxo1f/e9xPKOFXjdH8KPMeiM8wZgxGBo/WTBQkEIz9Hbrs9EPaluJxtvNYo+ESwtnhq8Z5Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645213; c=relaxed/simple;
	bh=XvfNyap5zExHvGGckrdzJcMHCKZaDsaI7EGp3Jt5izc=;
	h=Date:To:From:Subject:Message-Id; b=rJ2pAb+kCzkVoWcRaghBw3Hor3Rb9Wd+d2qq68bf3Tn+dFUeUlxHuJdrdcA0IQvF6I+6pM4I+nwsjq4WthYXc54xusUQbCpHtT3JnXt0XCO9A4jeqTMRTgLj+FR5iDKt2mwoNNcxaVaqZbnK15iV4EdadVqqxMdCxlkwkz92v+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qf+3Y7ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qf+3Y7ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E750C433F1;
	Thu, 22 Feb 2024 23:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645213;
	bh=XvfNyap5zExHvGGckrdzJcMHCKZaDsaI7EGp3Jt5izc=;
	h=Date:To:From:Subject:From;
	b=qf+3Y7ZB0Vq1zRHeDFzeYLVBrh/fVa6OcAH1Q4bG6pquqcHgtUpmLkGwl/zNrOGOi
	 sJvY8H+A+Og4axxRTvB3ZOJupgFOctdvhWZVZ4mHDd0X45MWx+in5vauo+MTm8c2ZY
	 zozidC1vCtXTG5ww+Bu17BVG6fVLcMrYBptdfDpE=
Date: Thu, 22 Feb 2024 15:40:12 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-save-and-restore-nr_hugepages-value.patch removed from -mm tree
Message-Id: <20240222234013.5E750C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: save and restore nr_hugepages value
has been removed from the -mm tree.  Its filename was
     selftests-mm-save-and-restore-nr_hugepages-value.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: selftests/mm: save and restore nr_hugepages value
Date: Thu, 25 Jan 2024 20:46:06 +0500

Save and restore nr_hugepages before changing it during the test.  A test
should not change system wide settings.

Link: https://lkml.kernel.org/r/20240125154608.720072-4-usama.anjum@collabora.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh  |    4 ++++
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh |    3 +++
 2 files changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-save-and-restore-nr_hugepages-value
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -11,6 +11,8 @@ if [[ $(id -u) -ne 0 ]]; then
   exit $ksft_skip
 fi
 
+nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
 fault_usage_file=usage_in_bytes
@@ -582,3 +584,5 @@ if [[ $do_umount ]]; then
   umount $cgroup_path
   rmdir $cgroup_path
 fi
+
+echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh~selftests-mm-save-and-restore-nr_hugepages-value
+++ a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -11,6 +11,7 @@ if [[ $(id -u) -ne 0 ]]; then
   exit $ksft_skip
 fi
 
+nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -252,3 +253,5 @@ if [[ $do_umount ]]; then
   umount $CGROUP_ROOT
   rm -rf $CGROUP_ROOT
 fi
+
+echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
_

Patches currently in -mm which might be from usama.anjum@collabora.com are


