From: akpm@linux-foundation.org
Subject: + string-do-not-export-memweight-to-userspace.patch added to -mm tree
Date: Wed, 15 Aug 2012 16:36:08 -0700
Message-ID: <20120815233609.038C75C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62570 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2HOXgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 19:36:11 -0400
Received: by wibhr14 with SMTP id hr14so4835wib.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 16:36:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, akinobu.mita@gmail.com


The patch titled
     Subject: string: do not export memweight() to userspace
has been added to the -mm tree.  Its filename is
     string-do-not-export-memweight-to-userspace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: string: do not export memweight() to userspace

Fix the following warning:

usr/include/linux/string.h:8: userspace cannot reference function or variable defined in the kernel

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/string.h~string-do-not-export-memweight-to-userspace include/linux/string.h
--- a/include/linux/string.h~string-do-not-export-memweight-to-userspace
+++ a/include/linux/string.h
@@ -144,8 +144,8 @@ static inline bool strstarts(const char 
 {
 	return strncmp(str, prefix, strlen(prefix)) == 0;
 }
-#endif
 
 extern size_t memweight(const void *ptr, size_t bytes);
 
+#endif /* __KERNEL__ */
 #endif /* _LINUX_STRING_H_ */
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
string-do-not-export-memweight-to-userspace.patch

