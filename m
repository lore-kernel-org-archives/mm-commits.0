Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B87B273FE
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741063937; cv=none; b=tkM85R/z0c/jOnNY1vZ8wojymCI6ZQ2AJDCc17Dpo2IuMxnvcKdnL9NWbMot+3jTwsjoORMI837E5UfqizUeb5DQ9Mtcj1r3Jqv2vwfAmbQ4+nzYmKkgisS+KQ2QVZYWpYS2c7crVD+SLiyL11N2VLJm7HbATlhQJwNWo7oBvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741063937; c=relaxed/simple;
	bh=Il87NyyPPhQoJH2ca3hIeI+mVkFSaU6myahFZOw5qPY=;
	h=Date:To:From:Subject:Message-Id; b=HQ6//vuWHkpyy/sTPfjIW9dW6G+ZSK8LMY942IPvoVUq6S/gDp297QFRB3Wmk4OUYRQH7lnqeOgNR+5QaY59/VGcrPEfdlGwrPaaG1DBn9/oCsNzcpXM5el6J9eLY4GOQRQz9deDCjhbIp5++5KAF4gLVrRxfSzeKZhE1sztW4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1lPR5m/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1lPR5m/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3AFC4CEE5;
	Tue,  4 Mar 2025 04:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741063937;
	bh=Il87NyyPPhQoJH2ca3hIeI+mVkFSaU6myahFZOw5qPY=;
	h=Date:To:From:Subject:From;
	b=1lPR5m/uXYx1J4a35ca0Ig0JIpI5zYLdrmfqiyxXE1XGWVsQqyrrcbDyTynlCEdkh
	 FB2m5jsV2IITIIzeofXq20pTWMEjjGcTln3AgArTlCyARKxyIHD14u7fl9fzOKKxQ5
	 f/i+1ArM+hNVmEBRYAcxEjG584OSWPZo+y3VOPrg=
Date: Mon, 03 Mar 2025 20:52:16 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch added to mm-unstable branch
Message-Id: <20250304045216.EE3AFC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: hugetlb: add hugetlb_alloc_threads cmdline option
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch

This patch will later appear in the mm-unstable branch at
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
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Subject: mm: hugetlb: add hugetlb_alloc_threads cmdline option
Date: Thu, 27 Feb 2025 23:45:06 +0100

Add a command line option that enables control of how many threads should
be used to allocate huge pages.

Link: https://lkml.kernel.org/r/20250227-hugepage-parameter-v2-2-7db8c6dc0453@cyberus-technology.de
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    9 ++++
 Documentation/admin-guide/mm/hugetlbpage.rst    |   10 ++++
 mm/hugetlb.c                                    |   31 ++++++++++++--
 3 files changed, 46 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1882,6 +1882,15 @@
 			Documentation/admin-guide/mm/hugetlbpage.rst.
 			Format: size[KMG]
 
+	hugepage_alloc_threads=
+			[HW] The number of threads that should be used to
+			allocate hugepages during boot. This option can be
+			used to improve system bootup time when allocating
+			a large amount of huge pages.
+			The default value is 25% of the available hardware threads.
+
+			Note that this parameter only applies to non-gigantic huge pages.
+
 	hugetlb_cma=	[HW,CMA,EARLY] The size of a CMA area used for allocation
 			of gigantic hugepages. Or using node format, the size
 			of a CMA area per node can be specified.
--- a/Documentation/admin-guide/mm/hugetlbpage.rst~mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option
+++ a/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -145,7 +145,17 @@ hugepages
 
 	It will allocate 1 2M hugepage on node0 and 2 2M hugepages on node1.
 	If the node number is invalid,  the parameter will be ignored.
+hugepage_alloc_threads
+	Specify the number of threads that should be used to allocate hugepages
+	during boot. This parameter can be used to improve system bootup time
+	when allocating a large amount of huge pages.
 
+	The default value is 25% of the available hardware threads.
+	Example to use 8 allocation threads::
+
+		hugepage_alloc_threads=8
+
+	Note that this parameter only applies to non-gigantic huge pages.
 default_hugepagesz
 	Specify the default huge page size.  This parameter can
 	only be specified once on the command line.  default_hugepagesz can
--- a/mm/hugetlb.c~mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option
+++ a/mm/hugetlb.c
@@ -85,6 +85,7 @@ static unsigned long __initdata default_
 static bool __initdata parsed_valid_hugepagesz = true;
 static bool __initdata parsed_default_hugepagesz;
 static unsigned int default_hugepages_in_node[MAX_NUMNODES] __initdata;
+static unsigned long hugepage_allocation_threads __initdata;
 
 static char hstate_cmdline_buf[COMMAND_LINE_SIZE] __initdata;
 static int hstate_cmdline_index __initdata;
@@ -3602,8 +3603,6 @@ static unsigned long __init hugetlb_page
 		.numa_aware	= true
 	};
 
-	unsigned int num_allocation_threads = max(num_online_cpus() / 4, 1);
-
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
 	job.size	= h->max_huge_pages;
@@ -3624,9 +3623,13 @@ static unsigned long __init hugetlb_page
 	 * | cascade lake 192 cpus |   39s |   20s |   11s |   10s |    9s |
 	 * +-----------------------+-------+-------+-------+-------+-------+
 	 */
+	if (hugepage_allocation_threads == 0) {
+		hugepage_allocation_threads = num_online_cpus() / 4;
+		hugepage_allocation_threads = max(hugepage_allocation_threads, 1);
+	}
 
-	job.max_threads	= num_allocation_threads;
-	job.min_chunk	= h->max_huge_pages / num_allocation_threads;
+	job.max_threads	= hugepage_allocation_threads;
+	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
 	padata_do_multithreaded(&job);
 
 	return h->nr_huge_pages;
@@ -4995,6 +4998,26 @@ void __init hugetlb_bootmem_alloc(void)
 	__hugetlb_bootmem_allocated = true;
 }
 
+/* hugepage_alloc_threads command line parsing
+ * When set, use this specific number of threads for the boot
+ * allocation of hugepages.
+ */
+static int __init hugepage_alloc_threads_setup(char *s)
+{
+	unsigned long allocation_threads;
+
+	if (kstrtoul(s, 0, &allocation_threads) != 0)
+		return 1;
+
+	if (allocation_threads == 0)
+		return 1;
+
+	hugepage_allocation_threads = allocation_threads;
+
+	return 1;
+}
+__setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
+
 static unsigned int allowed_mems_nr(struct hstate *h)
 {
 	int node;
_

Patches currently in -mm which might be from thomas.prescher@cyberus-technology.de are

mm-hugetlb-improve-parallel-huge-page-allocation-time.patch
mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch
mm-hugetlb-log-time-needed-to-allocate-hugepages.patch

