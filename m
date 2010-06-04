From: akpm@linux-foundation.org
Subject: + nommu-add-label-to-proc-pid-maps-output.patch added to -mm tree
Date: Fri, 04 Jun 2010 13:49:07 -0700
Message-ID: <201006042049.o54Kn7bZ016784@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757040Ab0FDVav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 17:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, dhowells@redhat.com, gerg@snapgear.com


The patch titled
     nommu: add '[stack]' label to /proc/pid/maps output
has been added to the -mm tree.  Its filename is
     nommu-add-label-to-proc-pid-maps-output.patch

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
Subject: nommu: add '[stack]' label to /proc/pid/maps output
From: Mike Frysinger <vapier@gentoo.org>

Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
of the original thread after execve.  This is largely based on the MMU code.
Subsidiary thread stacks are not indicated.

For FDPIC, we now get:

	root:/> cat /proc/self/maps
	02064000-02067ccc rw-p 0004d000 00:01 22         /bin/busybox
	0206e000-0206f35c rw-p 00006000 00:01 295        /lib/ld-uClibc.so.0
	025f0000-025f6f0c r-xs 00000000 00:01 295        /lib/ld-uClibc.so.0
	02680000-026ba6b0 r-xs 00000000 00:01 297        /lib/libc.so.0
	02700000-0274d384 r-xs 00000000 00:01 22         /bin/busybox
	02816000-02817000 rw-p 00000000 00:00 0
	02848000-0284c0d8 rw-p 00000000 00:00 0
	02860000-02880000 rw-p 00000000 00:00 0          [stack]

The semi-downside here is that for FLAT, we get:

	root:/> cat /proc/155/maps
	029f0000-029f9000 rwxp 00000000 00:00 0          [stack]

The reason being that FLAT combines a whole lot of stuff into one map
(including the stack).  But this isn't any worse than the current output
(which is nothing), so screw it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg Ungerer <gerg@snapgear.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN fs/proc/task_nommu.c~nommu-add-label-to-proc-pid-maps-output fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~nommu-add-label-to-proc-pid-maps-output
+++ a/fs/proc/task_nommu.c
@@ -122,11 +122,20 @@ int task_statm(struct mm_struct *mm, int
 	return size;
 }
 
+static void pad_len_spaces(struct seq_file *m, int len)
+{
+	len = 25 + sizeof(void*) * 6 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c", len, ' ');
+}
+
 /*
  * display a single VMA to a sequenced file
  */
 static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	unsigned long ino = 0;
 	struct file *file;
 	dev_t dev = 0;
@@ -155,11 +164,14 @@ static int nommu_vma_show(struct seq_fil
 		   MAJOR(dev), MINOR(dev), ino, &len);
 
 	if (file) {
-		len = 25 + sizeof(void *) * 6 - len;
-		if (len < 1)
-			len = 1;
-		seq_printf(m, "%*c", len, ' ');
+		pad_len_spaces(m, len);
 		seq_path(m, &file->f_path, "");
+	} else if (mm) {
+		if (vma->vm_start <= mm->start_stack &&
+			vma->vm_end >= mm->start_stack) {
+			pad_len_spaces(m, len);
+			seq_puts(m, "[stack]");
+		}
 	}
 
 	seq_putc(m, '\n');
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
flat-split-the-stack-data-alignments.patch
flat-fix-unmap-len-in-load-error-path.patch
linux-next.patch
nommu-add-label-to-proc-pid-maps-output.patch
asm-generic-ioh-add-big-endian-versions-of-ioreadwrite1632.patch

