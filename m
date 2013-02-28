From: akpm@linux-foundation.org
Subject: [merged] kexec-prevent-double-free-on-image-allocation-failure.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:13 -0800
Message-ID: <20130228201213.CC52631C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:55187 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3B1UMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:15 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244658vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, ebiederm@xmission.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: prevent double free on image allocation failure
has been removed from the -mm tree.  Its filename was
     kexec-prevent-double-free-on-image-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: kexec: prevent double free on image allocation failure

If kimage_normal_alloc() fails to initialize an allocated kimage, it will
free the image but would still set 'rimage', as a result kexec_load will
try to free it again.

This would explode as part of the freeing process is accessing internal
members which point to uninitialized memory.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/kexec.c~kexec-prevent-double-free-on-image-allocation-failure kernel/kexec.c
--- a/kernel/kexec.c~kexec-prevent-double-free-on-image-allocation-failure
+++ a/kernel/kexec.c
@@ -242,8 +242,6 @@ static int kimage_normal_alloc(struct ki
 	if (result)
 		goto out;
 
-	*rimage = image;
