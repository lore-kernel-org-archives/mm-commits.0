From: akpm@linux-foundation.org
Subject: [merged]
 drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch removed from -mm
 tree
Date: Fri, 15 Sep 2017 10:51:13 -0700
Message-ID: <20170915175113.RxSj8s7Vp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdIORvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Sep 2017 13:51:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, hans.verkuil@cisco.com, maxime.ripard@free-electrons.com, mchehab@s-opensource.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4
has been removed from the -mm tree.  Its filename was
     drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/media/cec/cec-adap.c: fix build with gcc-4.4.4

gcc-4.4.4 has issues with initialization of anonymous unions:

drivers/media/cec/cec-adap.c: In function 'cec_queue_msg_fh':
drivers/media/cec/cec-adap.c:184: error: unknown field 'lost_msgs' specified in initializer

work around this.

Fixes: 6b2bbb08747a5 ("media: cec: rework the cec event handling")
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
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
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

