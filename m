From: akpm@linux-foundation.org
Subject: + fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch added to -mm tree
Date: Fri, 28 May 2010 09:50:48 -0700
Message-ID: <201005281650.o4SGolVs000932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0E1QvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 May 2010 12:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, jmoyer@redhat.com, stable@kernel.org


The patch titled
     fs/compat_rw_copy_check_uvector: add missing compat_ptr call
has been added to the -mm tree.  Its filename is
     fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/compat_rw_copy_check_uvector: add missing compat_ptr call
From: Heiko Carstens <heiko.carstens@de.ibm.com>

A call to access_ok is missing a compat_ptr conversion.  Introduced with
b83733639a494d5f42fa00a2506563fbd2d3015d "compat: factor out
compat_rw_copy_check_uvector from compat_do_readv_writev"

fs/compat.c: In function 'compat_rw_copy_check_uvector':
fs/compat.c:629: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/compat.c~fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call fs/compat.c
--- a/fs/compat.c~fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call
+++ a/fs/compat.c
@@ -626,7 +626,7 @@ ssize_t compat_rw_copy_check_uvector(int
 		tot_len += len;
 		if (tot_len < tmp) /* maths overflow on the compat_ssize_t */
 			goto out;
-		if (!access_ok(vrfy_dir(type), buf, len)) {
+		if (!access_ok(vrfy_dir(type), compat_ptr(buf), len)) {
 			ret = -EFAULT;
 			goto out;
 		}
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
s390-convert-cpu-notifier-to-return-encapsulate-errno-value.patch
fs-compat_rw_copy_check_uvector-add-missing-compat_ptr-call.patch
linux-next.patch
drivers-s390-net-use-memdup_user.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

