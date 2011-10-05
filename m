From: akpm@google.com
Subject: + ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch added to -mm tree
Date: Wed, 05 Oct 2011 12:30:53 -0700
Message-ID: <201110051930.p95JUshx029067@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:27074 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934271Ab1JETbM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:31:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, dledford@redhat.com


The patch titled
     Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
has been added to the -mm tree.  Its filename is
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix

ipc/mqueue.c: In function 'mqueue_get_inode':
ipc/mqueue.c:154:4: error: implicit declaration of function 'vmalloc'
ipc/mqueue.c:154:19: warning: assignment makes pointer from integer without=
 a cast
ipc/mqueue.c: In function 'mqueue_evict_inode':
ipc/mqueue.c:278:3: error: implicit declaration of function 'vfree'

Caused by commit 8a53f9442429 ("ipc/mqueue: update maximums for the
mqueue subsystem").  See Rule 1 in Documentation/SubmitChecklist.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <>
---

 ipc/mqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
+++ a/ipc/mqueue.c
@@ -16,6 +16,7 @@
 #include <linux/capability.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/vmalloc.h>
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
_
Subject: Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch
consolidate-config_debug_strict_user_copy_checks.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch
init-add-root=partuuid=uuid-partnroff=%d-support-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

