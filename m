From: akpm@linux-foundation.org
Subject: - cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:10 -0700
Message-ID: <200807141935.m6EJZAAh023876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629AbYGNTfw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:35:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, sfrench@us.ibm.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cifs: fix wksidarr declaration to be big-endian friendly
has been removed from the -mm tree.  Its filename was
     cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: fix wksidarr declaration to be big-endian friendly
From: Jeff Layton <jlayton@redhat.com>

The current definition of wksidarr works fine on little endian arches
(since cpu_to_le32 is a no-op there), but on big-endian arches, it fails
to compile with this error:

error: braced-group within expression allowed only inside a function

The problem is that this static declaration has cpu_to_le32 embedded
within it, and that expands into a function macro.  We need to use
__constant_cpu_to_le32() instead.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsacl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/cifs/cifsacl.c~cifs-fix-wksidarr-declaration-to-be-big-endian-friendly fs/cifs/cifsacl.c
--- a/fs/cifs/cifsacl.c~cifs-fix-wksidarr-declaration-to-be-big-endian-friendly
+++ a/fs/cifs/cifsacl.c
@@ -34,11 +34,11 @@
 static struct cifs_wksid wksidarr[NUM_WK_SIDS] = {
 	{{1, 0, {0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0} }, "null user"},
 	{{1, 1, {0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0} }, "nobody"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
-	{{1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(544), 0, 0, 0} }, "root"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(545), 0, 0, 0} }, "users"},
-	{{1, 2, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(32), cpu_to_le32(546), 0, 0, 0} }, "guest"} }
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(11), 0, 0, 0, 0} }, "net-users"},
+	{{1, 1, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(18), 0, 0, 0, 0} }, "sys"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(544), 0, 0, 0} }, "root"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(545), 0, 0, 0} }, "users"},
+	{{1, 2, {0, 0, 0, 0, 0, 5}, {__constant_cpu_to_le32(32), __constant_cpu_to_le32(546), 0, 0, 0} }, "guest"} }
 ;
 
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

linux-next.patch
git-unionfs.patch

