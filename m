From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fs-binfmts-better-handling-of-binfmt-loops-fix.patch removed from -mm tree
Date: Mon, 05 Aug 2013 13:33:40 -0700
Message-ID: <52000c24.cWIFbrAYJJw54BSW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3HEUdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 16:33:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zml@linux.vnet.ibm.com, dan.carpenter@oracle.com

Subject: [to-be-updated] fs-binfmts-better-handling-of-binfmt-loops-fix.patch removed from -mm tree
To: dan.carpenter@oracle.com,zml@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 13:33:40 -0700


The patch titled
     Subject: fs/binfmts: double unlock in search_binary_handler()
has been removed from the -mm tree.  Its filename was
     fs-binfmts-better-handling-of-binfmt-loops-fix.patch

This patch was dropped because an updated version will be merged

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

ocfs2-use-list_for_each_entry-instead-of-list_for_each.patch
pktcdvd-convert-printk-to-pr_level.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

