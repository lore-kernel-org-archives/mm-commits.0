Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F67361DA8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966112; cv=none; b=PNWo2g3tFtENcpgIvZm5mLy6YRD6aFs4V7C8JAm7KqUaToEBB/DwjgJ4BEuMZmCoTOLIPSg89pfnsqlqQE7Q5VSa505hugbkTJo2sjAWnGB+aRXWn5pniIgFEjeLNJsBJ55ycOcvNgcg/0GB/9yE1wasQKGD1cCJIYlGRMIrX8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966112; c=relaxed/simple;
	bh=M01zdHdkjLfVEd961N2Hrl9dM030eVCIpcwoPM0EA6A=;
	h=Date:To:From:Subject:Message-Id; b=gblMwDMT5DiiE8HDSJeCBQWkgR5neLGrZM8AE4Lpkk+KiKrsn7/do+ZUDOcXO4mW/KzjTE/v/kI2YD3OyZ/yfTP86kq2xKuwFztnqHCq4w6NekAaJS7jntjINPor5hTTa/Lh/9SMUSGt3d9E8EQvhZPMRn/eTy+LSqpKVTu8O/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxN3NHy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxN3NHy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3ECC16AAE;
	Wed, 21 Jan 2026 03:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966112;
	bh=M01zdHdkjLfVEd961N2Hrl9dM030eVCIpcwoPM0EA6A=;
	h=Date:To:From:Subject:From;
	b=ZxN3NHy65DXQOHbMV2Q5wcdzEaD3ASJkXZZJxHiHtuj5LBn0F1AAXQfjQTNJwN4Co
	 qd/iTG01qQ4Y2HfywMrwsQiwis0V1lQx+zaTf0r7nGlNXi1o5V6YLNZuo1h1+0nkSH
	 ZycAu+H2o2ILXWnoG1e4U0VNc2Lbg7im5luNfczE=
Date: Tue, 20 Jan 2026 19:28:32 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,luizcap@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,chuhu@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch removed from -mm tree
Message-Id: <20260121032832.8F3ECC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
has been removed from the -mm tree.  Its filename was
     selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chunyu Hu <chuhu@redhat.com>
Subject: selftests/mm: allocate 6 hugepages in va_high_addr_switch.sh
Date: Sun, 21 Dec 2025 12:00:22 +0800

The va_high_addr_switch test requires 6 hugepages, not 5. If running the
test directly by: ./va_high_addr_switch.sh, the test will hit a mmap 'FAIL'
caused by not enough hugepages:

  mmap(addr_switch_hint - hugepagesize, 2*hugepagesize, MAP_HUGETLB): 0x7f330f800000 - OK
  mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0xffffffffffffffff - FAILED

The failure can't be hit if run the tests by running 'run_vmtests.sh -t
hugevm' because the nr_hugepages is set to 128 at the beginning of
run_vmtests.sh and va_high_addr_switch.sh skip the setup of nr_hugepages
because already enough.

Link: https://lkml.kernel.org/r/20251221040025.3159990-2-chuhu@redhat.com
Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/va_high_addr_switch.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/va_high_addr_switch.sh~selftests-mm-allocate-6-hugepages-in-va_high_addr_switchsh
+++ a/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -111,8 +111,8 @@ setup_nr_hugepages()
 
 check_test_requirements
 save_nr_hugepages
-# 4 keep_mapped pages, and one for tmp usage
-setup_nr_hugepages 5
+# The HugeTLB tests require 6 pages
+setup_nr_hugepages 6
 ./va_high_addr_switch --run-hugetlb
 retcode=$?
 restore_nr_hugepages
_

Patches currently in -mm which might be from chuhu@redhat.com are


