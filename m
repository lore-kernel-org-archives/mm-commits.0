From: akpm@linux-foundation.org
Subject: + init-do_mountsc-treat-erofs-like-eacces.patch added to -mm tree
Date: Thu, 19 Jun 2014 14:20:12 -0700
Message-ID: <53a3540c.zCVGOVPDCLX7kI05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215AbaFSVUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jun 2014 17:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, phdm@macqel.be


The patch titled
     Subject: init/do_mounts.c: treat EROFS like EACCES
has been added to the -mm tree.  Its filename is
     init-do_mountsc-treat-erofs-like-eacces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mountsc-treat-erofs-like-eacces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mountsc-treat-erofs-like-eacces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philippe De Muyter <phdm@macqel.be>
Subject: init/do_mounts.c: treat EROFS like EACCES

Some combinations of filesystem and block device (at least vfat on mmc)
yield -EROFS instead of -EACCES when the device is read-only.  Retry
mounting with MS_RDONLY set, just like for the EACCES case, instead of
failing directly.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
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

init-do_mountsc-treat-erofs-like-eacces.patch

