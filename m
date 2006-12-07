From: akpm@osdl.org
Subject: - elf-fix-kcore-note-size-calculation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:14 -0800
Message-ID: <200612072305.kB7N5EBf030132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52451 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163900AbWLGXFg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:05:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, drow@false.org, jakub@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     elf: fix kcore note size calculation
has been removed from the -mm tree.  Its filename was
     elf-fix-kcore-note-size-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: elf: fix kcore note size calculation
From: Magnus Damm <magnus@valinux.co.jp>

- Define "CORE" string as CORE_STR in single common place.
- Include terminating zero in CORE_STR length calculation for elf_buflen.
- Use roundup(,4) to include alignment in elf_buflen calculation.

[akpm@osdl.org: simplification suggested by Roland]
Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Cc: Daniel Jacobowitz <drow@false.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/kcore.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN fs/proc/kcore.c~elf-fix-kcore-note-size-calculation fs/proc/kcore.c
--- a/fs/proc/kcore.c~elf-fix-kcore-note-size-calculation
+++ a/fs/proc/kcore.c
@@ -22,6 +22,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define CORE_STR "CORE"
 
 static int open_kcore(struct inode * inode, struct file * filp)
 {
@@ -82,10 +83,11 @@ static size_t get_kcore_size(int *nphdr,
 	}
 	*elf_buflen =	sizeof(struct elfhdr) + 
 			(*nphdr + 2)*sizeof(struct elf_phdr) + 
-			3 * (sizeof(struct elf_note) + 4) +
-			sizeof(struct elf_prstatus) +
-			sizeof(struct elf_prpsinfo) +
-			sizeof(struct task_struct);
+			3 * ((sizeof(struct elf_note)) +
+			     roundup(sizeof(CORE_STR), 4)) +
+			roundup(sizeof(struct elf_prstatus), 4) +
+			roundup(sizeof(struct elf_prpsinfo), 4) +
+			roundup(sizeof(struct task_struct), 4);
 	*elf_buflen = PAGE_ALIGN(*elf_buflen);
 	return size + *elf_buflen;
 }
@@ -210,7 +212,7 @@ static void elf_kcore_store_hdr(char *bu
 	nhdr->p_offset	= offset;
 
 	/* set up the process status */
-	notes[0].name = "CORE";
+	notes[0].name = CORE_STR;
 	notes[0].type = NT_PRSTATUS;
 	notes[0].datasz = sizeof(struct elf_prstatus);
 	notes[0].data = &prstatus;
@@ -221,7 +223,7 @@ static void elf_kcore_store_hdr(char *bu
 	bufp = storenote(&notes[0], bufp);
 
 	/* set up the process info */
-	notes[1].name	= "CORE";
+	notes[1].name	= CORE_STR;
 	notes[1].type	= NT_PRPSINFO;
 	notes[1].datasz	= sizeof(struct elf_prpsinfo);
 	notes[1].data	= &prpsinfo;
@@ -238,7 +240,7 @@ static void elf_kcore_store_hdr(char *bu
 	bufp = storenote(&notes[1], bufp);
 
 	/* set up the task structure */
-	notes[2].name	= "CORE";
+	notes[2].name	= CORE_STR;
 	notes[2].type	= NT_TASKSTRUCT;
 	notes[2].datasz	= sizeof(struct task_struct);
 	notes[2].data	= current;
_

Patches currently in -mm which might be from magnus@valinux.co.jp are

origin.patch

