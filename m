From: akpm@linux-foundation.org
Subject: - fix-logic-error-in-ipc-compat-semctl.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:19 -0700
Message-ID: <200707080811.l688BJUF014756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbXGHIL2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agraf@suse.de, mm-commits@vger.kernel.org


The patch titled
     fix logic error in ipc compat semctl()
has been removed from the -mm tree.  Its filename was
     fix-logic-error-in-ipc-compat-semctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix logic error in ipc compat semctl()
From: Alexander Graf <agraf@suse.de>

When calling a semctl(IPC_STAT) without IPC_64 the check if the memory is
unevaluated.  This patch fixes this.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/compat.c~fix-logic-error-in-ipc-compat-semctl ipc/compat.c
--- a/ipc/compat.c~fix-logic-error-in-ipc-compat-semctl
+++ a/ipc/compat.c
@@ -225,7 +225,7 @@ static inline int put_compat_semid_ds(st
 	int err;
 
 	if (!access_ok (VERIFY_WRITE, up, sizeof(*up)))
-		err = -EFAULT;
+		return -EFAULT;
 	err  = __put_compat_ipc_perm(&s->sem_perm, &up->sem_perm);
 	err |= __put_user(s->sem_otime, &up->sem_otime);
 	err |= __put_user(s->sem_ctime, &up->sem_ctime);
_

Patches currently in -mm which might be from agraf@suse.de are

origin.patch
