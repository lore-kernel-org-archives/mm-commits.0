Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4016C823DC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104494; cv=none; b=E49+cRWmZHidv9gz2s2Qab3yZNRGYH8Er/CofRMingM1jmW4J48WZqFoyvFx+eU3y7TJT6IMbJ+P1px3IQ45IpqRF+tHZLDOg8ow0pfQXRGsh8N/2iB6ztdn42IQ3mE6CVQx4bHOGby7YRSGgx1JYwmqQoWAcK1ll0Pqz+lGXZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104494; c=relaxed/simple;
	bh=hGI5i+bDK9PqncSCDLsk/EtuN8TeTddqVC3dfwBjgBQ=;
	h=Date:To:From:Subject:Message-Id; b=HVUXX0do8CAk6d4gBKIsBEu5679Niu7Q93FNu6LngYMHHrgOI/VuIy1iYWO4UHmDa7CRfKu75/AJAgq9EShDFFdr7jG7CxBICzdXAMtds5E2idZdxEgQ0BNwf/CshPuOzyi1z3FSYmXGVWQAIkazntuvkIVrycVDkBQOSREISHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A9zsD5dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A9zsD5dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160C2C113CD;
	Fri, 26 Apr 2024 04:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104494;
	bh=hGI5i+bDK9PqncSCDLsk/EtuN8TeTddqVC3dfwBjgBQ=;
	h=Date:To:From:Subject:From;
	b=A9zsD5dJSBcpmZIujN3VwIlmfR9qYPUbMcNbE8c/AdQuIE2sys3Mo1yM8cPn8p0H9
	 IjTn3I7qgxt6mK7GYNk47i3UbKleCL/fM2g5+09HYuiiUJFkWFXmkJrZKzGgdkDYgo
	 rZfbq9eTxK67PF0fkPvrXMLqIGSka91IHVMjXnqU=
Date: Thu, 25 Apr 2024 21:08:13 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-netiucv-remove-function-pointer-cast.patch removed from -mm tree
Message-Id: <20240426040814.160C2C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/netiucv: remove function pointer cast
has been removed from the -mm tree.  Its filename was
     s390-netiucv-remove-function-pointer-cast.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


