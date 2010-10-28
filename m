From: akpm@linux-foundation.org
Subject: + include-linux-fsh-needs-typesh.patch added to -mm tree
Date: Thu, 28 Oct 2010 12:52:26 -0700
Message-ID: <201010281952.o9SJqQoZ017764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755091Ab0J1TxL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Oct 2010 15:53:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, tytso@mit.edu


The patch titled
     include/linux/fs.h needs types.h
has been added to the -mm tree.  Its filename is
     include-linux-fsh-needs-typesh.patch

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

origin.patch
include-linux-fsh-needs-typesh.patch
linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

