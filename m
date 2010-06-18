From: akpm@linux-foundation.org
Subject: + gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:27 -0700
Message-ID: <201006182331.o5INVRNq029534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60577 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab0FRXbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com


The patch titled
     gcc-4.6: printk: use stable variable to dump kmsg buffer
has been added to the -mm tree.  Its filename is
     gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch

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
Subject: gcc-4.6: printk: use stable variable to dump kmsg buffer
From: Andi Kleen <andi@firstfloor.org>

kmsg_dump takes care to sample the global variables
inside a spinlock, but then goes on to use the same
variables outside the spinlock region too.

Use the correct variable. This will make the race
window smaller.

Found by gcc 4.6's new warnings.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN kernel/printk.c~gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer kernel/printk.c
--- a/kernel/printk.c~gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer
+++ a/kernel/printk.c
@@ -1546,9 +1546,9 @@ void kmsg_dump(enum kmsg_dump_reason rea
 	chars = logged_chars;
 	spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (logged_chars > end) {
-		s1 = log_buf + log_buf_len - logged_chars + end;
-		l1 = logged_chars - end;
+	if (chars > end) {
+		s1 = log_buf + log_buf_len - chars + end;
+		l1 = chars - end;
 
 		s2 = log_buf;
 		l2 = end;
@@ -1556,8 +1556,8 @@ void kmsg_dump(enum kmsg_dump_reason rea
 		s1 = "";
 		l1 = 0;
 
-		s2 = log_buf + end - logged_chars;
-		l2 = logged_chars;
+		s2 = log_buf + end - chars;
+		l2 = chars;
 	}
 
 	if (!spin_trylock_irqsave(&dump_list_lock, flags)) {
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

