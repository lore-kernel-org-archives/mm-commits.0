From: akpm@linux-foundation.org
Subject: + proc-make-proc_subdir_lock-static.patch added to -mm tree
Date: Tue, 08 Jul 2014 15:55:08 -0700
Message-ID: <53bc76cc.jXH5+WvdvFGUD3kh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:35885 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaGHWzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 18:55:09 -0400
Received: by mail-oa0-f74.google.com with SMTP id i7so1414106oag.3
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 15:55:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make proc_subdir_lock static
has been added to the -mm tree.  Its filename is
     proc-make-proc_subdir_lock-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-make-proc_subdir_lock-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-make-proc_subdir_lock-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: proc: make proc_subdir_lock static

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c  |    2 +-
 fs/proc/internal.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/proc/generic.c~proc-make-proc_subdir_lock-static fs/proc/generic.c
--- a/fs/proc/generic.c~proc-make-proc_subdir_lock-static
+++ a/fs/proc/generic.c
@@ -27,7 +27,7 @@
 
 #include "internal.h"
 
-DEFINE_SPINLOCK(proc_subdir_lock);
+static DEFINE_SPINLOCK(proc_subdir_lock);
 
 static int proc_match(unsigned int len, const char *name, struct proc_dir_entry *de)
 {
diff -puN fs/proc/internal.h~proc-make-proc_subdir_lock-static fs/proc/internal.h
--- a/fs/proc/internal.h~proc-make-proc_subdir_lock-static
+++ a/fs/proc/internal.h
@@ -178,8 +178,6 @@ extern bool proc_fill_cache(struct file
 /*
  * generic.c
  */
-extern spinlock_t proc_subdir_lock;
