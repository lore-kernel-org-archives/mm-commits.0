From: akpm@linux-foundation.org
Subject: + w1-replace-strict_strtol-with-kstrtol.patch added to -mm tree
Date: Fri, 26 Jul 2013 15:02:00 -0700
Message-ID: <51f2f1d8.ENFBiR9BC4tuTHgl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3GZWCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Jul 2013 18:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zbr@ioremap.net, jg1.han@samsung.com

Subject: + w1-replace-strict_strtol-with-kstrtol.patch added to -mm tree
To: jg1.han@samsung.com,zbr@ioremap.net
From: akpm@linux-foundation.org
Date: Fri, 26 Jul 2013 15:02:00 -0700


The patch titled
     Subject: drivers/w1/w1.c: replace strict_strtol() with kstrtol()
has been added to the -mm tree.  Its filename is
     w1-replace-strict_strtol-with-kstrtol.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-replace-strict_strtol-with-kstrtol.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-replace-strict_strtol-with-kstrtol.patch

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
Subject: drivers/w1/w1.c: replace strict_strtol() with kstrtol()

The usage of strict_strtol() is not preferred, because strict_strtol() is
obsolete.  Thus, kstrtol() should be used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/w1/w1.c~w1-replace-strict_strtol-with-kstrtol drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-replace-strict_strtol-with-kstrtol
+++ a/drivers/w1/w1.c
@@ -235,9 +235,11 @@ static ssize_t w1_master_attribute_store
 {
 	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int ret;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
-		return -EINVAL;
+	ret = kstrtol(buf, 0, &tmp);
+	if (ret)
+		return ret;
 
 	mutex_lock(&md->mutex);
 	md->search_count = tmp;
@@ -267,9 +269,11 @@ static ssize_t w1_master_attribute_store
 {
 	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int ret;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
-		return -EINVAL;
+	ret = kstrtol(buf, 0, &tmp);
+	if (ret)
+		return ret;
 
 	mutex_lock(&md->mutex);
 	md->enable_pullup = tmp;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
w1-replace-strict_strtol-with-kstrtol.patch
linux-next.patch

