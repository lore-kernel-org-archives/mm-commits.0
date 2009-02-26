From: akpm@linux-foundation.org
Subject: [merged] ia64-beyond-array_size-of-unwhash.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:29 -0800
Message-ID: <200902261930.n1QJUTMZ014429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbZBZTad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix access beyond ARRAY_SIZE of unw.hash
has been removed from the -mm tree.  Its filename was
     ia64-beyond-array_size-of-unwhash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix access beyond ARRAY_SIZE of unw.hash
From: Roel Kluin <roel.kluin@gmail.com>

static struct {

... :114
        unsigned short hash[UNW_HASH_SIZE];

... :147
} unw = {

... :228
        .hash = { [0 ... UNW_HASH_SIZE - 1] = -1 },
...
};

Do not go beyond ARRAY_SIZE of unw.hash

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/unwind.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/unwind.c~ia64-beyond-array_size-of-unwhash arch/ia64/kernel/unwind.c
--- a/arch/ia64/kernel/unwind.c~ia64-beyond-array_size-of-unwhash
+++ a/arch/ia64/kernel/unwind.c
@@ -2149,7 +2149,7 @@ unw_remove_unwind_table (void *handle)
 
 	/* next, remove hash table entries for this table */
 
-	for (index = 0; index <= UNW_HASH_SIZE; ++index) {
+	for (index = 0; index < UNW_HASH_SIZE; ++index) {
 		tmp = unw.cache + unw.hash[index];
 		if (unw.hash[index] >= UNW_CACHE_SIZE
 		    || tmp->ip < table->start || tmp->ip >= table->end)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

