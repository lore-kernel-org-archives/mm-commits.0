From: akpm@linux-foundation.org
Subject: + gcov-add-support-for-gcc-47-gcov-format-fix.patch added to -mm
 tree
Date: Wed, 18 Sep 2013 14:24:20 -0700
Message-ID: <523a1a04.EygIRpKiqwY808Tv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3IRVYV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:24:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, akpm@linux-foundation.org

Subject: + gcov-add-support-for-gcc-47-gcov-format-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fhrbata@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:24:20 -0700


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-fix
has been added to the -mm tree.  Its filename is
     gcov-add-support-for-gcc-47-gcov-format-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-support-for-gcc-47-gcov-format-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-support-for-gcc-47-gcov-format-fix.patch

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
Subject: gcov-add-support-for-gcc-47-gcov-format-fix

use kmemdup() and kcalloc()

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix
+++ a/kernel/gcov/gcc_4_7.c
@@ -254,11 +254,10 @@ struct gcov_info *gcov_info_dup(struct g
 	size_t fi_size; /* function info size */
 	size_t cv_size; /* counter values size */
 
-	dup = kmalloc(sizeof(struct gcov_info), GFP_KERNEL);
+	dup = kmemdup(info, sizeof(*dup), GFP_KERNEL);
 	if (!dup)
 		return NULL;
 
-	*dup = *info;
 	dup->next = NULL;
 	dup->filename = NULL;
 	dup->functions = NULL;
@@ -267,8 +266,8 @@ struct gcov_info *gcov_info_dup(struct g
 	if (!dup->filename)
 		goto err_free;
 
-	dup->functions = kzalloc(sizeof(struct gcov_fn_info *) *
-			info->n_functions, GFP_KERNEL);
+	dup->functions = kcalloc(sizeof(struct gcov_fn_info *),
+				 info->n_functions, GFP_KERNEL);
 	if (!dup->functions)
 		goto err_free;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

