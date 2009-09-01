From: akpm@linux-foundation.org
Subject: + gru-use-proc_create.patch added to -mm tree
Date: Tue, 01 Sep 2009 16:30:31 -0700
Message-ID: <200909012330.n81NUVh2001721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbZIAXal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 19:30:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, steiner@sgi.com


The patch titled
     gru: use proc_create()
has been added to the -mm tree.  Its filename is
     gru-use-proc_create.patch

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
Subject: gru: use proc_create()
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gruprocfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/gruprocfs.c~gru-use-proc_create drivers/misc/sgi-gru/gruprocfs.c
--- a/drivers/misc/sgi-gru/gruprocfs.c~gru-use-proc_create
+++ a/drivers/misc/sgi-gru/gruprocfs.c
@@ -340,10 +340,9 @@ static struct proc_dir_entry *proc_gru _
 
 static int create_proc_file(struct proc_entry *p)
 {
-	p->entry = create_proc_entry(p->name, p->mode, proc_gru);
+	p->entry = proc_create(p->name, p->mode, proc_gru, p->fops);
 	if (!p->entry)
 		return -1;
-	p->entry->proc_fops = p->fops;
 	return 0;
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

