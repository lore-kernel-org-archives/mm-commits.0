From: akpm@linux-foundation.org
Subject: + proc-stat-convert-to-single_open_size.patch added to -mm tree
Date: Wed, 18 Jun 2014 14:29:41 -0700
Message-ID: <53a204c5.vjJkSg06lw8bt5f+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaFRV3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 17:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, thorsten.diehl@de.ibm.com, stefan.bader@canonical.com, stable@vger.kernel.org, rientjes@google.com, raven@themaw.net, hch@infradead.org, brueckner@linux.vnet.ibm.com, andrea@betterlinux.com, heiko.carstens@de.ibm.com


The patch titled
     Subject: proc/stat: convert to single_open_size()
has been added to the -mm tree.  Its filename is
     proc-stat-convert-to-single_open_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-stat-convert-to-single_open_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-stat-convert-to-single_open_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: proc/stat: convert to single_open_size()

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
Cc: David Rientjes <rientjes@google.com>
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
