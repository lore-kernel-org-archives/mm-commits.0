From: akpm@linux-foundation.org
Subject: + romfs-have-romfs_fsh-pull-in-necessary-headers.patch added to -mm tree
Date: Mon, 22 Nov 2010 13:59:12 -0800
Message-ID: <201011222159.oAMLxCIX011564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757660Ab0KVV7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 16:59:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     romfs: have romfs_fs.h pull in necessary headers
has been added to the -mm tree.  Its filename is
     romfs-have-romfs_fsh-pull-in-necessary-headers.patch

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
Subject: romfs: have romfs_fs.h pull in necessary headers
From: Mike Frysinger <vapier@gentoo.org>

This header uses things like __be32, so pull in linux/types.h.

Further, it uses BLOCK_SIZE, so pull in linux/fs.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/romfs_fs.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/romfs_fs.h~romfs-have-romfs_fsh-pull-in-necessary-headers include/linux/romfs_fs.h
--- a/include/linux/romfs_fs.h~romfs-have-romfs_fsh-pull-in-necessary-headers
+++ a/include/linux/romfs_fs.h
@@ -1,6 +1,9 @@
 #ifndef __LINUX_ROMFS_FS_H
 #define __LINUX_ROMFS_FS_H
 
+#include <linux/types.h>
+#include <linux/fs.h>
+
 /* The basic structures of the romfs filesystem */
 
 #define ROMBSIZE BLOCK_SIZE
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
romfs-have-romfs_fsh-pull-in-necessary-headers.patch

