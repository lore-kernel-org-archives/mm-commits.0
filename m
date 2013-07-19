From: akpm@linux-foundation.org
Subject: + block-replace-strict_strtoul-with-kstrtoul.patch added to -mm
 tree
Date: Fri, 19 Jul 2013 14:58:50 -0700
Message-ID: <51e9b69a.jwcl3ng7IxWAH1ut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3GSV6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 17:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + block-replace-strict_strtoul-with-kstrtoul.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 14:58:50 -0700


The patch titled
     Subject: block: replace strict_strtoul() with kstrtoul()
has been added to the -mm tree.  Its filename is
     block-replace-strict_strtoul-with-kstrtoul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-replace-strict_strtoul-with-kstrtoul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-replace-strict_strtoul-with-kstrtoul.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: block: replace strict_strtoul() with kstrtoul()

The use of strict_strtoul() is not preferred, because strict_strtoul() is
obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/osdblk.c             |    2 +-
 drivers/block/rbd.c                |    2 +-
 drivers/block/xen-blkback/xenbus.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/osdblk.c~block-replace-strict_strtoul-with-kstrtoul drivers/block/osdblk.c
--- a/drivers/block/osdblk.c~block-replace-strict_strtoul-with-kstrtoul
+++ a/drivers/block/osdblk.c
@@ -598,7 +598,7 @@ static ssize_t class_osdblk_remove(struc
 	unsigned long ul;
 	struct list_head *tmp;
 
-	rc = strict_strtoul(buf, 10, &ul);
+	rc = kstrtoul(buf, 10, &ul);
 	if (rc)
 		return rc;
 
diff -puN drivers/block/rbd.c~block-replace-strict_strtoul-with-kstrtoul drivers/block/rbd.c
--- a/drivers/block/rbd.c~block-replace-strict_strtoul-with-kstrtoul
+++ a/drivers/block/rbd.c
@@ -5126,7 +5126,7 @@ static ssize_t rbd_remove(struct bus_typ
 	bool already = false;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &ul);
+	ret = kstrtoul(buf, 10, &ul);
 	if (ret)
 		return ret;
 
diff -puN drivers/block/xen-blkback/xenbus.c~block-replace-strict_strtoul-with-kstrtoul drivers/block/xen-blkback/xenbus.c
--- a/drivers/block/xen-blkback/xenbus.c~block-replace-strict_strtoul-with-kstrtoul
+++ a/drivers/block/xen-blkback/xenbus.c
@@ -545,7 +545,7 @@ static void backend_changed(struct xenbu
 	}
 
 	/* Front end dir is a number, which is used as the handle. */
-	err = strict_strtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
+	err = kstrtoul(strrchr(dev->otherend, '/') + 1, 0, &handle);
 	if (err)
 		return;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
linux-next.patch

