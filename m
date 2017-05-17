From: akpm@linux-foundation.org
Subject: +
 mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch added to -mm tree
Date: Wed, 17 May 2017 14:58:28 -0700
Message-ID: <591cc784.LU4UiWhyBuKSH9Cy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53450 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753964AbdEQV63 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2017 17:58:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch

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
Subject: mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes

WARNING: line over 80 characters
#31: FILE: mm/util.c:363:
+	 * However make sure that larger requests are not too disruptive - no OOM

total: 0 errors, 1 warnings, 11 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes mm/util.c
--- a/mm/util.c~mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes
+++ a/mm/util.c
@@ -360,8 +360,8 @@ void *kvmalloc_node(size_t size, gfp_t f
 	 * We want to attempt a large physically contiguous block first because
 	 * it is less likely to fragment multiple larger blocks and therefore
 	 * contribute to a long term fragmentation less than vmalloc fallback.
-	 * However make sure that larger requests are not too disruptive - no OOM
-	 * killer and no allocation failure warnings as we have a fallback
+	 * However make sure that larger requests are not too disruptive - no
+	 * OOM killer and no allocation failure warnings as we have a fallback.
 	 */
 	if (size > PAGE_SIZE) {
 		kmalloc_flags |= __GFP_NOWARN;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-clarify-why-we-want-kmalloc-before-falling-backto-vmallock-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

