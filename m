From: akpm@linux-foundation.org
Subject: + namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch added to -mm tree
Date: Thu, 31 Jan 2013 12:49:06 -0800
Message-ID: <20130131204906.947E631C1B2@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42638 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3AaUtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jan 2013 15:49:09 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so346607vcd.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Jan 2013 12:49:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, ebiederm@xmission.com, serge.hallyn@canonical.com


The patch titled
     Subject: kernel/utsname.c: fix wrong comment about clone_uts_ns()
has been added to the -mm tree.  Its filename is
     namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-wrong-comments-about-anon_vma-lock.patch
linux-next.patch
fs-execc-make-bprm_mm_init-static.patch
namespaces-utsname-fix-wrong-comment-about-clone_uts_ns.patch

