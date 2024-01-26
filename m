Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073A93232
	for <mm-commits@vger.kernel.org>; Fri, 26 Jan 2024 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235348; cv=none; b=rFB8DtH/XM1uzx6OZ7YS78i/aO+pNMuXYtFswLC9Hbb/eDG9w1+rM/TVxAkyIC5C6EvaXL6tcWdNnWz9/+OJBef1+0IpAxYbk/Ptd6Y5Rnx3KAR/x+hQNdGkOApbNIU0VEemdbfmXMPWfWM/ybDTcTdYZYvhxTGNcTaH/CBSNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235348; c=relaxed/simple;
	bh=hbusMVtyw4DFS9c+R2UDbuOPUe0JHxo+EvysDWuOH3k=;
	h=Date:To:From:Subject:Message-Id; b=phco1fbtnkyflhPjdllKTeevbtEV3Vj8Bnxzt6IF16oAlVjDFu2e499zrX93RgslgY4+FRA0rz4l9AoO+IuEF/nEohylII/xHyvbJIkMN4eQQFCpyF64HUmbqpa2d9mBYkuRwhVuUX6dZt3vaRMXmifyGNzyJ70ckaGac0+tAT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NPLvhuQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NPLvhuQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C91AC433F1;
	Fri, 26 Jan 2024 02:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235347;
	bh=hbusMVtyw4DFS9c+R2UDbuOPUe0JHxo+EvysDWuOH3k=;
	h=Date:To:From:Subject:From;
	b=NPLvhuQ150VMxwduz4g9k4Z1WO3/rZRZ3OH7nzyD0EPdNza/IJup0JyBMOhmWwAkq
	 wbgTh6XO8iDW+G9VhVnjdSt9sDgCyqFNfHhZ8zmQDFEFgn+HMYuCmJlNmNd7onkfhj
	 iZIkFwFAQNE9/2JvXk8MW8yKj8lzILBRJIVbrLyo=
Date: Thu, 25 Jan 2024 18:15:44 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,usama.anjum@collabora.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-save-and-restore-nr_hugepages-value.patch added to mm-nonmm-unstable branch
Message-Id: <20240126021547.1C91AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: save and restore nr_hugepages value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-mm-save-and-restore-nr_hugepages-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-save-and-restore-nr_hugepages-value.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

selftests-mm-mremap_test-fix-build-warning.patch
selftests-mm-switch-to-bash-from-sh.patch
selftests-mm-hugetlb_reparenting_test-do-not-unmount.patch
selftests-mm-run_vmtests-remove-sudo-and-conform-to-tap.patch
selftests-mm-save-and-restore-nr_hugepages-value.patch
selftests-mm-protection_keys-save-restore-nr_hugepages-settings.patch
selftests-mm-run_vmtestssh-add-missing-tests.patch

