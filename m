From: akpm@linux-foundation.org
Subject: [merged] string-do-not-export-memweight-to-userspace.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:27 -0700
Message-ID: <20120824184128.190A520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56684 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab2HXSla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:30 -0400
Received: by eekd4 with SMTP id d4so108447eek.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string: do not export memweight() to userspace
has been removed from the -mm tree.  Its filename was
     string-do-not-export-memweight-to-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

