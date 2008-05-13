From: akpm@linux-foundation.org
Subject: - dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:38 -0700
Message-ID: <200805132134.m4DLYcBn000941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760999AbYEMVe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, ccaulfie@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     [PATCH] dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL
has been removed from the -mm tree.  Its filename was
     dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: [PATCH] dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lowcomms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dlm/lowcomms.c~dlm-tcp_connect_to_sock-should-check-for-einval-not-einval fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c~dlm-tcp_connect_to_sock-should-check-for-einval-not-einval
+++ a/fs/dlm/lowcomms.c
@@ -931,7 +931,7 @@ out_err:
 	 * errors we try again until the max number of retries is reached.
 	 */
 	if (result != -EHOSTUNREACH && result != -ENETUNREACH &&
-	    result != -ENETDOWN && result != EINVAL
+	    result != -ENETDOWN && result != -EINVAL
 	    && result != -EPROTONOSUPPORT) {
 		lowcomms_connect_sock(con);
 		result = 0;
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

