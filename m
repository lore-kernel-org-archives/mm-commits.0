From: akpm@linux-foundation.org
Subject: [alternative-merged] include-linux-fsh-needs-typesh.patch removed from -mm tree
Date: Fri, 12 Nov 2010 08:43:33 -0800
Message-ID: <201011121646.oACGkBcp019694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932131Ab0KLQrB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Nov 2010 11:47:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     include/linux/fs.h needs types.h
has been removed from the -mm tree.  Its filename was
     include-linux-fsh-needs-typesh.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/fs.h needs types.h
From: David Howells <dhowells@redhat.com>

linux/fs.h needs to #include linux/types.h otherwise the following errors
can be encountered:

In file included from fs/char_dev.c:8:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'
In file included from include/linux/tty.h:9,
                 from drivers/char/tty_mutex.c:4:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'
In file included from mm/shmem.c:23:
include/linux/fs.h:36: error: expected specifier-qualifier-list before 'uint64_t'
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/fs.h~include-linux-fsh-needs-typesh include/linux/fs.h
--- a/include/linux/fs.h~include-linux-fsh-needs-typesh
+++ a/include/linux/fs.h
@@ -6,6 +6,7 @@
  * structures etc.
  */
 
+#include <linux/types.h>
 #include <linux/limits.h>
 #include <linux/ioctl.h>
 #include <linux/blk_types.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

