From: akpm@linux-foundation.org
Subject: - add-missing-accounting-calls-to-compat_sys_readvwritev.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:08 -0800
Message-ID: <200901072216.n07MG8oq015822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760003AbZAGWQ1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kraxel@redhat.com, balbir@in.ibm.com, jlan@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     add missing accounting calls to compat_sys_{readv,writev}
has been removed from the -mm tree.  Its filename was
     add-missing-accounting-calls-to-compat_sys_readvwritev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

