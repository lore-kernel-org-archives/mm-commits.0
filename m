From: akpm@linux-foundation.org
Subject: + autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error.patch added to -mm tree
Date: Fri, 24 Jun 2016 13:46:26 -0700
Message-ID: <576d9c22.QbB4M7QGbi0HgNoW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbcFXUq1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 16:46:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@openvz.org, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: don't get stuck in a loop if vfs_write() returns an error
has been added to the -mm tree.  Its filename is
     autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: autofs: don't get stuck in a loop if vfs_write() returns an error

__vfs_write() returns a negative value in a error case.

Link: http://lkml.kernel.org/r/20160616083108.6278.65815.stgit@pluto.themaw.net
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error
+++ a/fs/autofs4/waitq.c
@@ -66,11 +66,12 @@ static int autofs4_write(struct autofs_s
 	set_fs(KERNEL_DS);
 
 	mutex_lock(&sbi->pipe_mutex);
-	wr = __vfs_write(file, data, bytes, &file->f_pos);
-	while (bytes && wr) {
+	while (bytes) {
+		wr = __vfs_write(file, data, bytes, &file->f_pos);
+		if (wr <= 0)
+			break;
 		data += wr;
 		bytes -= wr;
-		wr = __vfs_write(file, data, bytes, &file->f_pos);
 	}
 	mutex_unlock(&sbi->pipe_mutex);
 
_

Patches currently in -mm which might be from avagin@openvz.org are

autofs-dont-stuck-in-a-loop-if-vfs_write-returns-an-error.patch

