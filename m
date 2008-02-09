From: akpm@linux-foundation.org
Subject: + uml-fix-hostfs-build.patch added to -mm tree
Date: Fri, 08 Feb 2008 17:44:07 -0800
Message-ID: <200802090144.m191hmUP024655@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756486AbYBIBwi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 20:52:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, bunk@stusta.de, jdike@addtoit.com


The patch titled
     UML: fix hostfs build
has been added to the -mm tree.  Its filename is
     uml-fix-hostfs-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: UML: fix hostfs build
From: Jiri Kosina <jkosina@suse.cz>

/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function 'hostfs_show_options':
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type

We need to include mount.h to get vfsmount.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Reported-by: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs_kern.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hostfs/hostfs_kern.c~uml-fix-hostfs-build fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-fix-hostfs-build
+++ a/fs/hostfs/hostfs_kern.c
@@ -12,6 +12,7 @@
 #include <linux/pagemap.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
+#include <linux/mount.h>
 #include "hostfs.h"
 #include "init.h"
 #include "kern.h"
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
uml-fix-hostfs-build.patch
git-hid.patch
elantech-touchpad-driver.patch
git-x86.patch
