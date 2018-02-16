From: akpm@linux-foundation.org
Subject: + proc-randomize-struct-pde_opener.patch added to -mm tree
Date: Fri, 16 Feb 2018 15:07:30 -0800
Message-ID: <5a876432.MdlS7TPzXEtGCyxl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbeBPXHc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:07:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, keescook@chromium.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: randomize "struct pde_opener"
has been added to the -mm tree.  Its filename is
     proc-randomize-struct-pde_opener.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-randomize-struct-pde_opener.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-randomize-struct-pde_opener.patch

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
Subject: proc: randomize "struct pde_opener"

The more the merrier.

Link: http://lkml.kernel.org/r/20180214081935.GA17157@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/internal.h~proc-randomize-struct-pde_opener fs/proc/internal.h
--- a/fs/proc/internal.h~proc-randomize-struct-pde_opener
+++ a/fs/proc/internal.h
@@ -177,7 +177,7 @@ struct pde_opener {
 	struct list_head lh;
 	bool closing;
 	struct completion *c;
-};
+} __randomize_layout;
 extern const struct inode_operations proc_link_inode_operations;
 
 extern const struct inode_operations proc_pid_link_inode_operations;
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-do-less-stuff-under-pde_unload_lock.patch
proc-move-proc-sysvipc-creation-to-where-it-belongs.patch
proc-faster-open-close-of-files-without-release-hook.patch
proc-randomize-struct-pde_opener.patch
proc-move-struct-pde_opener-to-kmem-cache.patch
proc-account-struct-pde_opener.patch
seq_file-delete-small-value-optimization.patch

