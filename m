From: akpm@linux-foundation.org
Subject: + fs-binfmt_elfc-fix-bool-assignements.patch added to -mm tree
Date: Wed, 16 Apr 2014 15:55:06 -0700
Message-ID: <534f0a4a.Fc/Wu7yu53UQ4DSI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaDPWzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + fs-binfmt_elfc-fix-bool-assignements.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:55:06 -0700


The patch titled
     Subject: fs/binfmt_elf.c: fix bool assignements
has been added to the -mm tree.  Its filename is
     fs-binfmt_elfc-fix-bool-assignements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmt_elfc-fix-bool-assignements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmt_elfc-fix-bool-assignements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/binfmt_elf.c: fix bool assignements

Fix coccinelle warnings.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~fs-binfmt_elfc-fix-bool-assignements fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fs-binfmt_elfc-fix-bool-assignements
+++ a/fs/binfmt_elf.c
@@ -1705,7 +1705,7 @@ static size_t get_note_info_size(struct
 static int write_note_info(struct elf_note_info *info,
 			   struct coredump_params *cprm)
 {
-	bool first = 1;
+	bool first = true;
 	struct elf_thread_core_info *t = info->thread;
 
 	do {
@@ -1729,7 +1729,7 @@ static int write_note_info(struct elf_no
 			    !writenote(&t->notes[i], cprm))
 				return 0;
 
-		first = 0;
+		first = false;
 		t = t->next;
 	} while (t);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

