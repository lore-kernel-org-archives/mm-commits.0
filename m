From: akpm@linux-foundation.org
Subject: + dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch added to -mm tree
Date: Mon, 12 May 2008 16:40:01 -0700
Message-ID: <200805122340.m4CNe2uQ014981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754660AbYELXlK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:41:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, ccaulfie@redhat.com, teigland@redhat.com


The patch titled
     [PATCH] dlm: tcp_connect_to_sock should check for -EINVAL, not EINVAL
has been added to the -mm tree.  Its filename is
     dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch

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

ntfs-le_add_cpu-conversion.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
cifs-cifssmbposixlock-should-return-einval-on-error.patch
dlm-tcp_connect_to_sock-should-check-for-einval-not-einval.patch
isdn-capi-return-proper-errnos-on-module-init.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
s390-char-vmlogrdr-module-initialization-function-should-return-negative-errors.patch

