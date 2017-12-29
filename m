From: akpm@linux-foundation.org
Subject: + uuid-cleanup-uapi-linux-uuidh.patch added to -mm tree
Date: Thu, 28 Dec 2017 17:29:41 -0800
Message-ID: <5a459a85.BR9Cu122xt9ATV/z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753498AbdL2B3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Dec 2017 20:29:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: uuid: cleanup <uapi/linux/uuid.h>
has been added to the -mm tree.  Its filename is
     uuid-cleanup-uapi-linux-uuidh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/uuid-cleanup-uapi-linux-uuidh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/uuid-cleanup-uapi-linux-uuidh.patch

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
Subject: uuid: cleanup <uapi/linux/uuid.h>

Exported header doesn't use anything from <linux/string.h>,
it is <linux/uuid.h> which uses memcmp().

Link: http://lkml.kernel.org/r/20171225171121.GA22754@avx2
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uuid.h      |    1 +
 include/uapi/linux/uuid.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh include/linux/uuid.h
--- a/include/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh
+++ a/include/linux/uuid.h
@@ -17,6 +17,7 @@
 #define _LINUX_UUID_H_
 
 #include <uapi/linux/uuid.h>
+#include <linux/string.h>
 
 #define UUID_SIZE 16
 
diff -puN include/uapi/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh include/uapi/linux/uuid.h
--- a/include/uapi/linux/uuid.h~uuid-cleanup-uapi-linux-uuidh
+++ a/include/uapi/linux/uuid.h
@@ -19,7 +19,6 @@
 #define _UAPI_LINUX_UUID_H_
 
 #include <linux/types.h>
-#include <linux/string.h>
 
 typedef struct {
 	__u8 b[16];
_

Patches currently in -mm which might be from adobriyan@gmail.com are

proc-use-%u-for-pid-printing-and-slightly-less-stack.patch
proc-dont-use-read_once-write_once-for-proc-fail-nth.patch
proc-fix-proc-map_files-lookup.patch
proc-simpler-proc-vmcore-cleanup.patch
proc-less-memory-for-proc-map_files-readdir.patch
proc-delete-children_seq_release.patch
proc-rearrange-struct-proc_dir_entry.patch
uuid-cleanup-uapi-linux-uuidh.patch
seq_file-delete-small-value-optimization.patch
cpumask-make-cpumask_size-return-unsigned-int.patch

