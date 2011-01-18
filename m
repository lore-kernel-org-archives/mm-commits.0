From: akpm@linux-foundation.org
Subject: [merged] vfs-remove-unlikely-from-fput_light.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:30:17 -0800
Message-ID: <201101182030.p0IKUHgu003547@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1ARUqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srostedt@redhat.com, hch@lst.de, rostedt@goodmis.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove unlikely() from fput_light()
has been removed from the -mm tree.  Its filename was
     vfs-remove-unlikely-from-fput_light.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove unlikely() from fput_light()
From: Steven Rostedt <srostedt@redhat.com>

In fput_light(), there's an unlikely(fput_needed), which running on my
normal desktop doing firefox, xchat, evolution and part of my distcc farm,
and running the annotate branch profiler shows that the unlikely is not
very unlikely.

 correct incorrect  %        Function             File              Line
 ------- ---------  -        --------             ----              ----
       0       48 100 fput_light                file.h               26
115828710 897415279  88 fput_light              file.h               26
865271179 5286128445  85 fput_light             file.h               26
19568539  8923664  31 fput_light                file.h               26
12353677  3562279  22 fput_light                file.h               26
  267691    67062  20 fput_light                file.h               26
15014853   348172   2 fput_light                file.h               26
  209258      205   0 fput_light                file.h               26
 1364164        0   0 fput_light                file.h               26

Which gives 1032903812 times it was correct and 6203351846 times it was
incorrect, or 85% incorrect.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/file.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/file.h~vfs-remove-unlikely-from-fput_light include/linux/file.h
--- a/include/linux/file.h~vfs-remove-unlikely-from-fput_light
+++ a/include/linux/file.h
@@ -23,7 +23,7 @@ extern struct file *alloc_file(struct pa
 
 static inline void fput_light(struct file *file, int fput_needed)
 {
-	if (unlikely(fput_needed))
+	if (fput_needed)
 		fput(file);
 }
 
_

Patches currently in -mm which might be from srostedt@redhat.com are

origin.patch

