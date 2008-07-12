From: akpm@linux-foundation.org
Subject: + cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:51:44 -0700
Message-ID: <200807120051.m6C0pi1q013191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbYGLAwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, sfrench@us.ibm.com, stable@kernel.org


The patch titled
     cifs: fix wksidarr declaration to be big-endian friendly
has been added to the -mm tree.  Its filename is
     cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch

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
cifs-fix-inode-leak-in-cifs_get_inode_info_unix.patch
cifs-fix-wksidarr-declaration-to-be-big-endian-friendly.patch
git-unionfs.patch

