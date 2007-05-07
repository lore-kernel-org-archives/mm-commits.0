From: akpm@linux-foundation.org
Subject: + revoke-core-code-do_revoke-error-handling.patch added to -mm tree
Date: Mon, 07 May 2007 16:00:12 -0700
Message-ID: <200705072300.l47N0CH1007640@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754475AbXEGXAW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:00:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: deweerdt@free.fr, frederik.deweerdt@gmail.com, penberg@cs.helsinki.fi


The patch titled
     do_revoke error handling
has been added to the -mm tree.  Its filename is
     revoke-core-code-do_revoke-error-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: do_revoke error handling
From: Frederik Deweerdt <deweerdt@free.fr>

On Sun, May 06, 2007 at 12:23:15AM +0300, Pekka J Enberg wrote:
> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > >
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > >
> > fs/revoke.c: In function 'do_revoke':
> > fs/revoke.c:563: warning: 'details.fset' may be used uninitialized in this function
> > fs/revoke.c:563: warning: 'details.restore_start' may be used uninitialized in this function
>
> On Sat, 5 May 2007, Frederik Deweerdt wrote:
> > It seems that we should goto 'out_free_table' if an error happens in
> > the mainloop. Otherwise 'details' is passed to restore_files() without
> > being initialized.
>
> Good catch. The patch is wrong, though. Wwe must restore the file
> descriptors in case revoke fails; otherwise we'll leave non-revoked files
> hanging. The proper fix is to move initialization before the
> do_each_thread() bit. Care to make a new patch, Frederik?
>
OK, thanks for the explanation. Here it is.
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/revoke.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/revoke.c~revoke-core-code-do_revoke-error-handling fs/revoke.c
--- a/fs/revoke.c~revoke-core-code-do_revoke-error-handling
+++ a/fs/revoke.c
@@ -597,6 +597,9 @@ static int do_revoke(struct inode *inode
 		goto retry;
 	}
 
+	details.fset = fset;
+	details.restore_start = 0;
+
 	/*
 	 * First revoke the descriptors. After we are done, no one can start
 	 * new operations on them.
@@ -625,9 +628,6 @@ static int do_revoke(struct inode *inode
 	if (err)
 		goto out_restore;
 
-	details.fset = fset;
-	details.restore_start = 0;
-
 	/*
 	 * Now, revoke the files for good.
 	 */
_

Patches currently in -mm which might be from deweerdt@free.fr are

revoke-core-code-do_revoke-error-handling.patch
reiser4-sb_sync_inodes.patch
