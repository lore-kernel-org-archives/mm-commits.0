From: akpm@linux-foundation.org
Subject: [merged] epoll-remove-unneeded-variable-in-reverse_path_check.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:31:08 -0700
Message-ID: <20120326193108.5C321A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:58916 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab2CZTbJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:31:09 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so293942eek.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:31:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, jbaron@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: epoll: remove unneeded variable in reverse_path_check()
has been removed from the -mm tree.  Its filename was
     epoll-remove-unneeded-variable-in-reverse_path_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: epoll: remove unneeded variable in reverse_path_check()

We never use the length variable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/eventpoll.c~epoll-remove-unneeded-variable-in-reverse_path_check fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-remove-unneeded-variable-in-reverse_path_check
+++ a/fs/eventpoll.c
@@ -1077,13 +1077,11 @@ static int reverse_path_check_proc(void 
  */
 static int reverse_path_check(void)
 {
-	int length = 0;
 	int error = 0;
 	struct file *current_file;
 
 	/* let's call this for all tfiles */
 	list_for_each_entry(current_file, &tfile_check_list, f_tfile_llink) {
-		length++;
 		path_count_init();
 		error = ep_call_nested(&poll_loop_ncalls, EP_MAX_NESTS,
 					reverse_path_check_proc, current_file,
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch

