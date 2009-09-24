From: akpm@linux-foundation.org
Subject: [merged] gru-use-proc_create.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:10 -0700
Message-ID: <200909241937.n8OJbAVG004049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbZIXTh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: use proc_create()
has been removed from the -mm tree.  Its filename was
     gru-use-proc_create.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

