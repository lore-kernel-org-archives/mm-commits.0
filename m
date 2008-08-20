From: akpm@linux-foundation.org
Subject: - xtensa-use-newer-__spin_lock_unlocked-macro.patch removed from -mm tree
Date: Wed, 20 Aug 2008 13:13:02 -0700
Message-ID: <200808202013.m7KKD2A6029395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755415AbYHTUNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 16:13:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: use newer __SPIN_LOCK_UNLOCKED macro
has been removed from the -mm tree.  Its filename was
     xtensa-use-newer-__spin_lock_unlocked-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use newer __SPIN_LOCK_UNLOCKED macro
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

SPIN_LOCK_UNLOCKED() breaks lockdep and is deprecated.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/platforms/iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/xtensa/platforms/iss/network.c~xtensa-use-newer-__spin_lock_unlocked-macro arch/xtensa/platforms/iss/network.c
--- a/arch/xtensa/platforms/iss/network.c~xtensa-use-newer-__spin_lock_unlocked-macro
+++ a/arch/xtensa/platforms/iss/network.c
@@ -640,7 +640,7 @@ static int iss_net_configure(int index, 
 	*lp = ((struct iss_net_private) {
 		.device_list		= LIST_HEAD_INIT(lp->device_list),
 		.opened_list		= LIST_HEAD_INIT(lp->opened_list),
-		.lock			= SPIN_LOCK_UNLOCKED,
+		.lock			= __SPIN_LOCK_UNLOCKED(lp.lock),
 		.dev			= dev,
 		.index			= index,
 		//.fd                   = -1,
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch
uml-remove-the-dead-tty_log-code.patch
inith-remove-long-dead-__setup_null_param-macro.patch
oss-remove-references-to-dead-sound-oss-vars-aedsp16_msssbpro.patch
fs-partitions-acornc-remove-dead-code.patch

