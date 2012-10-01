From: akpm@linux-foundation.org
Subject: [merged] coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:29:04 -0700
Message-ID: <20121001192904.B8A90100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48494 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JAT3F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:29:05 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so8389ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:29:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vda.linux@googlemail.com, oleg@redhat.com, stable@vger.kernel.org, vbyravarasu@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump: prevent double-free on an error path in core dumper
has been removed from the -mm tree.  Its filename was
     coredump-prevent-double-free-on-an-error-path-in-core-dumper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
lib-vsprintf-optimize-division-by-10-for-small-integers.patch
lib-vsprintf-optimize-division-by-10000.patch
lib-vsprintf-optimize-put_dec_trunc8.patch
lib-vsprintf-optimize-put_dec_trunc8-fix.patch
lib-vsprintf-fix-broken-comments.patch
coredump-add-support-for-%d=__get_dumpable-in-core-name.patch
coredump-pass-siginfo_t-to-do_coredump-and-below-not-merely-signr.patch
compat-move-compat_siginfo_t-definition-to-asm-compath.patch
coredump-add-a-new-elf-note-with-siginfo-of-the-signal.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

