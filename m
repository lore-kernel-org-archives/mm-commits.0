From: akpm@linux-foundation.org
Subject: + mm-hugetlbc-convert-to-pr_foo.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:19:58 -0800
Message-ID: <20121219221958.A085282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:36915 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2LSWUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:20:00 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so292601vba.2
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:19:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: mm/hugetlb.c: convert to pr_foo()
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-convert-to-pr_foo.patch

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
Subject: mm/hugetlb.c: convert to pr_foo()

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-convert-to-pr_foo mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-convert-to-pr_foo
+++ a/mm/hugetlb.c
@@ -1293,8 +1293,7 @@ static void __init report_hugepages(void
 
 	for_each_hstate(h) {
 		char buf[32];
-		printk(KERN_INFO "HugeTLB registered %s page size, "
-				 "pre-allocated %ld pages\n",
+		pr_info("HugeTLB registered %s page size, pre-allocated %ld pages\n",
 			memfmt(buf, huge_page_size(h)),
 			h->free_huge_pages);
 	}
@@ -1702,8 +1701,7 @@ static void __init hugetlb_sysfs_init(vo
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
 					 hstate_kobjs, &hstate_attr_group);
 		if (err)
-			printk(KERN_ERR "Hugetlb: Unable to add hstate %s",
-								h->name);
+			pr_err("Hugetlb: Unable to add hstate %s", h->name);
 	}
 }
 
@@ -1826,9 +1824,8 @@ void hugetlb_register_node(struct node *
 						nhs->hstate_kobjs,
 						&per_node_hstate_attr_group);
 		if (err) {
-			printk(KERN_ERR "Hugetlb: Unable to add hstate %s"
-					" for node %d\n",
-						h->name, node->dev.id);
+			pr_err("Hugetlb: Unable to add hstate %s for node %d\n",
+				h->name, node->dev.id);
 			hugetlb_unregister_node(node);
 			break;
 		}
@@ -1924,7 +1921,7 @@ void __init hugetlb_add_hstate(unsigned 
 	unsigned long i;
 
 	if (size_to_hstate(PAGE_SIZE << order)) {
-		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
+		pr_warning("hugepagesz= specified twice, ignoring\n");
 		return;
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
@@ -1960,8 +1957,8 @@ static int __init hugetlb_nrpages_setup(
 		mhp = &parsed_hstate->max_huge_pages;
 
 	if (mhp == last_mhp) {
-		printk(KERN_WARNING "hugepages= specified twice without "
-			"interleaving hugepagesz=, ignoring\n");
+		pr_warning("hugepages= specified twice without "
+			   "interleaving hugepagesz=, ignoring\n");
 		return 1;
 	}
 
@@ -2692,9 +2689,8 @@ static int hugetlb_no_page(struct mm_str
 	 * COW. Warn that such a situation has occurred as it may not be obvious
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
-		printk(KERN_WARNING
-			"PID %d killed due to inadequate hugepage pool\n",
-			current->pid);
+		pr_warning("PID %d killed due to inadequate hugepage pool\n",
+			   current->pid);
 		return ret;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
sgi-xp-handle-non-fatal-traps-fix.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
block-remove-deadlock-in-disk_clear_events.patch
block-prevent-race-cleanup.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
sendfile-allows-bypassing-of-notifier-events.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

