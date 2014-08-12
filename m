From: akpm@linux-foundation.org
Subject: [merged] proc-make-proc_subdir_lock-static.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:39:52 -0700
Message-ID: <53ea6d88.JoFdLrsXeNAcqO1c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:49590 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaHLTjw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:39:52 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so2668693pde.5
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:39:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: make proc_subdir_lock static
has been removed from the -mm tree.  Its filename was
     proc-make-proc_subdir_lock-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
