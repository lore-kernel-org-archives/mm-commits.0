From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:34:35 -0800
Message-ID: <5282acfb.OeehIf/Jv8hJBEIW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3KLWeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:34:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, lliubbo@gmail.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidoff@qedmf.net, bob.liu@oracle.com, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,bob.liu@oracle.com,davidoff@qedmf.net,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,lliubbo@gmail.com,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:34:35 -0800


The patch titled
     Subject: mm-thp-khugepaged-add-policy-for-finding-target-node-fix
has been removed from the -mm tree.  Its filename was
     mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch

This patch was dropped because it was folded into mm-thp-khugepaged-add-policy-for-finding-target-node.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-khugepaged-add-policy-for-finding-target-node-fix

make last_khugepaged_target_node local to khugepaged_find_target_node()

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Davidoff <davidoff@qedmf.net>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-khugepaged-add-policy-for-finding-target-node-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-khugepaged-add-policy-for-finding-target-node-fix
+++ a/mm/huge_memory.c
@@ -2159,10 +2159,11 @@ static void khugepaged_alloc_sleep(void)
 }
 
 static int khugepaged_node_load[MAX_NUMNODES];
+
 #ifdef CONFIG_NUMA
-static int last_khugepaged_target_node = NUMA_NO_NODE;
 static int khugepaged_find_target_node(void)
 {
+	static int last_khugepaged_target_node = NUMA_NO_NODE;
 	int nid, target_node = 0, max_value = 0;
 
 	/* find first node with max normal pages hit */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation-fix.patch
mm-factor-commit-limit-calculation-fix-fix.patch
mm-factor-commit-limit-calculation-fix-fix-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch

