From: akpm@linux-foundation.org
Subject: - cifs-cifssmbposixlock-should-return-einval-on-error.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:32 -0700
Message-ID: <200805132134.m4DLYWwD000929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916AbYEMVjv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:39:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: CIFSSMBPosixLock should return -EINVAL on error
has been removed from the -mm tree.  Its filename was
     cifs-cifssmbposixlock-should-return-einval-on-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: CIFSSMBPosixLock should return -EINVAL on error
From: Marcin Slusarz <marcin.slusarz@gmail.com>

All other codepaths in this function return negative values on errors.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Steve French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/cifssmb.c~cifs-cifssmbposixlock-should-return-einval-on-error fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c~cifs-cifssmbposixlock-should-return-einval-on-error
+++ a/fs/cifs/cifssmb.c
@@ -1767,7 +1767,7 @@ CIFSSMBPosixLock(const int xid, struct c
 	cFYI(1, ("Posix Lock"));
 
 	if (pLockData == NULL)
-		return EINVAL;
+		return -EINVAL;
 
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

linux-next.patch
git-cifs.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
ntfs-le_add_cpu-conversion.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch
usb-usbtest-comment-on-why-this-code-expects-negative-and-positive-errnos.patch

