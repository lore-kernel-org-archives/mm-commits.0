From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch removed from -mm tree
Date: Tue, 10 Jan 2012 15:55:02 -0800
Message-ID: <20120110235503.063CE1E046A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:43817 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2AJXzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2012 18:55:03 -0500
Received: by ggnk3 with SMTP id k3so22249ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2012 15:55:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dledford@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch

This patch was dropped because it was folded into ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
kdump-add-udev-events-for-memory-online-offline-fix.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

