From: akpm@linux-foundation.org
Subject: + elf-fix-one-check-after-use.patch added to -mm tree
Date: Wed, 01 Jul 2009 11:56:34 -0700
Message-ID: <200907011856.n61IuYIO003719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbZGAS6Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 14:58:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, dhowells@redhat.com, jmorris@namei.org, roland@redhat.com, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     elf: fix one check-after-use
has been added to the -mm tree.  Its filename is
     elf-fix-one-check-after-use.patch

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
