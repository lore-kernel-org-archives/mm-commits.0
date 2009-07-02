From: akpm@linux-foundation.org
Subject: [merged] elf-fix-one-check-after-use.patch removed from -mm tree
Date: Thu, 02 Jul 2009 11:33:16 -0700
Message-ID: <200907021833.n62IXGGa017876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbZGBSfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 14:35:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     elf: fix one check-after-use
has been removed from the -mm tree.  Its filename was
     elf-fix-one-check-after-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: elf: fix one check-after-use
From: Amerigo Wang <amwang@redhat.com>

Move the check for failed kmalloc() to the correct place.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~elf-fix-one-check-after-use fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-fix-one-check-after-use
+++ a/fs/binfmt_elf.c
@@ -1522,11 +1522,11 @@ static int fill_note_info(struct elfhdr 
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
