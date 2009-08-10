From: akpm@linux-foundation.org
Subject: [merged] flat-fix-uninitialized-ptr-with-shared-libs.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:53 -0700
Message-ID: <200908101927.n7AJRrKb026652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752574AbZHJT3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 15:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, bernds_cb1@t-online.de, dhowells@redhat.com, stable@kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     flat: fix uninitialized ptr with shared libs
has been removed from the -mm tree.  Its filename was
     flat-fix-uninitialized-ptr-with-shared-libs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flat: fix uninitialized ptr with shared libs
From: Linus Torvalds <torvalds@linux-foundation.org>

The new credentials code broke load_flat_shared_library() as it now uses
an uninitialized cred pointer.

Reported-by: Bernd Schmidt <bernds_cb1@t-online.de>
Tested-by: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN fs/binfmt_flat.c~flat-fix-uninitialized-ptr-with-shared-libs fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~flat-fix-uninitialized-ptr-with-shared-libs
+++ a/fs/binfmt_flat.c
@@ -828,15 +828,22 @@ static int load_flat_shared_library(int 
 	if (IS_ERR(bprm.file))
 		return res;
 
+	bprm.cred = prepare_exec_creds();
+	res = -ENOMEM;
+	if (!bprm.cred)
+		goto out;
+
 	res = prepare_binprm(&bprm);
 
 	if (res <= (unsigned long)-4096)
 		res = load_flat_file(&bprm, libs, id, NULL);
-	if (bprm.file) {
-		allow_write_access(bprm.file);
-		fput(bprm.file);
-		bprm.file = NULL;
-	}
+
+	abort_creds(bprm.cred);
+
+out:
+	allow_write_access(bprm.file);
+	fput(bprm.file);
+
 	return(res);
 }
 
_

Patches currently in -mm which might be from torvalds@linux-foundation.org are

origin.patch
linux-next.patch
workaround-for-a-pci-restoring-bug.patch

