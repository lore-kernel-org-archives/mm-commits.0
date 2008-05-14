From: akpm@linux-foundation.org
Subject: - s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch removed from -mm tree
Date: Wed, 14 May 2008 14:22:11 -0700
Message-ID: <200805142122.m4ELMBBi021576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYENVWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 17:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390/char/vmlogrdr: module initialization function should return negative errors
has been removed from the -mm tree.  Its filename was
     s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s390/char/vmlogrdr: module initialization function should return negative errors
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/vmlogrdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/char/vmlogrdr.c~s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors drivers/s390/char/vmlogrdr.c
--- a/drivers/s390/char/vmlogrdr.c~s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors
+++ a/drivers/s390/char/vmlogrdr.c
@@ -858,7 +858,7 @@ static int __init vmlogrdr_init(void)
 	for (i=0; i < MAXMINOR; ++i ) {
 		sys_ser[i].buffer = (char *) get_zeroed_page(GFP_KERNEL);
 		if (!sys_ser[i].buffer) {
-			rc = ENOMEM;
+			rc = -ENOMEM;
 			break;
 		}
 		sys_ser[i].current_position = sys_ser[i].buffer;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
git-jfs.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
ntfs-le_add_cpu-conversion.patch
tty_check_change-avoid-taking-tasklist_lock-while-holding-tty-ctrl_lock.patch

