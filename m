From: akpm@linux-foundation.org
Subject: - statistics-replace-inode-ugeneric_ip-with-i_private.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:09:06 -0800
Message-ID: <200703060209.l262978V008943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46965 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965745AbXCFCJi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, mp3@de.ibm.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     statistics: replace inode u.generic_ip with i_private
has been removed from the -mm tree.  Its filename was
     statistics-replace-inode-ugeneric_ip-with-i_private.patch

This patch was dropped because it was folded into statistics-infrastructure.patch

------------------------------------------------------
Subject: statistics: replace inode u.generic_ip with i_private
From: Cedric Le Goater <clg@fr.ibm.com>

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Martin Peschke <mp3@de.ibm.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 lib/statistic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/statistic.c~statistics-replace-inode-ugeneric_ip-with-i_private lib/statistic.c
--- a/lib/statistic.c~statistics-replace-inode-ugeneric_ip-with-i_private
+++ a/lib/statistic.c
@@ -625,7 +625,7 @@ static int statistic_generic_open(struct
 		struct file *file, struct statistic_interface **interface,
 		struct statistic_file_private **private)
 {
-	*interface = inode->u.generic_ip;
+	*interface = inode->i_private;
 	BUG_ON(!interface);
 	*private = kzalloc(sizeof(struct statistic_file_private), GFP_KERNEL);
 	if (unlikely(!*private))
@@ -708,7 +708,7 @@ static ssize_t statistic_generic_write(s
 
 static int statistic_def_close(struct inode *inode, struct file *file)
 {
-	struct statistic_interface *interface = inode->u.generic_ip;
+	struct statistic_interface *interface = inode->i_private;
 	struct statistic_file_private *private = file->private_data;
 	struct sgrb_seg *seg, *seg_nl;
 	int offset;
_

Patches currently in -mm which might be from clg@fr.ibm.com are

merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
statistics-infrastructure.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
