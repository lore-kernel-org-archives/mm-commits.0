From: akpm@linux-foundation.org
Subject: + hugetlbfs-clean-up-command-line-processing.patch added
 to -mm tree
Date: Fri, 17 Apr 2020 12:17:30 -0700
Message-ID: <20200417191730.mEVOxyyYR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728260AbgDQTRd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 17 Apr 2020 15:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, aou@eecs.berkeley.edu, benh@kernel.crashing.org, borntraeger@de.ibm.com, catalin.marinas@arm.com, christophe.leroy@c-s.fr, corbet@lwn.net, dave.hansen@linux.intel.com, davem@davemloft.net, gor@linux.ibm.com, heiko.carstens@de.ibm.com, longpeng2@huawei.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, nitesh@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, paulus@samba.org, peterx@redhat.com, rdunlap@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: hugetlbfs: clean up command line processing
has been added to the -mm tree.  Its filename is
     hugetlbfs-clean-up-command-line-processing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlbfs-clean-up-command-line-processing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlbfs-clean-up-command-line-processing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: clean up command line processing

With all hugetlb page processing done in a single file clean up code.
- Make code match desired semantics
  - Update documentation with semantics
- Make all warnings and errors messages start with 'HugeTLB:'.
- Consistently name command line parsing routines.
- Check for hugepages_supported() before processing parameters.
- Add comments to code
  - Describe some of the subtle interactions
  - Describe semantics of command line arguments

This patch also fixes issues with implicitly setting the number of
gigantic huge pages to preallocate.  Previously on X86 command line,
        hugepages=2 default_hugepagesz=1G
would result in zero 1G pages being preallocated and,
        # grep HugePages_Total /proc/meminfo
        HugePages_Total:       0
        # sysctl -a | grep nr_hugepages
        vm.nr_hugepages = 2
        vm.nr_hugepages_mempolicy = 2
        # cat /proc/sys/vm/nr_hugepages
        2
After this patch 2 gigantic pages will be preallocated and all the
proc, sysfs, sysctl and meminfo files will accurately reflect this.

To address the issue with gigantic pages, a small change in behavior
was made to command line processing.  Previously the command line,
        hugepages=128 default_hugepagesz=2M hugepagesz=2M hugepages=256
would result in the allocation of 256 2M huge pages.  The value 128
would be ignored without any warning.  After this patch, 128 2M pages
will be allocated and a warning message will be displayed indicating
the value of 256 is ignored.  This change in behavior is required
because allocation of implicitly specified gigantic pages must be done
when the default_hugepagesz= is encountered for gigantic pages.
Previously the code waited until later in the boot process (hugetlb_init),
to allocate pages of default size.  However the bootmem allocator required
for gigantic allocations is not available at this time.

Link: http://lkml.kernel.org/r/20200417185049.275845-5-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Longpeng <longpeng2@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nitesh Narayan Lal <nitesh@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   40 ++-
 Documentation/admin-guide/mm/hugetlbpage.rst    |   35 +++
 mm/hugetlb.c                                    |  159 +++++++++++---
 3 files changed, 190 insertions(+), 44 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~hugetlbfs-clean-up-command-line-processing
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -834,12 +834,15 @@
 			See also Documentation/networking/decnet.txt.
 
 	default_hugepagesz=
-			[same as hugepagesz=] The size of the default
-			HugeTLB page size. This is the size represented by
-			the legacy /proc/ hugepages APIs, used for SHM, and
-			default size when mounting hugetlbfs filesystems.
-			Defaults to the default architecture's huge page size
-			if not specified.
+			[HW] The size of the default HugeTLB page. This is
+			the size represented by the legacy /proc/ hugepages
+			APIs.  In addition, this is the default hugetlb size
+			used for shmget(), mmap() and mounting hugetlbfs
+			filesystems.  If not specified, defaults to the
+			architecture's default huge page size.  Huge page
+			sizes are architecture dependent.  See also
+			Documentation/admin-guide/mm/hugetlbpage.rst.
+			Format: size[KMG]
 
 	deferred_probe_timeout=
 			[KNL] Debugging option to set a timeout in seconds for
@@ -1479,13 +1482,24 @@
 			hugepages using the cma allocator. If enabled, the
 			boot-time allocation of gigantic hugepages is skipped.
 
-	hugepages=	[HW,X86-32,IA-64] HugeTLB pages to allocate at boot.
-	hugepagesz=	[HW,IA-64,PPC,X86-64] The size of the HugeTLB pages.
-			On x86-64 and powerpc, this option can be specified
-			multiple times interleaved with hugepages= to reserve
-			huge pages of different sizes. Valid pages sizes on
-			x86-64 are 2M (when the CPU supports "pse") and 1G
-			(when the CPU supports the "pdpe1gb" cpuinfo flag).
+	hugepages=	[HW] Number of HugeTLB pages to allocate at boot.
+			If this follows hugepagesz (below), it specifies
+			the number of pages of hugepagesz to be allocated.
+			If this is the first HugeTLB parameter on the command
+			line, it specifies the number of pages to allocate for
+			the default huge page size.  See also
+			Documentation/admin-guide/mm/hugetlbpage.rst.
+			Format: <integer>
+
+	hugepagesz=
+			[HW] The size of the HugeTLB pages.  This is used in
+			conjunction with hugepages (above) to allocate huge
+			pages of a specific size at boot.  The pair
+			hugepagesz=X hugepages=Y can be specified once for
+			each supported huge page size. Huge page sizes are
+			architecture dependent.  See also
+			Documentation/admin-guide/mm/hugetlbpage.rst.
+			Format: size[KMG]
 
 	hung_task_panic=
 			[KNL] Should the hung task detector generate panics.
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~hugetlbfs-clean-up-command-line-processing
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -100,6 +100,41 @@ with a huge page size selection paramete
 be specified in bytes with optional scale suffix [kKmMgG].  The default huge
 page size may be selected with the "default_hugepagesz=<size>" boot parameter.
 
+Hugetlb boot command line parameter semantics
+hugepagesz - Specify a huge page size.  Used in conjunction with hugepages
+	parameter to preallocate a number of huge pages of the specified
+	size.  Hence, hugepagesz and hugepages are typically specified in
+	pairs such as:
+		hugepagesz=2M hugepages=512
+	hugepagesz can only be specified once on the command line for a
+	specific huge page size.  Valid huge page sizes are architecture
+	dependent.
+hugepages - Specify the number of huge pages to preallocate.  This typically
+	follows a valid hugepagesz or default_hugepagesz parameter.  However,
+	if hugepages is the first or only hugetlb command line parameter it
+	implicitly specifies the number of huge pages of default size to
+	allocate.  If the number of huge pages of default size is implicitly
+	specified, it can not be overwritten by a hugepagesz,hugepages
+	parameter pair for the default size.
+	For example, on an architecture with 2M default huge page size:
+		hugepages=256 hugepagesz=2M hugepages=512
+	will result in 256 2M huge pages being allocated and a warning message
+	indicating that the hugepages=512 parameter is ignored.  If a hugepages
+	parameter is preceded by an invalid hugepagesz parameter, it will
+	be ignored.
+default_hugepagesz - Specify the default huge page size.  This parameter can
+	only be specified once on the command line.  default_hugepagesz can
+	optionally be followed by the hugepages parameter to preallocate a
+	specific number of huge pages of default size.  The number of default
+	sized huge pages to preallocate can also be implicitly specified as
+	mentioned in the hugepages section above.  Therefore, on an
+	architecture with 2M default huge page size:
+		hugepages=256
+		default_hugepagesz=2M hugepages=256
+		hugepages=256 default_hugepagesz=2M
+	will all result in 256 2M huge pages being allocated.  Valid default
+	huge page size is architecture dependent.
+
 When multiple huge page sizes are supported, ``/proc/sys/vm/nr_hugepages``
 indicates the current number of pre-allocated huge pages of the default size.
 Thus, one can use the following command to dynamically allocate/deallocate
--- a/mm/hugetlb.c~hugetlbfs-clean-up-command-line-processing
+++ a/mm/hugetlb.c
@@ -59,8 +59,8 @@ __initdata LIST_HEAD(huge_boot_pages);
 /* for command line parsing */
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
-static unsigned long __initdata default_hstate_size;
 static bool __initdata parsed_valid_hugepagesz = true;
+static bool __initdata parsed_default_hugepagesz;
 
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
@@ -3060,7 +3060,7 @@ static void __init hugetlb_sysfs_init(vo
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
 					 hstate_kobjs, &hstate_attr_group);
 		if (err)
-			pr_err("Hugetlb: Unable to add hstate %s", h->name);
+			pr_err("HugeTLB: Unable to add hstate %s", h->name);
 	}
 }
 
@@ -3164,7 +3164,7 @@ static void hugetlb_register_node(struct
 						nhs->hstate_kobjs,
 						&per_node_hstate_attr_group);
 		if (err) {
-			pr_err("Hugetlb: Unable to add hstate %s for node %d\n",
+			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
 				h->name, node->dev.id);
 			hugetlb_unregister_node(node);
 			break;
@@ -3215,19 +3215,35 @@ static int __init hugetlb_init(void)
 	if (!hugepages_supported())
 		return 0;
 
-	if (!size_to_hstate(default_hstate_size)) {
-		if (default_hstate_size != 0) {
-			pr_err("HugeTLB: unsupported default_hugepagesz %lu. Reverting to %lu\n",
-			       default_hstate_size, HPAGE_SIZE);
+	/*
+	 * Make sure HPAGE_SIZE (HUGETLB_PAGE_ORDER) hstate exists.  Some
+	 * architectures depend on setup being done here.
+	 */
+	hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
+	if (!parsed_default_hugepagesz) {
+		/*
+		 * If we did not parse a default huge page size, set
+		 * default_hstate_idx to HPAGE_SIZE hstate. And, if the
+		 * number of huge pages for this default size was implicitly
+		 * specified, set that here as well.
+		 * Note that the implicit setting will overwrite an explicit
+		 * setting.  A warning will be printed in this case.
+		 */
+		default_hstate_idx = hstate_index(size_to_hstate(HPAGE_SIZE));
+		if (default_hstate_max_huge_pages) {
+			if (default_hstate.max_huge_pages) {
+				char buf[32];
+
+				string_get_size(huge_page_size(&default_hstate),
+					1, STRING_UNITS_2, buf, 32);
+				pr_warn("HugeTLB: Ignoring hugepages=%lu associated with %s page size\n",
+					default_hstate.max_huge_pages, buf);
+				pr_warn("HugeTLB: Using hugepages=%lu for number of default huge pages\n",
+					default_hstate_max_huge_pages);
+			}
+			default_hstate.max_huge_pages =
+				default_hstate_max_huge_pages;
 		}
-
-		default_hstate_size = HPAGE_SIZE;
-		hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
-	}
-	default_hstate_idx = hstate_index(size_to_hstate(default_hstate_size));
-	if (default_hstate_max_huge_pages) {
-		if (!default_hstate.max_huge_pages)
-			default_hstate.max_huge_pages = default_hstate_max_huge_pages;
 	}
 
 	hugetlb_cma_check();
@@ -3287,20 +3303,34 @@ void __init hugetlb_add_hstate(unsigned
 	parsed_hstate = h;
 }
 
-static int __init hugetlb_nrpages_setup(char *s)
+/*
+ * hugepages command line processing
+ * hugepages normally follows a valid hugepagsz or default_hugepagsz
+ * specification.  If not, ignore the hugepages value.  hugepages can also
+ * be the first huge page command line  option in which case it implicitly
+ * specifies the number of huge pages for the default size.
+ */
+static int __init hugepages_setup(char *s)
 {
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
 
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: huge pages not supported, ignoring hugepages = %s\n", s);
+		return 0;
+	}
+
 	if (!parsed_valid_hugepagesz) {
-		pr_warn("hugepages = %s preceded by "
-			"an unsupported hugepagesz, ignoring\n", s);
+		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
-		return 1;
+		return 0;
 	}
+
 	/*
-	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
-	 * so this hugepages= parameter goes to the "default hstate".
+	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter
+	 * yet, so this hugepages= parameter goes to the "default hstate".
+	 * Otherwise, it goes with the previously parsed hugepagesz or
+	 * default_hugepagesz.
 	 */
 	else if (!hugetlb_max_hstate)
 		mhp = &default_hstate_max_huge_pages;
@@ -3308,8 +3338,8 @@ static int __init hugetlb_nrpages_setup(
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		pr_warn("hugepages= specified twice without interleaving hugepagesz=, ignoring\n");
-		return 1;
+		pr_warn("HugeTLB: hugepages= specified twice without interleaving hugepagesz=, ignoring hugepages=%s\n", s);
+		return 0;
 	}
 
 	if (sscanf(s, "%lu", mhp) <= 0)
@@ -3327,42 +3357,109 @@ static int __init hugetlb_nrpages_setup(
 
 	return 1;
 }
-__setup("hugepages=", hugetlb_nrpages_setup);
+__setup("hugepages=", hugepages_setup);
 
+/*
+ * hugepagesz command line processing
+ * A specific huge page size can only be specified once with hugepagesz.
+ * hugepagesz is followed by hugepages on the command line.  The global
+ * variable 'parsed_valid_hugepagesz' is used to determine if prior
+ * hugepagesz argument was valid.
+ */
 static int __init hugepagesz_setup(char *s)
 {
 	unsigned long size;
+	struct hstate *h;
+
+	parsed_valid_hugepagesz = false;
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: huge pages not supported, ignoring hugepagesz = %s\n", s);
+		return 0;
+	}
 
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		parsed_valid_hugepagesz = false;
-		pr_err("HugeTLB: unsupported hugepagesz %s\n", s);
+		pr_err("HugeTLB: unsupported hugepagesz=%s\n", s);
 		return 0;
 	}
 
-	if (size_to_hstate(size)) {
-		pr_warn("HugeTLB: hugepagesz %s specified twice, ignoring\n", s);
-		return 0;
+	h = size_to_hstate(size);
+	if (h) {
+		/*
+		 * hstate for this size already exists.  This is normally
+		 * an error, but is allowed if the existing hstate is the
+		 * default hstate.  More specifically, it is only allowed if
+		 * the number of huge pages for the default hstate was not
+		 * previously specified.
+		 */
+		if (!parsed_default_hugepagesz ||  h != &default_hstate ||
+		    default_hstate.max_huge_pages) {
+			pr_warn("HugeTLB: hugepagesz=%s specified twice, ignoring\n", s);
+			return 0;
+		}
+
+		/*
+		 * No need to call hugetlb_add_hstate() as hstate already
+		 * exists.  But, do set parsed_hstate so that a following
+		 * hugepages= parameter will be applied to this hstate.
+		 */
+		parsed_hstate = h;
+		parsed_valid_hugepagesz = true;
+		return 1;
 	}
 
 	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
+	parsed_valid_hugepagesz = true;
 	return 1;
 }
 __setup("hugepagesz=", hugepagesz_setup);
 
+/*
+ * default_hugepagesz command line input
+ * Only one instance of default_hugepagesz allowed on command line.
+ */
 static int __init default_hugepagesz_setup(char *s)
 {
 	unsigned long size;
 
+	parsed_valid_hugepagesz = false;
+	if (!hugepages_supported()) {
+		pr_warn("HugeTLB: huge pages not supported, ignoring default_hugepagesz = %s\n", s);
+		return 0;
+	}
+
+	if (parsed_default_hugepagesz) {
+		pr_err("HugeTLB: default_hugepagesz previously specified, ignoring %s\n", s);
+		return 0;
+	}
+
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
-		pr_err("HugeTLB: unsupported default_hugepagesz %s\n", s);
+		pr_err("HugeTLB: unsupported default_hugepagesz=%s\n", s);
 		return 0;
 	}
 
-	default_hstate_size = size;
+	hugetlb_add_hstate(ilog2(size) - PAGE_SHIFT);
+	parsed_valid_hugepagesz = true;
+	parsed_default_hugepagesz = true;
+	default_hstate_idx = hstate_index(size_to_hstate(size));
+
+	/*
+	 * The number of default huge pages (for this size) could have been
+	 * specified as the first hugetlb parameter: hugepages=X.  If so,
+	 * then default_hstate_max_huge_pages is set.  If the default huge
+	 * page size is gigantic (>= MAX_ORDER), then the pages must be
+	 * allocated here from bootmem allocator.
+	 */
+	if (default_hstate_max_huge_pages) {
+		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
+		if (hstate_is_gigantic(&default_hstate))
+			hugetlb_hstate_alloc_pages(&default_hstate);
+		default_hstate_max_huge_pages = 0;
+	}
+
 	return 1;
 }
 __setup("default_hugepagesz=", default_hugepagesz_setup);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlbfs-add-arch_hugetlb_valid_size.patch
hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code.patch
hugetlbfs-remove-hugetlb_add_hstate-warning-for-existing-hstate.patch
hugetlbfs-clean-up-command-line-processing.patch
