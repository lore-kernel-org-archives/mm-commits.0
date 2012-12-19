From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch added to -mm tree
Date: Wed, 19 Dec 2012 14:12:29 -0800
Message-ID: <20121219221230.3F1ED82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47270 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2LSWMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 17:12:31 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so292011yen.0
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 14:12:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, handai.szj@taobao.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch

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
Subject: mm/memcontrol.c: convert printk(KERN_FOO) to pr_foo()

Cc: Sha Zhengju <handai.szj@taobao.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-convert-printkkern_foo-to-pr_foo
+++ a/mm/memcontrol.c
@@ -1574,7 +1574,7 @@ void mem_cgroup_print_oom_info(struct me
 	}
 	rcu_read_unlock();
 
-	printk(KERN_INFO "Task in %s killed", memcg_name);
+	pr_info("Task in %s killed", memcg_name);
 
 	rcu_read_lock();
 	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
@@ -1587,19 +1587,18 @@ void mem_cgroup_print_oom_info(struct me
 	/*
 	 * Continues from above, so we don't need an KERN_ level
 	 */
-	printk(KERN_CONT " as a result of limit of %s\n", memcg_name);
+	pr_cont(" as a result of limit of %s\n", memcg_name);
 done:
 
-	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("memory: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->res, RES_FAILCNT));
-	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
-		"failcnt %llu\n",
+	pr_info("memory+swap: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
-	printk(KERN_INFO "kmem: usage %llukB, limit %llukB, failcnt %llu\n",
+	pr_info("kmem: usage %llukB, limit %llukB, failcnt %llu\n",
 		res_counter_read_u64(&memcg->kmem, RES_USAGE) >> 10,
 		res_counter_read_u64(&memcg->kmem, RES_LIMIT) >> 10,
 		res_counter_read_u64(&memcg->kmem, RES_FAILCNT));
@@ -4424,8 +4423,8 @@ void mem_cgroup_print_bad_page(struct pa
 
 	pc = lookup_page_cgroup_used(page);
 	if (pc) {
-		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
-		       pc, pc->flags, pc->mem_cgroup);
+		pr_alert("pc:%p pc->flags:%lx pc->mem_cgroup:%p\n",
+			 pc, pc->flags, pc->mem_cgroup);
 	}
 }
 #endif
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

