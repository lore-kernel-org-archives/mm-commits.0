From: akpm@linux-foundation.org
Subject: + fs-binfmts-better-handling-of-binfmt-loops-fix.patch added to
 -mm tree
Date: Thu, 01 Aug 2013 16:41:14 -0700
Message-ID: <51faf21a.GnKuinhmPRTGXrTv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3HAXmK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Aug 2013 19:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, dan.carpenter@oracle.com

Subject: + fs-binfmts-better-handling-of-binfmt-loops-fix.patch added to -mm tree
To: dan.carpenter@oracle.com,zml@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Thu, 01 Aug 2013 16:41:13 -0700


The patch titled
     Subject: fs/binfmts: double unlock in search_binary_handler()
has been added to the -mm tree.  Its filename is
     fs-binfmts-better-handling-of-binfmt-loops-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-binfmts-better-handling-of-binfmt-loops-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-binfmts-better-handling-of-binfmt-loops-fix.patch

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
Subject: fs/binfmts: double unlock in search_binary_handler()

The recent -mm patch 3046d15088 "fs/binfmts: better handling of binfmt
loops" introduced a new "continue" to the loop.  The problem is that we
are supposed to be holding the lock at the start so we need to take it
again.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Zach Levis <zml@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops-fix fs/exec.c
--- a/fs/exec.c~fs-binfmts-better-handling-of-binfmt-loops-fix
+++ a/fs/exec.c
@@ -1426,6 +1426,7 @@ int search_binary_handler(struct linux_b
 				copy_strings(bprm->argc_orig, *((struct user_arg_ptr *) bprm->argv_orig), bprm);
 				bprm->argc = bprm->argc_orig;
 				retval = -ENOEXEC;
+				read_lock(&binfmt_lock);
 				continue;
 			}
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

rapidio-fix-use-after-free-in-rio_unregister_scan.patch
ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
fs-binfmts-better-handling-of-binfmt-loops-fix.patch
pktcdvd-convert-printk-to-pr_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

