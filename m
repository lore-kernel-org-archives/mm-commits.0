From: akpm@linux-foundation.org
Subject: + add-missing-accounting-calls-to-compat_sys_readvwritev.patch added to -mm tree
Date: Wed, 17 Dec 2008 13:37:04 -0800
Message-ID: <200812172137.mBHLb4Rr007401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbYLQVhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 16:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kraxel@redhat.com, balbir@in.ibm.com, jlan@engr.sgi.com


The patch titled
     add missing accounting calls to compat_sys_{readv,writev}
has been added to the -mm tree.  Its filename is
     add-missing-accounting-calls-to-compat_sys_readvwritev.patch

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
Subject: add missing accounting calls to compat_sys_{readv,writev}
From: Gerd Hoffmann <kraxel@redhat.com>

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN fs/compat.c~add-missing-accounting-calls-to-compat_sys_readvwritev fs/compat.c
--- a/fs/compat.c~add-missing-accounting-calls-to-compat_sys_readvwritev
+++ a/fs/compat.c
@@ -1187,6 +1187,9 @@ compat_sys_readv(unsigned long fd, const
 	ret = compat_do_readv_writev(READ, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_rchar(current, ret);
+	inc_syscr(current);
 	fput(file);
 	return ret;
 }
@@ -1210,6 +1213,9 @@ compat_sys_writev(unsigned long fd, cons
 	ret = compat_do_readv_writev(WRITE, file, vec, vlen, &file->f_pos);
 
 out:
+	if (ret > 0)
+		add_wchar(current, ret);
+	inc_syscw(current);
 	fput(file);
 	return ret;
 }
_

Patches currently in -mm which might be from kraxel@redhat.com are

linux-next.patch
add-missing-accounting-calls-to-compat_sys_readvwritev.patch

