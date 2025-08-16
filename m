Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EC11E2614
	for <mm-commits@vger.kernel.org>; Sat, 16 Aug 2025 05:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755322016; cv=none; b=t4cALiuDckKjkXB7YQCFoxUxjpam3y3FyUwmBMoDap/CZXPcTwjxRc9wbxgEGLoZzyG+8XiQHK9xoI/yJTv4AEzZi5ONi3xpqVbjuYG6IQJFAgtQ6Ib9i2QodNrH1yfkeHZXZ7ceZPa4FL7aOrAPi4XBZJeC1ue5DSnfcMF/Dd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755322016; c=relaxed/simple;
	bh=MnvYnJ+RPsA8TpkHkGGFbjfM3KbjPfLDZa4cWsPYM2k=;
	h=Date:To:From:Subject:Message-Id; b=ihUdIpZQrxWfQhcpuTzg0m3ljDHRKzH1YSphlrY91RffyEXn5Ti3AgfJlvBQyJkhA2oAKpbk6/ttRXBe8SC2KMg6CjuoYEzzTlZLQGPAVgXeg2Eni9a9LfcFdzddXSDHnfqIn3MeV6YqCulrkO1l6k2dkViusLiZNlGAMRTNgps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuGMEldo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuGMEldo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9450FC4CEF0;
	Sat, 16 Aug 2025 05:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755322015;
	bh=MnvYnJ+RPsA8TpkHkGGFbjfM3KbjPfLDZa4cWsPYM2k=;
	h=Date:To:From:Subject:From;
	b=EuGMEldoVss2JyC+bl4C1w6G81rQOrnNfrjGFmjkMSIszgnkcJ+0v9yM2/b61l1S/
	 iyQwNtwrqX91FRqn86yDJFMWebU3ZYBXBA0OTYerCGaGSa4+YdoUQbeDSp789GVtNj
	 fAr7DD/f1sAG/ciXisKaSn1w/BteJISJrcEdTM+I=
Date: Fri, 15 Aug 2025 22:26:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shuah@kernel.org,ryan.roberts@arm.com,ritesh.list@gmail.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aboorvad@linux.ibm.com,donettom@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch added to mm-new branch
Message-Id: <20250816052655.9450FC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: add support to test 4PB VA on PPC64
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Donet Tom <donettom@linux.ibm.com>
Subject: selftests/mm: add support to test 4PB VA on PPC64
Date: Sat, 16 Aug 2025 09:31:08 +0530

PowerPC64 supports a 4PB virtual address space, but this test was
previously limited to 512TB.  This patch extends the coverage up to the
full 4PB VA range on PowerPC64.

Memory from 0 to 128TB is allocated without an address hint, while
allocations from 128TB to 4PB use a hint address.

Link: https://lkml.kernel.org/r/20250816040113.760010-3-aboorvad@linux.ibm.com
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-add-support-to-test-4pb-va-on-ppc64
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -44,12 +44,18 @@
  * On Arm64 the address space is 256TB and support for
  * high mappings up to 4PB virtual address space has
  * been added.
+ *
+ * On PowerPC64, the address space up to 128TB can be
+ * mapped without a hint. Addresses beyond 128TB, up to
+ * 4PB, can be mapped with a hint.
+ *
  */
 
 #define NR_CHUNKS_128TB   ((128 * SZ_1TB) / MAP_CHUNK_SIZE) /* Number of chunks for 128TB */
 #define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
 #define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
 #define NR_CHUNKS_3840TB  (NR_CHUNKS_128TB * 30UL)
+#define NR_CHUNKS_3968TB  (NR_CHUNKS_128TB * 31UL)
 
 #define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
 #define ADDR_MARK_256TB  (1UL << 48) /* First address beyond 256TB */
@@ -59,6 +65,11 @@
 #define HIGH_ADDR_SHIFT 49
 #define NR_CHUNKS_LOW   NR_CHUNKS_256TB
 #define NR_CHUNKS_HIGH  NR_CHUNKS_3840TB
+#elif defined(__PPC64__)
+#define HIGH_ADDR_MARK  ADDR_MARK_128TB
+#define HIGH_ADDR_SHIFT 48
+#define NR_CHUNKS_LOW   NR_CHUNKS_128TB
+#define NR_CHUNKS_HIGH  NR_CHUNKS_3968TB
 #else
 #define HIGH_ADDR_MARK  ADDR_MARK_128TB
 #define HIGH_ADDR_SHIFT 48
_

Patches currently in -mm which might be from donettom@linux.ibm.com are

mm-selftests-fix-incorrect-pointer-being-passed-to-mark_range.patch
selftests-mm-add-support-to-test-4pb-va-on-ppc64.patch
selftest-mm-fix-ksm_funtional_test-failures.patch
mm-selftests-fix-split_huge_page_test-failure-on-systems-with-64kb-page-size.patch

