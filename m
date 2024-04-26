Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128F823DC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104493; cv=none; b=sdYNv4JI00lsFQWJ10JQ+3Gs1Cpmfc63n5TJcjndibZVhotp3hj45kDKl7u0GC65d0U3jowhYvX5wua9y0tF9qI1Pa7TT0frKLEFMmDty0IfwHrSJyMPIurnXuZmQ6RLFI7XAam9M/lfZ9sx36JJLBKsu+Iur/gtWrb6kzCtsAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104493; c=relaxed/simple;
	bh=tNnEgiyYkHUMZJTQ0dhZs7m7LyS19H/bd60M5sJMfT4=;
	h=Date:To:From:Subject:Message-Id; b=fqn0T/0LrGZVJv+SWRLkEEEyxcZis3erssISoZR9hFnXkJCViNfaliuOspvLZQfA2IDpOSYKVKGF2OXyypr7o/4USRdfAxDtQHAPB6HTuufrfc58AIVioTcx4780Liv3n7fv06QVs8GLlUi8IEnmm9wsWXXlNnYtp+1RpJuKsIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qt14IoqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qt14IoqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA47DC113CD;
	Fri, 26 Apr 2024 04:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104493;
	bh=tNnEgiyYkHUMZJTQ0dhZs7m7LyS19H/bd60M5sJMfT4=;
	h=Date:To:From:Subject:From;
	b=qt14IoqWQHW6AJqcjtGtPGS7iBesfC08Ggq9bm/PADK6u7w7XY97philL1uP6wIlw
	 Vm1owzGed3Ahplnaa6O5JAOl07gNGlmMHFycP4JEb6jVY8ioSN8vCL/3pcu3WkL/xD
	 VScpIPgncY+ICim+lb7ZUTJmWfQ3f6Yqq3uCIC7o=
Date: Thu, 25 Apr 2024 21:08:12 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-smsgiucv_app-remove-function-pointer-cast.patch removed from -mm tree
Message-Id: <20240426040812.EA47DC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/smsgiucv_app: remove function pointer cast
has been removed from the -mm tree.  Its filename was
     s390-smsgiucv_app-remove-function-pointer-cast.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/smsgiucv_app: remove function pointer cast
Date: Wed, 17 Apr 2024 11:24:36 -0700

Clang warns (or errors with CONFIG_WERROR) after enabling
-Wcast-function-type-strict by default:

  drivers/s390/net/smsgiucv_app.c:176:26: error: cast from 'void (*)(const void *)' to 'void (*)(struct device *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
    176 |         smsg_app_dev->release = (void (*)(struct device *)) kfree;
        |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  1 error generated.

Add a standalone function to fix the warning properly, which addresses
the root of the warning that these casts are not safe for kCFI.

Link: https://lkml.kernel.org/r/20240417-s390-drivers-fix-cast-function-type-v1-2-fd048c9903b0@kernel.org
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

 drivers/s390/net/smsgiucv_app.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/s390/net/smsgiucv_app.c~s390-smsgiucv_app-remove-function-pointer-cast
+++ a/drivers/s390/net/smsgiucv_app.c
@@ -64,6 +64,11 @@ static void smsg_app_event_free(struct s
 	kfree(ev);
 }
 
+static void smsg_app_free_dev(struct device *dev)
+{
+	kfree(dev);
+}
+
 static struct smsg_app_event *smsg_app_event_alloc(const char *from,
 						   const char *msg)
 {
@@ -173,7 +178,7 @@ static int __init smsgiucv_app_init(void
 	}
 	smsg_app_dev->bus = &iucv_bus;
 	smsg_app_dev->parent = iucv_root;
-	smsg_app_dev->release = (void (*)(struct device *)) kfree;
+	smsg_app_dev->release = smsg_app_free_dev;
 	smsg_app_dev->driver = smsgiucv_drv;
 	rc = device_register(smsg_app_dev);
 	if (rc) {
_

Patches currently in -mm which might be from nathan@kernel.org are


