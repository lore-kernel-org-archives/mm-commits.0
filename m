From: akpm@linux-foundation.org
Subject: + documentation-spi-spidev_testc-fix-warning.patch added to -mm
 tree
Date: Thu, 19 Mar 2015 16:38:11 -0700
Message-ID: <550b5de3.8gLxc7kSgzOrWrzu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbCSXiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Mar 2015 19:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/spi/spidev_test.c: fix warning
has been added to the -mm tree.  Its filename is
     documentation-spi-spidev_testc-fix-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-spi-spidev_testc-fix-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-spi-spidev_testc-fix-warning.patch

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
Subject: Documentation/spi/spidev_test.c: fix warning

Documentation/spi/spidev_test.c:83:5: warning: no previous prototype for 'unespcape' [-Wmissing-prototypes]

fix spelling too.

Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev_test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-fix-warning Documentation/spi/spidev_test.c
--- a/Documentation/spi/spidev_test.c~documentation-spi-spidev_testc-fix-warning
+++ a/Documentation/spi/spidev_test.c
@@ -80,7 +80,7 @@ static void hex_dump(const void *src, si
  *  Unescape - process hexadecimal escape character
  *      converts shell input "\x23" -> 0x23
  */
-int unespcape(char *_dst, char *_src, size_t len)
+static int unescape(char *_dst, char *_src, size_t len)
 {
 	int ret = 0;
 	char *src = _src;
@@ -304,7 +304,7 @@ int main(int argc, char *argv[])
 		size = strlen(input_tx+1);
 		tx = malloc(size);
 		rx = malloc(size);
-		size = unespcape((char *)tx, input_tx, size);
+		size = unescape((char *)tx, input_tx, size);
 		transfer(fd, tx, rx, size);
 		free(rx);
 		free(tx);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

