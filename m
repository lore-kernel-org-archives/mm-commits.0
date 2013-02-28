From: akpm@linux-foundation.org
Subject: [merged] kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:19 -0800
Message-ID: <20130228201219.BED5F31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53135 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3B1UMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:21 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so244704vcd.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com, horms@verge.net.au, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: avoid freeing NULL pointer in image_crash_alloc()
has been removed from the -mm tree.  Its filename was
     kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: kexec: avoid freeing NULL pointer in image_crash_alloc()

Though there is no error if we free a NULL pointer, I think we could avoid
this behaviour.  Change the code a little in kimage_crash_alloc() could
avoid this kind of unnecessary free.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN kernel/kexec.c~kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc kernel/kexec.c
--- a/kernel/kexec.c~kexec-avoid-freeing-null-pointer-in-function-kimage_crash_alloc
+++ a/kernel/kexec.c
@@ -316,7 +316,7 @@ static int kimage_crash_alloc(struct kim
 		mend = mstart + image->segment[i].memsz - 1;
 		/* Ensure we are within the crash kernel limits */
 		if ((mstart < crashk_res.start) || (mend > crashk_res.end))
-			goto out;
+			goto out_free;
 	}
 
 	/*
@@ -329,16 +329,15 @@ static int kimage_crash_alloc(struct kim
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
 		printk(KERN_ERR "Could not allocate control_code_buffer\n");
-		goto out;
+		goto out_free;
 	}
 
-	result = 0;
-out:
-	if (result == 0)
-		*rimage = image;
-	else
-		kfree(image);
+	*rimage = image;
+	return 0;
 
+out_free:
+	kfree(image);
+out:
 	return result;
 }
 
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
ipvs-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch
kexec-fix-wrong-types-of-some-local-variables.patch
kexec-use-min_t-to-simplify-logic.patch
kexec-use-min_t-to-simplify-logic-fix.patch

