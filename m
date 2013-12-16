From: akpm@linux-foundation.org
Subject: + afs-proc-cells-and-rootcell-are-writeable.patch added to -mm
 tree
Date: Mon, 16 Dec 2013 11:55:57 -0800
Message-ID: <52af5acd.eaZnczAfZoIPakdv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3LPT4D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dhowells@redhat.com, pali.rohar@gmail.com

Subject: + afs-proc-cells-and-rootcell-are-writeable.patch added to -mm tree
To: pali.rohar@gmail.com,dhowells@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:57 -0800


The patch titled
     Subject: afs: proc cells and rootcell are writeable
has been added to the -mm tree.  Its filename is
     afs-proc-cells-and-rootcell-are-writeable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/afs-proc-cells-and-rootcell-are-writeable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/afs-proc-cells-and-rootcell-are-writeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pali Rohár <pali.rohar@gmail.com>
Subject: afs: proc cells and rootcell are writeable

Both proc files are writeable and used for configuring cells. But
there is missing correct mode flag for writeable files. Without
this patch both proc files are read only.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/afs/proc.c~afs-proc-cells-and-rootcell-are-writeable fs/afs/proc.c
--- a/fs/afs/proc.c~afs-proc-cells-and-rootcell-are-writeable
+++ a/fs/afs/proc.c
@@ -147,11 +147,11 @@ int afs_proc_init(void)
 	if (!proc_afs)
 		goto error_dir;
 
-	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
+	p = proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_cells_fops);
 	if (!p)
 		goto error_cells;
 
-	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
+	p = proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
 
_

Patches currently in -mm which might be from pali.rohar@gmail.com are

origin.patch
afs-proc-cells-and-rootcell-are-writeable.patch
linux-next.patch

