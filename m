From: akpm@linux-foundation.org
Subject: + cifs-cifssmbposixlock-should-return-einval-on-error.patch added to -mm tree
Date: Mon, 12 May 2008 16:39:59 -0700
Message-ID: <200805122339.m4CNdxJ4014954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbYELXlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: CIFSSMBPosixLock should return -EINVAL on error
has been added to the -mm tree.  Its filename is
     cifs-cifssmbposixlock-should-return-einval-on-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

ntfs-le_add_cpu-conversion.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
cifs-cifssmbposixlock-should-return-einval-on-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

