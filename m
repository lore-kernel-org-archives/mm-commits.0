From: akpm@linux-foundation.org
Subject: + fs-documents-seq_opens-usage-of-file-private_data.patch added
 to -mm tree
Date: Tue, 02 Jun 2015 14:42:52 -0700
Message-ID: <556e235c.XMWhGKTKXrUDIISt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbFBVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 17:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ydroneaud@opteya.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: document seq_open()'s usage of file->private_data
has been added to the -mm tree.  Its filename is
     fs-documents-seq_opens-usage-of-file-private_data.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-documents-seq_opens-usage-of-file-private_data.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-documents-seq_opens-usage-of-file-private_data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-use-seq_open_private-for-proc_mounts.patch
fs-allocate-structure-unconditionally-in-seq_open.patch
fs-documents-seq_opens-usage-of-file-private_data.patch
linux-next.patch

