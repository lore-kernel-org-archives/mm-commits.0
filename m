From: akpm@linux-foundation.org
Subject: + include-linux-kdev_th-remove-new_valid_dev.patch added to -mm
 tree
Date: Tue, 17 Nov 2015 15:43:16 -0800
Message-ID: <564bbb94.nIimgPJo6T2UIh+W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48201 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbKQXnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 18:43:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baiyaowei@cmss.chinamobile.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kdev_t.h: remove new_valid_dev()
has been added to the -mm tree.  Its filename is
     include-linux-kdev_th-remove-new_valid_dev.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-kdev_th-remove-new_valid_dev.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-kdev_th-remove-new_valid_dev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Subject: include/linux/kdev_t.h: remove new_valid_dev()

As all new_valid_dev() checks have been removed it's time to drop
new_valid_dev() itself.

No functional change.

Signed-off-by: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN include/linux/kdev_t.h~include-linux-kdev_th-remove-new_valid_dev include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~include-linux-kdev_th-remove-new_valid_dev
+++ a/include/linux/kdev_t.h
@@ -35,11 +35,6 @@ static inline dev_t old_decode_dev(u16 v
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline bool new_valid_dev(dev_t dev)
-{
-	return 1;
-}
