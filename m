From: akpm@linux-foundation.org
Subject: [merged]
 drivers-staging-media-cec-cec-adapc-work-around-gcc-444-anon-union-initializer-bug.patch removed from -mm tree
Date: Wed, 13 Jul 2016 14:45:28 -0700
Message-ID: <5786b678.tr1Iq2OK89xDT5Jo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbcGMVpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 17:45:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hans.verkuil@cisco.com, kamil@wypas.org, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/staging/media/cec/cec-adap.c: work around gcc-4.4.4 anon union initializer bug
has been removed from the -mm tree.  Its filename was
     drivers-staging-media-cec-cec-adapc-work-around-gcc-444-anon-union-initializer-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/staging/media/cec/cec-adap.c: work around gcc-4.4.4 anon union initializer bug

drivers/staging/media/cec/cec-adap.c: In function 'cec_queue_msg_fh':
drivers/staging/media/cec/cec-adap.c:141: error: unknown field 'lost_msgs' specified in initializer

Fixes: 9881fe0ca187c21 ("[media] cec: add HDMI CEC framework (adapter)")
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/media/cec/cec-adap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/staging/media/cec/cec-adap.c~drivers-staging-media-cec-cec-adapc-work-around-gcc-444-anon-union-initializer-bug drivers/staging/media/cec/cec-adap.c
--- a/drivers/staging/media/cec/cec-adap.c~drivers-staging-media-cec-cec-adapc-work-around-gcc-444-anon-union-initializer-bug
+++ a/drivers/staging/media/cec/cec-adap.c
@@ -137,8 +137,12 @@ static void cec_queue_event(struct cec_a
 static void cec_queue_msg_fh(struct cec_fh *fh, const struct cec_msg *msg)
 {
 	static const struct cec_event ev_lost_msg = {
+		.ts = 0,
 		.event = CEC_EVENT_LOST_MSGS,
-		.lost_msgs.lost_msgs = 1,
+		.flags = 0,
+		{
+			.lost_msgs.lost_msgs = 1,
+		},
 	};
 	struct cec_msg_entry *entry;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-improve-recovery-performance-v2-fix.patch
ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler-fix.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
mm-zsmalloc-add-per-class-compact-trace-event-checkpatch-fixes.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
drivers-leds-leds-lp3952c-work-around-gcc-444-union-initializer-bug.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

