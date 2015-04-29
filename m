From: akpm@linux-foundation.org
Subject: +
 bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch added to -mm tree
Date: Wed, 29 Apr 2015 15:49:03 -0700
Message-ID: <55415fdf.x+0gy11KT/+5yXjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbD2WtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Apr 2015 18:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, peterz@infradead.org, sudeep.holla@arm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix
has been added to the -mm tree.  Its filename is
     bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch

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
Subject: bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix

tweak comment

Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/bitmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix lib/bitmap.c
--- a/lib/bitmap.c~bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix
+++ a/lib/bitmap.c
@@ -462,8 +462,10 @@ EXPORT_SYMBOL(bitmap_parse_user);
  * Output format is a comma-separated list of decimal numbers and
  * ranges if list is specified or hex digits grouped into comma-separated
  * sets of 8 digits/set. Returns the number of characters written to buf.
- * It is assumed that the buffer passed is atleast PAGE_SIZE and easily
- * accommodate nmaskbits.
+ *
+ * It is assumed that @buf is a pointer into a PAGE_SIZE area and that
+ * sufficient storage remains at @buf to accommodate the
+ * bitmap_print_to_pagebuf() output.
  */
 int bitmap_print_to_pagebuf(bool list, char *buf, const unsigned long *maskp,
 			    int nmaskbits)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

