Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574583C068
	for <mm-commits@vger.kernel.org>; Wed, 17 Apr 2024 20:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713385694; cv=none; b=NKty7Dp3WCUO9e3UEZOJiGr0CQqGg6DrmEEsLOI7olji6dhnCiE7FR/X7Ln1HBofytEChjdannz1dHiYm9SZdW6exh8NE38EkR01o3Jm1sFd8OW+2bT2r5jLv/+FPaiv6FO/fX5mTFREho0mjZxRpi9MopCHw+vb8mb/854+TtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713385694; c=relaxed/simple;
	bh=D40DB2fYTMve5o7BfHLLKY3LWNy1R6th9YShbGoS+4Y=;
	h=Date:To:From:Subject:Message-Id; b=X7u0IdVovlbpDk8YMh7umi1oXsBvNvhCdz+OIjwx9qy+BeEYwaHKuXAZGYrbM9x8ugD49rziFGRdNO3MkA41IWV47XyDmTaItX5tUWpqe0x9R3D+z/SQMWbJFDOzIBOpNiUEZOqQso+NoPJwtkKmjmzIZdYukI833h3/3lFBlqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lbIqMLJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lbIqMLJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DA0C116B1;
	Wed, 17 Apr 2024 20:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713385693;
	bh=D40DB2fYTMve5o7BfHLLKY3LWNy1R6th9YShbGoS+4Y=;
	h=Date:To:From:Subject:From;
	b=lbIqMLJB7IrVTfzJjoLKIW9NqFszcw+gm6GlRuqWHegT3tCsXU+yQ/cMv/bZ42I7w
	 r7/4R6ZQl4hXLFak5aaUyJeRzlJH/2+9b/uddjTkjJi8dupMorcLvaFl0AlftH/xeZ
	 MUAf7lTDFQu+KdDHQVBxppNpsflW8dGVTxD8D770=
Date: Wed, 17 Apr 2024 13:28:13 -0700
To: mm-commits@vger.kernel.org,wintera@linux.ibm.com,twinkler@linux.ibm.com,svens@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-smsgiucv_app-remove-function-pointer-cast.patch added to mm-nonmm-unstable branch
Message-Id: <20240417202813.D8DA0C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/smsgiucv_app: remove function pointer cast
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     s390-smsgiucv_app-remove-function-pointer-cast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-smsgiucv_app-remove-function-pointer-cast.patch

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

s390-vmlogrdr-remove-function-pointer-cast.patch
s390-smsgiucv_app-remove-function-pointer-cast.patch
s390-netiucv-remove-function-pointer-cast.patch

