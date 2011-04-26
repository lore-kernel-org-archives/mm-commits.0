From: akpm@linux-foundation.org
Subject: [nacked] proc-put-check_mem_permission-before-__get_free_page-in-mem_read.patch removed from -mm tree
Date: Tue, 26 Apr 2011 12:26:14 -0700
Message-ID: <201104261926.p3QJQFPJ013564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab1DZT0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Apr 2011 15:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bookjovi@gmail.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     proc: put check_mem_permission before __get_free_page in mem_read
has been removed from the -mm tree.  Its filename was
     proc-put-check_mem_permission-before-__get_free_page-in-mem_read.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: put check_mem_permission before __get_free_page in mem_read
From: Jovi Zhang <bookjovi@gmail.com>

It would be better to put check_mem_permission() before __get_free_page()
in mem_read(), to be same as mem_write().

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Stephen Wilson <wilsons@start.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN fs/proc/base.c~proc-put-check_mem_permission-before-__get_free_page-in-mem_read fs/proc/base.c
--- a/fs/proc/base.c~proc-put-check_mem_permission-before-__get_free_page-in-mem_read
+++ a/fs/proc/base.c
@@ -831,23 +831,21 @@ static ssize_t mem_read(struct file * fi
 	if (!task)
 		goto out_no_task;
 
-	ret = -ENOMEM;
-	page = (char *)__get_free_page(GFP_TEMPORARY);
-	if (!page)
-		goto out;
-
 	mm = check_mem_permission(task);
 	ret = PTR_ERR(mm);
 	if (IS_ERR(mm))
-		goto out_free;
+		goto out_task;
 
 	ret = -EIO;
- 
 	if (file->private_data != (void*)((long)current->self_exec_id))
-		goto out_put;
+		goto out_mm;
+
+	ret = -ENOMEM;
+	page = (char *)__get_free_page(GFP_TEMPORARY);
+	if (!page)
+		goto out_mm;
 
 	ret = 0;
- 
 	while (count > 0) {
 		int this_len, retval;
 
@@ -870,12 +868,10 @@ static ssize_t mem_read(struct file * fi
 		count -= retval;
 	}
 	*ppos = src;
