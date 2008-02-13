From: akpm@linux-foundation.org
Subject: - uml-fix-hostfs-build.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:06 -0800
Message-ID: <200802132015.m1DKF6Wf011275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761031AbYBMUPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:15:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, bunk@stusta.de, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     UML: fix hostfs build
has been removed from the -mm tree.  Its filename was
     uml-fix-hostfs-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

pcmcia-ipwireless-depends-on-netdevices.patch
git-hid.patch
elantech-touchpad-driver.patch
