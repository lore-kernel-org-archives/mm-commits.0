From: akpm@linux-foundation.org
Subject: + drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch added
 to -mm tree
Date: Wed, 23 Aug 2017 16:14:30 -0700
Message-ID: <599e0c56.s/LCkVgm+sxNTnyq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdHWXOb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Aug 2017 19:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hans.verkuil@cisco.com, maxime.ripard@free-electrons.com, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4
has been added to the -mm tree.  Its filename is
     drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch

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
Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with initialization of anonymous unions:

drivers/media/cec/cec-adap.c: In function 'cec_queue_msg_fh':
drivers/media/cec/cec-adap.c:184: error: unknown field 'lost_msgs' specified in initializer

work around this.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/cec/cec-adap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/media/cec/cec-adap.c~drivers-media-cec-cec-adapc-fix-build-with-gcc-444 drivers/media/cec/cec-adap.c
--- a/drivers/media/cec/cec-adap.c~drivers-media-cec-cec-adapc-fix-build-with-gcc-444
+++ a/drivers/media/cec/cec-adap.c
@@ -181,7 +181,10 @@ static void cec_queue_msg_fh(struct cec_
 {
 	static const struct cec_event ev_lost_msgs = {
 		.event = CEC_EVENT_LOST_MSGS,
-		.lost_msgs.lost_msgs = 1,
+		.flags = 0,
+		{
+			.lost_msgs = { 1 },
+		},
 	};
 	struct cec_msg_entry *entry;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
vga-optimise-console-scrolling-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

