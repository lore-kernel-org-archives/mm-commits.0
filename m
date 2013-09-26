From: akpm@linux-foundation.org
Subject: + mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
 added to -mm tree
Date: Wed, 25 Sep 2013 18:08:23 -0700
Message-ID: <52438907.qBnCMwneM+owuz8s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab3IZBIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 21:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, lliubbo@gmail.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidoff@qedmf.net, bob.liu@oracle.com, aarcange@redhat.com, akpm@linux-foundation.org

Subject: + mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,bob.liu@oracle.com,davidoff@qedmf.net,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,lliubbo@gmail.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 18:08:23 -0700


The patch titled
     Subject: mm-thp-khugepaged-add-policy-for-finding-target-node-fix
has been added to the -mm tree.  Its filename is
     mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2133,10 +2133,11 @@ static void khugepaged_alloc_sleep(void)
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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

