Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8529370ACD
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067203; cv=none; b=JY2fenLq5jCIjxe91LKMFbcaB1R2vzCcvj62h6IB2HnvhS8YHZlRTm7lLR3NowJvAhTDLKktCQX6qtA7WEVVreGObj4qft9H/4nkzagvgV50cLhb1jtfJRDRSYU0yDeIp/Ui5sns6kwke9pG5AHpzkNd7QUGGLahYc7VWiEODjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067203; c=relaxed/simple;
	bh=TAArlaUbooGAdy+tfa40LHYqPs5VH/B5yzrtLbo7W/I=;
	h=Date:To:From:Subject:Message-Id; b=okMysu/lSCwFWhEPXJ4wL3ZSzdaV7CtkqqPa+mEgugu4Ft0zPerf85QqszVLgmLbM6PkSGjmKcVKIvfQUbYKKFoniChXOnVDdWJSjPm/rZzYpFjcYEAWezEnns2w+d43tbR8+Z/+QEyu/eFjpFVpkGeeeIP1siCZoEYSP94hlAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sN5OHZo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sN5OHZo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6C11F00A3A;
	Sun, 21 Jun 2026 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067202;
	bh=P4DBapeIo7cl7U3G9GSL72PGtkYS1Ax8p4w3/iXtQB4=;
	h=Date:To:From:Subject;
	b=sN5OHZo8LI3IammEoBtkQ2qGgFem5nFxANRx5+DtkBzaWxzTiS3huYUfHIfQ2hasX
	 qFJ44aHaAE/wJyvwVJC9H1VReaOnysJ4m84XcnDpUajSC3i0dDrOmjZfBuVfAdorUC
	 EOCBuzmhrgDr6RKDmBUx8Set2HjHSxJHu1WDCTJE=
Date: Sun, 21 Jun 2026 11:40:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch removed from -mm tree
Message-Id: <20260621184002.8D6C11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap
has been removed from the -mm tree.  Its filename was
     selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftest/mm: register existing mapping with userfaultfd in hugetlb-mremap
Date: Thu, 21 May 2026 12:17:48 +0530

Previously, register_region_with_uffd() created a new anonymous mapping
and overwrote the address supplied by the caller before registering the
range with userfaultfd.

As a result, userfaultfd was applied to an unrelated anonymous mapping
instead of the hugetlb region used by the test.

Remove the extra mmap() and register the caller-provided address range
directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are generated
for the hugetlb mapping used by the test.

This ensures userfaultfd operates on the actual hugetlb test region and
validates the expected fault handling.

Before patch:
 running ./hugetlb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Address returned by mmap() = 0x7fff9d000000
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

After patch:
 running ./hugetb-mremap
 -------------------------
 TAP version 13
 1..1
  Map haddr: Returned address is 0x7eaa40000000
  Map daddr: Returned address is 0x7daa40000000
  Map vaddr: Returned address is 0x7faa40000000
  Registered memory at address 0x7eaa40000000 with userfaultfd
  Mremap: Returned address is 0x7faa40000000
  First hex is 0
  First hex is 3020100
 ok 1 Read same data
 Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
 [PASS]
 ok 1 hugetlb-mremap

Link: https://lore.kernel.org/13845da872ed174316173e8996dbb5f181994017.1779296493.git.sayalip@linux.ibm.com
Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/hugetlb-mremap.c |   21 ++++--------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/mm/hugetlb-mremap.c~selftest-mm-register-existing-mapping-with-userfaultfd-in-hugetlb-mremap
+++ a/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -86,25 +86,14 @@ static void register_region_with_uffd(ch
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
 		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
 
-	/* Create a private anonymous mapping. The memory will be
-	 * demand-zero paged--that is, not yet allocated. When we
-	 * actually touch the memory, it will be allocated via
-	 * the userfaultfd.
-	 */
-
-	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (addr == MAP_FAILED)
-		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
-
-	ksft_print_msg("Address returned by mmap() = %p\n", addr);
-
-	/* Register the memory range of the mapping we just created for
-	 * handling by the userfaultfd object. In mode, we request to track
-	 * missing pages (i.e., pages that have not yet been faulted in).
+	/* Register the passed memory range for handling by the userfaultfd object.
+	 * In mode, we request to track missing pages
+	 * (i.e., pages that have not yet been faulted in).
 	 */
 	if (uffd_register(uffd, addr, len, true, false, false))
 		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
+
+	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
 }
 
 int main(int argc, char *argv[])
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


