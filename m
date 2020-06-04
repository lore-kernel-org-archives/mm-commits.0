From: akpm@linux-foundation.org
Subject: [merged]
 hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code-fix.patch
 removed from -mm tree
Date: Thu, 04 Jun 2020 10:19:25 -0700
Message-ID: <20200604171925.kZ0t1rwDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRT0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, mm-commits@vger.kernel.org, sandipan.osd@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: hugetlbfs: fix changes to command line processing
has been removed from the -mm tree.  Its filename was
     hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: fix changes to command line processing

Previously, a check for hugepages_supported was added before processing
hugetlb command line parameters.  On some architectures such as powerpc,
hugepages_supported() is not set to true until after command line
processing.  Therefore, no hugetlb command line parameters would be
accepted.

Remove the additional checks for hugepages_supported.  In hugetlb_init,
print a warning if !hugepages_supported and command line parameters were
specified.

Link: http://lkml.kernel.org/r/b1f04f9f-fa46-c2a0-7693-4a0679d2a1ee@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Sandipan Das <sandipan.osd@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

--- a/mm/hugetlb.c~hugetlbfs-move-hugepagesz=-parsing-to-arch-independent-code-fix
+++ a/mm/hugetlb.c
@@ -3212,8 +3212,11 @@ static int __init hugetlb_init(void)
 {
 	int i;
 
-	if (!hugepages_supported())
+	if (!hugepages_supported()) {
+		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
+			pr_warn("HugeTLB: huge pages not supported, ignoring associated command-line parameters\n");
 		return 0;
+	}
 
 	/*
 	 * Make sure HPAGE_SIZE (HUGETLB_PAGE_ORDER) hstate exists.  Some
@@ -3315,11 +3318,6 @@ static int __init hugepages_setup(char *
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
 
-	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: huge pages not supported, ignoring hugepages = %s\n", s);
-		return 0;
-	}
-
 	if (!parsed_valid_hugepagesz) {
 		pr_warn("HugeTLB: hugepages=%s does not follow a valid hugepagesz, ignoring\n", s);
 		parsed_valid_hugepagesz = true;
@@ -3372,11 +3370,6 @@ static int __init hugepagesz_setup(char
 	struct hstate *h;
 
 	parsed_valid_hugepagesz = false;
-	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: huge pages not supported, ignoring hugepagesz = %s\n", s);
-		return 0;
-	}
-
 	size = (unsigned long)memparse(s, NULL);
 
 	if (!arch_hugetlb_valid_size(size)) {
@@ -3424,11 +3417,6 @@ static int __init default_hugepagesz_set
 	unsigned long size;
 
 	parsed_valid_hugepagesz = false;
-	if (!hugepages_supported()) {
-		pr_warn("HugeTLB: huge pages not supported, ignoring default_hugepagesz = %s\n", s);
-		return 0;
-	}
