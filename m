From: akpm@linux-foundation.org
Subject: [merged] compat-return-efault-on-error-in-waitid.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:37:32 -0800
Message-ID: <20130222203732.C12915A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39279 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009Ab3BVUhd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:33 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103566ggi.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: return -EFAULT on error in waitid()
has been removed from the -mm tree.  Its filename was
     compat-return-efault-on-error-in-waitid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: compat: return -EFAULT on error in waitid()

The copy_to_user() call returns the number of bytes remaining but we want
to return -EFAULT on error.

Fixes "x32: fix waitid()"

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/compat.c~compat-return-efault-on-error-in-waitid kernel/compat.c
--- a/kernel/compat.c~compat-return-efault-on-error-in-waitid
+++ a/kernel/compat.c
@@ -593,7 +593,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 		else
 			ret = put_compat_rusage(&ru, uru);
 		if (ret)
-			return ret;
+			return -EFAULT;
 	}
 
 	BUG_ON(info.si_code & __SI_MASK);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock-fix.patch

