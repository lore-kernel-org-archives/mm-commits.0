From: akpm@linux-foundation.org
Subject: + binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:54:09 -0700
Message-ID: <20121023225409.90114100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:49769 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2JWWyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:54:10 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so552138ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:54:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com


The patch titled
     Subject: binfmt_elf: fix corner case kfree of uninitialized data
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: binfmt_elf: fix corner case kfree of uninitialized data

If elf_core_dump() is called and fill_note_info() fails in the kmalloc()
then it returns 0 but has not yet initialised all the needed fields.  As a
result we do a kfree(randomness) after correctly skipping the thread data.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data
+++ a/fs/binfmt_elf.c
@@ -1600,8 +1600,10 @@ static int fill_note_info(struct elfhdr 
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	if (psinfo == NULL)
+	if (psinfo == NULL) {
+		info->psinfo.data = NULL;	/* So we don't free this wrongly */
 		return 0;
+        }
 
 	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
 
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
drivers-message-fusion-mptscsihc-missing-break.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch

