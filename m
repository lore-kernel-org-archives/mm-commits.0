From: akpm@linux-foundation.org
Subject: + block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
 added to -mm tree
Date: Wed, 24 Jul 2013 14:07:43 -0700
Message-ID: <51f0421f.fhGJY7QWx2HN1byB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab3GXVHn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:07:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:07:43 -0700


The patch titled
     Subject: block/blk-sysfs.c: replace strict_strtoul() with kstrtoul()
has been added to the -mm tree.  Its filename is
     block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch

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
Subject: block/blk-sysfs.c: replace strict_strtoul() with kstrtoul()

The usage of strict_strtoul() is not preferred, because strict_strtoul()
is obsolete.  Thus, kstrtoul() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-sysfs.c~block-blk-sysfs-replace-strict_strtoul-with-kstrtoul block/blk-sysfs.c
--- a/block/blk-sysfs.c~block-blk-sysfs-replace-strict_strtoul-with-kstrtoul
+++ a/block/blk-sysfs.c
@@ -29,7 +29,7 @@ queue_var_store(unsigned long *var, cons
 	int err;
 	unsigned long v;
 
-	err = strict_strtoul(page, 10, &v);
+	err = kstrtoul(page, 10, &v);
 	if (err || v > UINT_MAX)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
linux-next.patch

