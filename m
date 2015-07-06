From: akpm@linux-foundation.org
Subject: [merged] fs-documents-seq_opens-usage-of-file-private_data.patch
 removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:39 -0700
Message-ID: <559adb1f.Dj8g+yvKEAv5FfFl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbbGFTqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: document seq_open()'s usage of file->private_data
has been removed from the -mm tree.  Its filename was
     fs-documents-seq_opens-usage-of-file-private_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yann Droneaud <ydroneaud@opteya.com>
Subject: fs: document seq_open()'s usage of file->private_data

seq_open() stores its struct seq_file in file->private_data, thus it must
not be modified by user of seq_file.

Link: http://lkml.kernel.org/r/cover.1433193673.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/seq_file.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/seq_file.c~fs-documents-seq_opens-usage-of-file-private_data fs/seq_file.c
--- a/fs/seq_file.c~fs-documents-seq_opens-usage-of-file-private_data
+++ a/fs/seq_file.c
@@ -48,6 +48,8 @@ static void *seq_buf_alloc(unsigned long
  *	ERR_PTR(error).  In the end of sequence they return %NULL. ->show()
  *	returns 0 in case of success and negative number in case of error.
  *	Returning SEQ_SKIP means "discard this element and move on".
+ *	Note: seq_open() will allocate a struct seq_file and store its
+ *	pointer in @file->private_data. This pointer should not be modified.
  */
 int seq_open(struct file *file, const struct seq_operations *op)
 {
_

Patches currently in -mm which might be from ydroneaud@opteya.com are


