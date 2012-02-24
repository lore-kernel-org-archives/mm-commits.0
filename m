From: akpm@linux-foundation.org
Subject: + epoll-remove-unneeded-variable-in-reverse_path_check.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:41:35 -0800
Message-ID: <20120224204135.9DDD3A0128@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:51875 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2BXUlg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:41:36 -0500
Received: by yenm1 with SMTP id m1so327115yen.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:41:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.carpenter@oracle.com, jbaron@redhat.com


The patch titled
     Subject: epoll: remove unneeded variable in reverse_path_check()
has been added to the -mm tree.  Its filename is
     epoll-remove-unneeded-variable-in-reverse_path_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1042,13 +1042,11 @@ static int reverse_path_check_proc(void 
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
Subject: Subject: epoll: remove unneeded variable in reverse_path_check()

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
pps-class_create-returns-an-err_ptr-not-null.patch
c2port-class_create-returns-an-err_ptr.patch
slab-introduce-kmalloc_array.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
drivers-leds-leds-tca6507c-cleanup-error-handling-in-tca6507_probe.patch
epoll-remove-unneeded-variable-in-reverse_path_check.patch

