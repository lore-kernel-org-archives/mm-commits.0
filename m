From: akpm@linux-foundation.org
Subject: + fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch added to -mm tree
Date: Tue, 18 Jan 2011 16:54:48 -0800
Message-ID: <201101190054.p0J0smYu016888__9968.89039311117$1295398506$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab1ASAzA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 19:55:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dillowda@ornl.gov, jmoyer@redhat.com, stable@kernel.org


The patch titled
     fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix
has been added to the -mm tree.  Its filename is
     fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch

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
Subject: fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix
From: Andrew Morton <akpm@linux-foundation.org>

remove redundant BUG_ON()

Cc: <stable@kernel.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/direct-io.c~fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix
+++ a/fs/direct-io.c
@@ -336,7 +336,6 @@ dio_bio_alloc(struct dio *dio, struct bl
 	 * __GFP_WAIT and we request a valid number of vectors.
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
-	BUG_ON(!bio);
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-compaction-prevent-division-by-zero-during-user-requested-compaction-fix.patch
fs-direct-ioc-dont-try-to-allocate-more-than-bio_max_pages-in-a-bio-fix.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-make-nr_to_write-a-per-file-limit.patch
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

