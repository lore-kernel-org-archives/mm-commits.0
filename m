From: akpm@linux-foundation.org
Subject: [to-be-updated] init-do_mountsc-treat-erofs-like-eacces.patch
 removed from -mm tree
Date: Thu, 19 Jun 2014 16:21:32 -0700
Message-ID: <53a3707c.6Fkj4QLHmiy/40ry%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965532AbaFSXVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 19:21:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, david@fromorbit.com, phdm@macqel.be


The patch titled
     Subject: init/do_mounts.c: treat EROFS like EACCES
has been removed from the -mm tree.  Its filename was
     init-do_mountsc-treat-erofs-like-eacces.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: init/do_mounts.c: treat EROFS like EACCES

Some combinations of filesystem and block device (at least vfat on mmc)
yield -EROFS instead of -EACCES when the device is read-only.  Retry
mounting with MS_RDONLY set, just like for the EACCES case, instead of
failing directly.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN init/do_mounts.c~init-do_mountsc-treat-erofs-like-eacces init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-treat-erofs-like-eacces
+++ a/init/do_mounts.c
@@ -394,6 +394,7 @@ retry:
 			case 0:
 				goto out;
 			case -EACCES:
+			case -EROFS:
 				flags |= MS_RDONLY;
 				goto retry;
 			case -EINVAL:
_

Patches currently in -mm which might be from phdm@macqel.be are


