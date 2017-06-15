From: akpm@linux-foundation.org
Subject: +
 lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch added to -mm tree
Date: Thu, 15 Jun 2017 14:37:04 -0700
Message-ID: <5942fe00.zHktw4LkfpRCbzTb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751016AbdFOVhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 17:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, thomas@m3y3r.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch

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
Subject: lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes

WARNING: line over 80 characters
#42: FILE: kernel/extable.c:58:
+	e = search_extable(__start___ex_table, __stop___ex_table - __start___ex_table, addr);

ERROR: "foo * bar" should be "foo *bar"
#94: FILE: lib/extable.c:100:
+	const struct exception_table_entry * _elt = elt;

ERROR: "(foo*)" should be "(foo *)"
#95: FILE: lib/extable.c:101:
+	unsigned long k = *(unsigned long*) key;

WARNING: line over 80 characters
#132: FILE: lib/extable.c:123:
+	return bsearch(&value, first, num, sizeof(struct exception_table_entry), cmp_ex_search);

total: 2 errors, 2 warnings, 100 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/lib-extablec-use-bsearch-library-function-in-search_extable.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    3 ++-
 lib/extable.c    |    7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes kernel/extable.c
--- a/kernel/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes
+++ a/kernel/extable.c
@@ -55,7 +55,8 @@ const struct exception_table_entry *sear
 {
 	const struct exception_table_entry *e;
 
-	e = search_extable(__start___ex_table, __stop___ex_table - __start___ex_table, addr);
+	e = search_extable(__start___ex_table,
+			   __stop___ex_table - __start___ex_table, addr);
 	if (!e)
 		e = search_module_extables(addr);
 	return e;
diff -puN lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes lib/extable.c
--- a/lib/extable.c~lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes
+++ a/lib/extable.c
@@ -97,8 +97,8 @@ void trim_init_extable(struct module *m)
 
 static int cmp_ex_search(const void *key, const void *elt)
 {
-	const struct exception_table_entry * _elt = elt;
-	unsigned long k = *(unsigned long*) key;
+	const struct exception_table_entry *_elt = elt;
+	unsigned long k = *(unsigned long *)key;
 
 	/* avoid overflow */
 	if (k > ex_to_insn(_elt))
@@ -120,6 +120,7 @@ search_extable(const struct exception_ta
 	       const size_t num,
 	       unsigned long value)
 {
-	return bsearch(&value, first, num, sizeof(struct exception_table_entry), cmp_ex_search);
+	return bsearch(&value, first, num,
+		       sizeof(struct exception_table_entry), cmp_ex_search);
 }
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
lib-extablec-use-bsearch-library-function-in-search_extable-checkpatch-fixes.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

