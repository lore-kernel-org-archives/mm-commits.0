Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8850B155757
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188528; cv=none; b=EkyBmgflkmT5hsZ2kdl8UDcatr9XC7m2NLNhoIG02fNqcV+PEUrlIQVxPXhXB8hcwb8shZHhk9XOO116oZuQgYonymmb76kY7SS4FkxF96+Z6v79XzT3GHmrDZiJpVH/2g6ufh8N8C5tO3ohedW/eDh00ERy3aqCmKF8N7pOgGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188528; c=relaxed/simple;
	bh=r0VNM53YuDicGUTxzZemsRjHj+OCrebp/RVuBTOMwug=;
	h=Date:To:From:Subject:Message-Id; b=TV0HiCLElhZZEWXVYoNKu09VdkT09pD5WooiBgDIbPZ0b3RupKxKeT2kjdrKAvkJbwWwJ3eCJTVFChjXJwevirhD435Jm5xqlHJyD64ujdadgcMTx1cDR6oG49S7g4Kur3qmQz2JIZOLDWUc98ejpD6VaUocnRdvzT0Z0FOrqcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njTPfI0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njTPfI0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F5BC4CEEC;
	Mon, 17 Mar 2025 05:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188528;
	bh=r0VNM53YuDicGUTxzZemsRjHj+OCrebp/RVuBTOMwug=;
	h=Date:To:From:Subject:From;
	b=njTPfI0HHmusAKTSnG8hOD5/Ir8dv+ZdObVfn93Eu3LdK5AD7bbdZjEVSF3jLzJ6g
	 mZCgPoyVpfV2Upi0LY4Ff8zkbpNMxoGwtXJEHY8uRlaMmYNHvIYv3Y44t8olQjEkQ5
	 MlmN07I1E3zLTT7xr0OCNtwSVj12LRVWVsCTc0Qg=
Date: Sun, 16 Mar 2025 22:15:27 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,corbet@lwn.net,thomas.prescher@cyberus-technology.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch removed from -mm tree
Message-Id: <20250317051528.59F5BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb: add hugetlb_alloc_threads cmdline option
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugetlb_alloc_threads-cmdline-option.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Subject: mm: hugetlb: add hugetlb_alloc_threads cmdline option
Date: Thu, 27 Feb 2025 23:45:06 +0100

Add a command line option that enables control of how many threads should
be used to allocate huge pages.

[akpm@linux-foundation.org: tidy up a comment]
Link: https://lkml.kernel.org/r/20250227-hugepage-parameter-v2-2-7db8c6dc0453@cyberus-technology.de
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    9 +++
 Documentation/admin-guide/mm/hugetlbpage.rst    |   10 ++++
 mm/hugetlb.c                                    |   33 ++++++++++++--
 3 files changed, 48 insertions(+), 4 deletions(-)

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
@@ -3607,8 +3608,6 @@ static unsigned long __init hugetlb_page
 		.numa_aware	= true
 	};
 
-	unsigned int num_allocation_threads = max(num_online_cpus() / 4, 1);
-
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
 	job.size	= h->max_huge_pages;
@@ -3629,9 +3628,13 @@ static unsigned long __init hugetlb_page
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
@@ -5000,6 +5003,28 @@ void __init hugetlb_bootmem_alloc(void)
 	__hugetlb_bootmem_allocated = true;
 }
 
+/*
+ * hugepage_alloc_threads command line parsing.
+ *
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


