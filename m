From: akpm@linux-foundation.org
Subject: + elf-clean-up-fill_note_info.patch added to -mm tree
Date: Wed, 01 Jul 2009 13:43:07 -0700
Message-ID: <200907012043.n61Kh7fh024005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZGAUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 16:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     elf: clean up fill_note_info()
has been added to the -mm tree.  Its filename is
     elf-clean-up-fill_note_info.patch

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
Subject: elf: clean up fill_note_info()
From: Amerigo Wang <amwang@redhat.com>

Introduce a helper function elf_note_info_init() to help fill_note_info()
to do initializations, also fix the potential memory leaks.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |   50 +++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff -puN fs/binfmt_elf.c~elf-clean-up-fill_note_info fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~elf-clean-up-fill_note_info
+++ a/fs/binfmt_elf.c
@@ -1714,42 +1714,54 @@ struct elf_note_info {
 	int numnote;
 };
 
-static int fill_note_info(struct elfhdr *elf, int phdrs,
-			  struct elf_note_info *info,
-			  long signr, struct pt_regs *regs)
+static int elf_note_info_init(struct elf_note_info *info)
 {
-#define	NUM_NOTES	6
-	struct list_head *t;
-
-	info->notes = NULL;
-	info->prstatus = NULL;
-	info->psinfo = NULL;
-	info->fpu = NULL;
-#ifdef ELF_CORE_COPY_XFPREGS
-	info->xfpu = NULL;
-#endif
+	memset(info, 0, sizeof(*info));
 	INIT_LIST_HEAD(&info->thread_list);
 
+#define	NUM_NOTES	6
 	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
 			      GFP_KERNEL);
+#undef NUM_NOTES
 	if (!info->notes)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		return 0;
+		goto notes_free;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		return 0;
+		goto psinfo_free;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		return 0;
+		goto prstatus_free;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		return 0;
+		goto fpu_free;
+#endif
+	return 1;
+#ifdef ELF_CORE_COPY_XFPREGS
+ fpu_free:
+	kfree(info->fpu);
 #endif
+ prstatus_free:
+	kfree(info->prstatus);
+ psinfo_free:
+	kfree(info->psinfo);
+ notes_free:
+	kfree(info->notes);
+	return 0;
+}
+
+static int fill_note_info(struct elfhdr *elf, int phdrs,
+			  struct elf_note_info *info,
+			  long signr, struct pt_regs *regs)
+{
+	struct list_head *t;
+
+	if (!elf_note_info_init(info))
+		return 0;
 
-	info->thread_status_size = 0;
 	if (signr) {
 		struct core_thread *ct;
 		struct elf_thread_status *ets;
@@ -1809,8 +1821,6 @@ static int fill_note_info(struct elfhdr 
 #endif
 
 	return 1;
