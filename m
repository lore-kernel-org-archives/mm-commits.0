From: akpm@linux-foundation.org
Subject: + jffs2_acl_count-tests-0-on-unsigned.patch added to -mm tree
Date: Mon, 02 Mar 2009 14:10:33 -0800
Message-ID: <200903022210.n22MAXYf027582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752464AbZCBWL3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 17:11:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, dwmw2@infradead.org


The patch titled
     jffs2_acl_count() tests < 0 on unsigned
has been added to the -mm tree.  Its filename is
     jffs2_acl_count-tests-0-on-unsigned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jffs2_acl_count() tests < 0 on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

size_t s is unsigned and cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/acl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/jffs2/acl.c~jffs2_acl_count-tests-0-on-unsigned fs/jffs2/acl.c
--- a/fs/jffs2/acl.c~jffs2_acl_count-tests-0-on-unsigned
+++ a/fs/jffs2/acl.c
@@ -38,12 +38,12 @@ static int jffs2_acl_count(size_t size)
 	size_t s;
 
 	size -= sizeof(struct jffs2_acl_header);
-	s = size - 4 * sizeof(struct jffs2_acl_entry_short);
-	if (s < 0) {
+	if (size < 4 * sizeof(struct jffs2_acl_entry_short)) {
 		if (size % sizeof(struct jffs2_acl_entry_short))
 			return -1;
 		return size / sizeof(struct jffs2_acl_entry_short);
 	} else {
+		s = size - 4 * sizeof(struct jffs2_acl_entry_short);
 		if (s % sizeof(struct jffs2_acl_entry))
 			return -1;
 		return s / sizeof(struct jffs2_acl_entry) + 4;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
mm-get_nid_for_pfn-returns-int.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
jffs2_acl_count-tests-0-on-unsigned.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
hugetlb-chg-cannot-become-less-than-0.patch
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
viafb-returns-0-two-too-early.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch
aoe-error-printed-1-too-early.patch

