From: akpm@linux-foundation.org
Subject: + cifs-fix-unbalanced-calls-to-get-freexid.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:04:01 -0700
Message-ID: <200708240004.l7O041uO001253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54489 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636AbXHXAEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, sfrench@us.ibm.com


The patch titled
     CIFS: fix unbalanced calls to Get/FreeXid
has been added to the -mm tree.  Its filename is
     cifs-fix-unbalanced-calls-to-get-freexid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CIFS: fix unbalanced calls to Get/FreeXid
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix unbalanced calls to GetXid/FreeXid.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/cifs/cifsfs.c~cifs-fix-unbalanced-calls-to-get-freexid fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~cifs-fix-unbalanced-calls-to-get-freexid
+++ a/fs/cifs/cifsfs.c
@@ -346,7 +346,7 @@ int cifs_xquota_set(struct super_block *
 	if (pTcon) {
 		cFYI(1, ("set type: 0x%x id: %d", quota_type, qid));
 	} else {
-		return -EIO;
+		rc = -EIO;
 	}
 
 	FreeXid(xid);
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
cifs-fix-unbalanced-calls-to-get-freexid.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc-interface.patch
