From: akpm@linux-foundation.org
Subject: [merged]
 selftests-vm-pkeys-use-the-correct-huge-page-size.patch removed from -mm
 tree
Date: Fri, 05 Jun 2020 13:20:33 -0700
Message-ID: <20200605202033.Nt3N6vVV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbgFEUUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:20:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, bauerman@linux.ibm.com, dave.hansen@intel.com, desnesn@linux.vnet.ibm.com, fweimer@redhat.com, linuxram@us.ibm.com, mhocko@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msuchanek@suse.de, sandipan@linux.ibm.com, shuah@kernel.org


The patch titled
     Subject: selftests: vm: pkeys: use the correct huge page size
has been removed from the -mm tree.  Its filename was
     selftests-vm-pkeys-use-the-correct-huge-page-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sandipan Das <sandipan@linux.ibm.com>
Subject: selftests: vm: pkeys: use the correct huge page size

The huge page size can vary across architectures.  This will ensure that
the correct huge page size is used when accessing the hugetlb controls
under sysfs.  Instead of using a hardcoded page size (i.e.  2MB), this now
uses the HPAGE_SIZE macro which is arch-specific.

Link: http://lkml.kernel.org/r/66882a5d6e45c73c3a52bc4aef9754e48afa4f88.1585646528.git.sandipan@linux.ibm.com
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: "Desnes A. Nunes do Rosario" <desnesn@linux.vnet.ibm.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Suchanek <msuchanek@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/protection_keys.c |   23 +++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/vm/protection_keys.c~selftests-vm-pkeys-use-the-correct-huge-page-size
+++ a/tools/testing/selftests/vm/protection_keys.c
@@ -739,12 +739,15 @@ void *malloc_pkey_anon_huge(long size, i
 }
 
 int hugetlb_setup_ok;
+#define SYSFS_FMT_NR_HUGE_PAGES "/sys/kernel/mm/hugepages/hugepages-%ldkB/nr_hugepages"
 #define GET_NR_HUGE_PAGES 10
 void setup_hugetlbfs(void)
 {
 	int err;
 	int fd;
-	char buf[] = "123";
+	char buf[256];
+	long hpagesz_kb;
+	long hpagesz_mb;
 
 	if (geteuid() != 0) {
 		fprintf(stderr, "WARNING: not run as root, can not do hugetlb test\n");
@@ -755,11 +758,16 @@ void setup_hugetlbfs(void)
 
 	/*
 	 * Now go make sure that we got the pages and that they
-	 * are 2M pages.  Someone might have made 1G the default.
+	 * are PMD-level pages. Someone might have made PUD-level
+	 * pages the default.
 	 */
-	fd = open("/sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages", O_RDONLY);
+	hpagesz_kb = HPAGE_SIZE / 1024;
+	hpagesz_mb = hpagesz_kb / 1024;
+	sprintf(buf, SYSFS_FMT_NR_HUGE_PAGES, hpagesz_kb);
+	fd = open(buf, O_RDONLY);
 	if (fd < 0) {
-		perror("opening sysfs 2M hugetlb config");
+		fprintf(stderr, "opening sysfs %ldM hugetlb config: %s\n",
+			hpagesz_mb, strerror(errno));
 		return;
 	}
 
@@ -767,13 +775,14 @@ void setup_hugetlbfs(void)
 	err = read(fd, buf, sizeof(buf)-1);
 	close(fd);
 	if (err <= 0) {
-		perror("reading sysfs 2M hugetlb config");
+		fprintf(stderr, "reading sysfs %ldM hugetlb config: %s\n",
+			hpagesz_mb, strerror(errno));
 		return;
 	}
 
 	if (atoi(buf) != GET_NR_HUGE_PAGES) {
-		fprintf(stderr, "could not confirm 2M pages, got: '%s' expected %d\n",
-			buf, GET_NR_HUGE_PAGES);
+		fprintf(stderr, "could not confirm %ldM pages, got: '%s' expected %d\n",
+			hpagesz_mb, buf, GET_NR_HUGE_PAGES);
 		return;
 	}
 
_

Patches currently in -mm which might be from sandipan@linux.ibm.com are
