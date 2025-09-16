Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3186623A9B3
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 03:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757993113; cv=none; b=q89DkGW0DiLsxEvN+jkbWL3GSnicsBgghzsT8t8nzOM9Lw45nLGNXaUbAoLjZupWVRCsUB1mtQzlXMjTVyIdkjpehNZsmwyi1KOuv8BMxCUIlpanXOAxRgd8Z7aJ8mADCKtz4rw4uTsDFwBTNW1eW3OJUEb5x87eBFZMeGVxLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757993113; c=relaxed/simple;
	bh=AhkqvIN1js+pdlrK9ozQC+2LPh9D8uX6A4zBCl2TARQ=;
	h=Date:To:From:Subject:Message-Id; b=Sghk/pKfl4U6I7JYqGlLgtKZfar/YcbAWAPK/UJNsV+dSSu8o72GbmuMSJRFR4ZbV4b9uNQFPY+L8UbUtgWnqwDexDkd9xBw/+khCEQ23fjhEkCG2kuns7c+mfsJFTHhN4tf+uUTXjPcd6o1wZmvSN+Vl27CQjU6etdmXComAU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PHBbjXyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PHBbjXyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE588C4CEEB;
	Tue, 16 Sep 2025 03:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757993112;
	bh=AhkqvIN1js+pdlrK9ozQC+2LPh9D8uX6A4zBCl2TARQ=;
	h=Date:To:From:Subject:From;
	b=PHBbjXyUahG3SsvMuyDIAnD5/iLc6Ck29Gr2lk3PHwcS4G5wGlui8SmQv76WDjFJo
	 OP+vEDze3qie7nXSatvALpE75Msdymuw8Gypr4cdlxMgQPQGl67tMx+0b8w8wuaU7d
	 o7RsvD3WsBptqpsT9WnYrwJICahsuId5JQSUwAf4=
Date: Mon, 15 Sep 2025 20:25:12 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,tony.luck@intel.com,surenb@google.com,shuah@kernel.org,shawn.fan@intel.com,russ.anderson@hpe.com,rppt@kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,mhocko@suse.com,mclapinski@google.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,laoar.shao@gmail.com,joel.granados@kernel.org,jiaqiyan@google.com,jane.chu@oracle.com,jack@suse.cz,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,bp@alien8.de,kyle.meyer@hpe.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages.patch added to mm-new branch
Message-Id: <20250916032512.AE588C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: support disabling soft offline for HugeTLB pages
has been added to the -mm mm-new branch.  Its filename is
     mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages.patch

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
From: Kyle Meyer <kyle.meyer@hpe.com>
Subject: mm/memory-failure: support disabling soft offline for HugeTLB pages
Date: Mon, 15 Sep 2025 19:27:41 -0500

Soft offlining a HugeTLB page reduces the HugeTLB page pool.

Commit 56374430c5dfc ("mm/memory-failure: userspace controls
soft-offlining pages") introduced the following sysctl interface to
control soft offline:

/proc/sys/vm/enable_soft_offline

The interface does not distinguish between page types:

    0 - Soft offline is disabled
    1 - Soft offline is enabled

Convert enable_soft_offline to a bitmask and support disabling soft
offline for HugeTLB pages:

Bits:

    0 - Enable soft offline
    1 - Disable soft offline for HugeTLB pages

Supported values:

    0 - Soft offline is disabled
    1 - Soft offline is enabled
    3 - Soft offline is enabled (disabled for HugeTLB pages)

Existing behavior is preserved.

Update documentation and HugeTLB soft offline self tests.

Link: https://lkml.kernel.org/r/aMiu_Uku6Y5ZbuhM@hpe.com
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Reported-by: Shawn Fan <shawn.fan@intel.com>
Suggested-by: Tony Luck <tony.luck@intel.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Clapinski <mclapinski@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Russ Anderson <russ.anderson@hpe.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yafang <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-memory-page-offline |    3 +
 Documentation/admin-guide/sysctl/vm.rst             |   28 ++++++++--
 mm/memory-failure.c                                 |   17 +++++-
 tools/testing/selftests/mm/hugetlb-soft-offline.c   |   19 +++++-
 4 files changed, 56 insertions(+), 11 deletions(-)

--- a/Documentation/ABI/testing/sysfs-memory-page-offline~mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages
+++ a/Documentation/ABI/testing/sysfs-memory-page-offline
@@ -20,6 +20,9 @@ Description:
 		number, or a error when the offlining failed.  Reading
 		the file is not allowed.
 
+		Soft-offline can be controlled via sysctl, see:
+		Documentation/admin-guide/sysctl/vm.rst
+
 What:		/sys/devices/system/memory/hard_offline_page
 Date:		Sep 2009
 KernelVersion:	2.6.33
--- a/Documentation/admin-guide/sysctl/vm.rst~mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages
+++ a/Documentation/admin-guide/sysctl/vm.rst
@@ -309,19 +309,39 @@ physical memory) vs performance / capaci
 HugeTLB cases.
 
 For all architectures, enable_soft_offline controls whether to soft offline
-memory pages.  When set to 1, kernel attempts to soft offline the pages
-whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
-the request to soft offline the pages.  Its default value is 1.
+memory pages.
+
+enable_soft_offline is a bitmask:
+
+Bits::
+
+	0 - Enable soft offline
+	1 - Disable soft offline for HugeTLB pages
+
+Supported values::
+
+	0 - Soft offline is disabled
+	1 - Soft offline is enabled
+	3 - Soft offline is enabled (disabled for HugeTLB pages)
+
+The default value is 1.
+
+If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
 
 It is worth mentioning that after setting enable_soft_offline to 0, the
 following requests to soft offline pages will not be performed:
 
+- Request to soft offline from sysfs (soft_offline_page).
+
 - Request to soft offline pages from RAS Correctable Errors Collector.
 
-- On ARM, the request to soft offline pages from GHES driver.
+- On ARM and X86, the request to soft offline pages from GHES driver.
 
 - On PARISC, the request to soft offline pages from Page Deallocation Table.
 
+Note:
+	Soft offlining a HugeTLB page reduces the HugeTLB page pool.
+
 extfrag_threshold
 =================
 
--- a/mm/memory-failure.c~mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages
+++ a/mm/memory-failure.c
@@ -64,11 +64,14 @@
 #include "internal.h"
 #include "ras/ras_event.h"
 
+#define SOFT_OFFLINE_ENABLED		BIT(0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
+
 static int sysctl_memory_failure_early_kill __read_mostly;
 
 static int sysctl_memory_failure_recovery __read_mostly = 1;
 
-static int sysctl_enable_soft_offline __read_mostly = 1;
+static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_ENABLED;
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
@@ -150,7 +153,7 @@ static const struct ctl_table memory_fai
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= SYSCTL_THREE,
 	}
 };
 
@@ -2725,12 +2728,20 @@ int soft_offline_page(unsigned long pfn,
 		return -EIO;
 	}
 
-	if (!sysctl_enable_soft_offline) {
+	if (!(sysctl_enable_soft_offline & SOFT_OFFLINE_ENABLED)) {
 		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
 		put_ref_page(pfn, flags);
 		return -EOPNOTSUPP;
 	}
 
+	if (sysctl_enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB) {
+		if (folio_test_hugetlb(pfn_folio(pfn))) {
+			pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
+			put_ref_page(pfn, flags);
+			return -EOPNOTSUPP;
+		}
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (PageHWPoison(page)) {
--- a/tools/testing/selftests/mm/hugetlb-soft-offline.c~mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages
+++ a/tools/testing/selftests/mm/hugetlb-soft-offline.c
@@ -5,6 +5,8 @@
  *   offlining failed with EOPNOTSUPP.
  * - if enable_soft_offline = 1, a hugepage should be dissolved and
  *   nr_hugepages/free_hugepages should be reduced by 1.
+ * - if enable_soft_offline = 3, hugepages should stay intact and soft
+ *   offlining failed with EOPNOTSUPP.
  *
  * Before running, make sure more than 2 hugepages of default_hugepagesz
  * are allocated. For example, if /proc/meminfo/Hugepagesize is 2048kB:
@@ -32,6 +34,9 @@
 
 #define EPREFIX " !!! "
 
+#define SOFT_OFFLINE_ENABLED		(1 << 0)
+#define SOFT_OFFLINE_SKIP_HUGETLB	(1 << 1)
+
 static int do_soft_offline(int fd, size_t len, int expect_errno)
 {
 	char *filemap = NULL;
@@ -56,6 +61,7 @@ static int do_soft_offline(int fd, size_
 	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
 
 	hwp_addr = filemap + len / 2;
+	errno = 0;
 	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
 	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
 		       hwp_addr, ret, errno);
@@ -83,7 +89,7 @@ static int set_enable_soft_offline(int v
 	char cmd[256] = {0};
 	FILE *cmdfile = NULL;
 
-	if (value != 0 && value != 1)
+	if (value < 0 || value > 3)
 		return -EINVAL;
 
 	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
@@ -155,13 +161,17 @@ close:
 static void test_soft_offline_common(int enable_soft_offline)
 {
 	int fd;
-	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
+	int expect_errno = 0;
 	struct statfs file_stat;
 	unsigned long hugepagesize_kb = 0;
 	unsigned long nr_hugepages_before = 0;
 	unsigned long nr_hugepages_after = 0;
 	int ret;
 
+	if (!(enable_soft_offline & SOFT_OFFLINE_ENABLED) ||
+	     (enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB))
+		expect_errno = EOPNOTSUPP;
+
 	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
 		       enable_soft_offline);
 
@@ -198,7 +208,7 @@ static void test_soft_offline_common(int
 	// No need for the hugetlbfs file from now on.
 	close(fd);
 
-	if (enable_soft_offline) {
+	if (expect_errno == 0) {
 		if (nr_hugepages_before != nr_hugepages_after + 1) {
 			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
 			return;
@@ -219,8 +229,9 @@ static void test_soft_offline_common(int
 int main(int argc, char **argv)
 {
 	ksft_print_header();
-	ksft_set_plan(2);
+	ksft_set_plan(3);
 
+	test_soft_offline_common(3);
 	test_soft_offline_common(1);
 	test_soft_offline_common(0);
 
_

Patches currently in -mm which might be from kyle.meyer@hpe.com are

mm-memory-failure-support-disabling-soft-offline-for-hugetlb-pages.patch

