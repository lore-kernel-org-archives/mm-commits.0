From: akpm@linux-foundation.org
Subject: [merged] ipc-shmc-fix-information-leak-to-userland.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:28:58 -0700
Message-ID: <201011051830.oA5IUeJ8025662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab0KESao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:30:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segooon@gmail.com, stable@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ipc/shm.c: fix information leak to userland
has been removed from the -mm tree.  Its filename was
     ipc-shmc-fix-information-leak-to-userland.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/shm.c: fix information leak to userland
From: Vasiliy Kulikov <segooon@gmail.com>

Structure shmid_ds is copied to userland with shm_unused{,2,3} fields
unitialized.  It leads to leaking of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/shm.c~ipc-shmc-fix-information-leak-to-userland ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-fix-information-leak-to-userland
+++ a/ipc/shm.c
@@ -479,6 +479,7 @@ static inline unsigned long copy_shmid_t
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
_

Patches currently in -mm which might be from segooon@gmail.com are

linux-next.patch
drivers-misc-isl29020c-fix-signedness-bug.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-apds9802alsc-fix-signedness-bug.patch
memstick-core-fix-device_register-error-handling.patch

