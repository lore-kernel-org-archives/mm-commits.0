From: akpm@linux-foundation.org
Subject: + autofs-remove-possibly-misleading-define-debug.patch added to
 -mm tree
Date: Wed, 31 Aug 2016 14:14:52 -0700
Message-ID: <57c748cc.kzmBxOhNvAggUyNv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51352 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbcHaVOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2016 17:14:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove possibly misleading /* #define DEBUG */
has been added to the -mm tree.  Its filename is
     autofs-remove-possibly-misleading-define-debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-possibly-misleading-define-debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-possibly-misleading-define-debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: remove possibly misleading /* #define DEBUG */

Having this in autofs_i.h gives illusion that uncommenting this enables
pr_debug(), but it doesn't enable all the pr_debug() in autofs because
inclusion order matters.

XFS has the same DEBUG macro in its core header fs/xfs/xfs.h, however XFS
seems to have a rule to include this prior to other XFS headers as well as
kernel headers.  This is not the case with autofs, and DEBUG could be
enabled via Makefile, so autofs should just get rid of this comment to
make the code less confusing.  It's a comment, so there is literally no
functional difference.

Link: http://lkml.kernel.org/r/20160831033409.9910.77067.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs-remove-possibly-misleading-define-debug fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs-remove-possibly-misleading-define-debug
+++ a/fs/autofs4/autofs_i.h
@@ -34,8 +34,6 @@
 #include <asm/current.h>
 #include <linux/uaccess.h>
 
-/* #define DEBUG */
