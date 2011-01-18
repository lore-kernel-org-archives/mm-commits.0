From: akpm@linux-foundation.org
Subject: + mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch added to -mm tree
Date: Tue, 18 Jan 2011 15:08:03 -0800
Message-ID: <201101182308.p0IN84Hr011118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab1ARXIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 18:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mel@csn.ul.ie


The patch titled
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch

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
Subject: mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
From: Andrew Morton <akpm@linux-foundation.org>

add comment, per Mel

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix
+++ a/mm/compaction.c
@@ -453,6 +453,10 @@ unsigned long compaction_suitable(struct
 	if (!zone_watermark_ok(zone, 0, watermark, 0, 0))
 		return COMPACT_SKIPPED;
 
+	/*
+	 * order == -1 is expected when compacting via
+	 * /proc/sys/vm/compact_memory
+	 */
 	if (order == -1)
 		return COMPACT_CONTINUE;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-make-nr_to_write-a-per-file-limit.patch
mm-deactivate-invalidated-pages.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

