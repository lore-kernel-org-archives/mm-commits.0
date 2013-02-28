From: akpm@linux-foundation.org
Subject: [merged] namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:11 -0800
Message-ID: <20130228201711.AA2C15A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:61414 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3B1URM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:12 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245519qen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, ebiederm@xmission.com, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/utsname.c: fix wrong comment about clone_uts_ns()
has been removed from the -mm tree.  Its filename was
     namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: kernel/utsname.c: fix wrong comment about clone_uts_ns()

Fix the wrong comment about the return value of clone_uts_ns()

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/utsname.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/utsname.c~namespaces-utsname-fix-wrong-comment-about-clone_uts_ns kernel/utsname.c
--- a/kernel/utsname.c~namespaces-utsname-fix-wrong-comment-about-clone_uts_ns
+++ a/kernel/utsname.c
@@ -30,7 +30,7 @@ static struct uts_namespace *create_uts_
 /*
  * Clone a new ns copying an original utsname, setting refcount to 1
  * @old_ns: namespace to clone
- * Return NULL on error (failure to kmalloc), new ns otherwise
+ * Return ERR_PTR(-ENOMEM) on error (failure to kmalloc), new ns otherwise
  */
 static struct uts_namespace *clone_uts_ns(struct user_namespace *user_ns,
 					  struct uts_namespace *old_ns)
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

origin.patch

