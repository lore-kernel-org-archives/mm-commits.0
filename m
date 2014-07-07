From: akpm@linux-foundation.org
Subject: [merged] proc-stat-convert-to-single_open_size.patch removed from -mm tree
Date: Mon, 07 Jul 2014 11:11:30 -0700
Message-ID: <53bae2d2.y2kXHj4Pm79GowVu%akpm__40724.3586764254$1404756710$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:42095 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaGGSLb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 14:11:31 -0400
Received: by mail-ve0-f202.google.com with SMTP id oy12so657249veb.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 11:11:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, andrea@betterlinux.com, brueckner@linux.vnet.ibm.com, hch@infradead.org, raven@themaw.net, rientjes@google.com, stable@vger.kernel.org, stefan.bader@canonical.com, thorsten.diehl@de.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: /proc/stat: convert to single_open_size()
has been removed from the -mm tree.  Its filename was
     proc-stat-convert-to-single_open_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: /proc/stat: convert to single_open_size()

These two patches are supposed to "fix" failed order-4 memory allocations
which have been observed when reading /proc/stat.  The problem has been
observed on s390 as well as on x86.

To address the problem change the seq_file memory allocations to fallback
to use vmalloc, so that allocations also work if memory is fragmented.

This approach seems to be simpler and less intrusive than changing
/proc/stat to use an interator.  Also it "fixes" other users as well,
which use seq_file's single_open() interface.


This patch (of 2):

Use seq_file's single_open_size() to preallocate a buffer that is large
enough to hold the whole output, instead of open coding it.  Also
calculate the requested size using the number of online cpus instead of
possible cpus, since the size of the output only depends on the number of
online cpus.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Thorsten Diehl <thorsten.diehl@de.ibm.com>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stefan Bader <stefan.bader@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff -puN fs/proc/stat.c~proc-stat-convert-to-single_open_size fs/proc/stat.c
--- a/fs/proc/stat.c~proc-stat-convert-to-single_open_size
+++ a/fs/proc/stat.c
@@ -184,29 +184,11 @@ static int show_stat(struct seq_file *p,
 
 static int stat_open(struct inode *inode, struct file *file)
 {
-	size_t size = 1024 + 128 * num_possible_cpus();
-	char *buf;
-	struct seq_file *m;
-	int res;
+	size_t size = 1024 + 128 * num_online_cpus();
 
 	/* minimum size to display an interrupt count : 2 bytes */
 	size += 2 * nr_irqs;
-
-	/* don't ask for more than the kmalloc() max size */
-	if (size > KMALLOC_MAX_SIZE)
-		size = KMALLOC_MAX_SIZE;
-	buf = kmalloc(size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
