From: akpm@linux-foundation.org
Subject: + coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch added to -mm tree
Date: Wed, 12 Sep 2012 15:07:44 -0700
Message-ID: <20120912220744.BE938100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:61346 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2ILWHp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 18:07:45 -0400
Received: by ghbz15 with SMTP id z15so62864ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 15:07:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vda.linux@googlemail.com, oleg@redhat.com, stable@vger.kernel.org, vbyravarasu@nvidia.com


The patch titled
     Subject: coredump: prevent double-free on an error path in core dumper
has been added to the -mm tree.  Its filename is
     coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: coredump: prevent double-free on an error path in core dumper

In !CORE_DUMP_USE_REGSET case, if elf_note_info_init fails to allocate
memory for info->fields, it frees already allocated stuff and returns
error to its caller, fill_note_info.  Which in turn returns error to its
caller, elf_core_dump.  Which jumps to cleanup label and calls
free_note_info, which will happily try to free all info->fields again. 
BOOM.

This is the fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-prevent-double-free-on-an-error-path-in-core-dumper fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-prevent-double-free-on-an-error-path-in-core-dumper
+++ a/fs/binfmt_elf.c
@@ -1695,30 +1695,19 @@ static int elf_note_info_init(struct elf
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		goto notes_free;
+		return 0;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		goto psinfo_free;
+		return 0;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		goto prstatus_free;
+		return 0;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		goto fpu_free;
+		return 0;
 #endif
 	return 1;
-#ifdef ELF_CORE_COPY_XFPREGS
- fpu_free:
-	kfree(info->fpu);
-#endif
- prstatus_free:
-	kfree(info->prstatus);
- psinfo_free:
-	kfree(info->psinfo);
- notes_free:
-	kfree(info->notes);
-	return 0;
 }
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,
_

Patches currently in -mm which might be from vda.linux@googlemail.com are

lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-fix-broken-comments.patch
coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch

