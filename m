Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F4F38DF9
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385696; cv=none; b=XLT9/p2DLzGay3o2JaL3iqqES7cA0eHsqtXga56Mo5dYlxfPaGBwrRtUeBpeAbNpGhiWDtoeXzd8EsPN4KxzDvyuRo8ktORnBXvWPtE2OiZ41T6WicKkYTMSyBHuMTOBkHImRjp4QZwKmQBXM7ZFQLZtKyAPRLl3zdAI3spQqwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385696; c=relaxed/simple;
	bh=Aa38Yp6HFEdUb6qF73VFP2KUsMj7G7whZZS5xw/PzdA=;
	h=Date:To:From:Subject:Message-Id; b=lCLbUnOdX+RI4M6Y/YCdCRtdg0klsyCOSjkfTS9YA5j/q5q15HnGQ6iJcASYya/octyRByLy8y1cmDHzd9O6asgNfe/n+GNFE4wWeGmPhyl27TFbA/7Ece9egN7Ysn+fOa3ZIqSfk8il9k3GCYq5iF8ligjJ3Zq4VfS0DzHSPyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CdgyPiHl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CdgyPiHl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB3C072AA;
	Wed, 17 Apr 2024 20:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713385695;
	bh=Aa38Yp6HFEdUb6qF73VFP2KUsMj7G7whZZS5xw/PzdA=;
	h=Date:To:From:Subject:From;
	b=CdgyPiHl+bXIg3UjBKDsTP83pcLZfjYVG2rec/B+3+SDBTp6UljBHK1qY4MBxARk/
	 ev8gr2avvQkI6JMqttsC8y1otIFJVW45LNuE2bKBRzIWrDauq6S15jovZk+3MSMSrf
	 1fwAt9qt/LoOlPASr20a5VtkTpSGyU5YEEILXJhQ=
Date: Wed, 17 Apr 2024 13:28:14 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-netiucv-remove-function-pointer-cast.patch added to mm-nonmm-unstable branch
Message-Id: <20240417202815.6FDB3C072AA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/netiucv: remove function pointer cast
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-netiucv-remove-function-pointer-cast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-netiucv-remove-function-pointer-cast.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/netiucv: remove function pointer cast
Date: Wed, 17 Apr 2024 11:24:37 -0700

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/net/netiucv.c:1716:18: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
   1716 |                 dev->release = (void (*)(struct device *))kfree;
        |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI. The
comment is not really relevant after this change, so remove it.

Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-3-fd048c9903b0@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thorsten Winkler <twinkler@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/netiucv.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/s390/net/netiucv.c~s390-netiucv-remove-function-pointer-cast
+++ a/drivers/s390/net/netiucv.c
@@ -1693,6 +1693,11 @@ static const struct attribute_group *net
 	NULL,
 };
 
+static void netiucv_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
+
 static int netiucv_register_device(struct net_device *ndev)
 {
 	struct netiucv_priv *priv = netdev_priv(ndev);
@@ -1706,14 +1711,7 @@ static int netiucv_register_device(struc
 		dev->bus = &iucv_bus;
 		dev->parent = iucv_root;
 		dev->groups = netiucv_attr_groups;
-		/*
-		 * The release function could be called after the
-		 * module has been unloaded. It's _only_ task is to
-		 * free the struct. Therefore, we specify kfree()
-		 * directly here. (Probably a little bit obfuscating
-		 * but legitime ...).
-		 */
-		dev->release = (void (*)(struct device *))kfree;
+		dev->release = netiucv_free_dev;
 		dev->driver = &netiucv_driver;
 	} else
 		return -ENOMEM;
_

Patches currently in -mm which might be from nathan@kernel.org are

s390-vmlogrdr-remove-function-pointer-cast.patch
s390-smsgiucv_app-remove-function-pointer-cast.patch
s390-netiucv-remove-function-pointer-cast.patch

