From: akpm@linux-foundation.org
Subject: [merged] vfs-remove-unlikely-from-fget_light.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:20 -0800
Message-ID: <201101182030.p0IKUKuw003550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1ARUpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srostedt@redhat.com, hch@lst.de, rostedt@goodmis.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove unlikely() from fget_light()
has been removed from the -mm tree.  Its filename was
     vfs-remove-unlikely-from-fget_light.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove unlikely() from fget_light()
From: Steven Rostedt <srostedt@redhat.com>

There's an unlikely() in fget_light() that assumes the file ref count will
be 1.  Running the annotate branch profiler on a desktop that is
performing daily tasks (running firefox, evolution, xchat and is also part
of a distcc farm), it shows that the ref count is not 1 that often.

 correct incorrect      %    Function                  File              Line
 ------- ---------      -    --------                  ----              ----
1035099358 6209599193  85    fget_light              file_table.c         315

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/file_table.c~vfs-remove-unlikely-from-fget_light fs/file_table.c
--- a/fs/file_table.c~vfs-remove-unlikely-from-fget_light
+++ a/fs/file_table.c
@@ -311,7 +311,7 @@ struct file *fget_light(unsigned int fd,
 	struct files_struct *files = current->files;
 
 	*fput_needed = 0;
-	if (likely((atomic_read(&files->count) == 1))) {
+	if (atomic_read(&files->count) == 1) {
 		file = fcheck_files(files, fd);
 	} else {
 		rcu_read_lock();
_

Patches currently in -mm which might be from srostedt@redhat.com are

origin.patch

