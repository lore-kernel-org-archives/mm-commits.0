From: akpm@linux-foundation.org
Subject: + init-return-proper-error-code-in-do_mounts_rd.patch added to -mm tree
Date: Thu, 20 Jan 2011 15:24:51 -0800
Message-ID: <201101202324.p0KNOpc7008781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754950Ab1ATXYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 18:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@gnu.org


The patch titled
     init: return proper error code in do_mounts_rd()
has been added to the -mm tree.  Its filename is
     init-return-proper-error-code-in-do_mounts_rd.patch

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
Subject: init: return proper error code in do_mounts_rd()
From: Davidlohr Bueso <dave@gnu.org>

In do_mounts_rd() if memory cannot be allocated, return -ENOMEM.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/do_mounts_rd.c~init-return-proper-error-code-in-do_mounts_rd init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-return-proper-error-code-in-do_mounts_rd
+++ a/init/do_mounts_rd.c
@@ -64,7 +64,7 @@ identify_ramdisk_image(int fd, int start
 
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
-		return -1;
+		return -ENOMEM;
 
 	minixsb = (struct minix_super_block *) buf;
 	ext2sb = (struct ext2_super_block *) buf;
_

Patches currently in -mm which might be from dave@gnu.org are

linux-next.patch
init-return-proper-error-code-in-do_mounts_rd.patch

