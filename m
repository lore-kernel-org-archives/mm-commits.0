From: akpm@linux-foundation.org
Subject: + flat-fix-uninitialized-ptr-with-shared-libs.patch added to -mm tree
Date: Tue, 30 Jun 2009 13:22:34 -0700
Message-ID: <200906302022.n5UKMYS6014801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbZF3UXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 16:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: torvalds@linux-foundation.org, bernds_cb1@t-online.de, dhowells@redhat.com, stable@kernel.org, vapier@gentoo.org


The patch titled
     flat: fix uninitialized ptr with shared libs
has been added to the -mm tree.  Its filename is
     flat-fix-uninitialized-ptr-with-shared-libs.patch

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
flat-fix-uninitialized-ptr-with-shared-libs.patch
workaround-for-a-pci-restoring-bug.patch

