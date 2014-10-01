From: akpm@linux-foundation.org
Subject: + fat-remove-redundant-sys_tz-declaration.patch added to -mm tree
Date: Wed, 01 Oct 2014 14:42:00 -0700
Message-ID: <542c7528.BjL29LRx/QKY1j8A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJAVmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 17:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: remove redundant sys_tz declaration
has been added to the -mm tree.  Its filename is
     fat-remove-redundant-sys_tz-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-remove-redundant-sys_tz-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-remove-redundant-sys_tz-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fat: remove redundant sys_tz declaration

sys_tz is already declared extern struct in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/misc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/fat/misc.c~fat-remove-redundant-sys_tz-declaration fs/fat/misc.c
--- a/fs/fat/misc.c~fat-remove-redundant-sys_tz-declaration
+++ a/fs/fat/misc.c
@@ -164,8 +164,6 @@ int fat_chain_add(struct inode *inode, i
 	return 0;
 }
 
-extern struct timezone sys_tz;
