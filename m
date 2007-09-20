From: akpm@linux-foundation.org
Subject: + 9p-fix-compile-error-if-config_sysctl.patch added to -mm tree
Date: Wed, 19 Sep 2007 23:32:05 -0700
Message-ID: <200709200632.l8K6W5tx032103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbXITGcR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 02:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, ericvh@gmail.com


The patch titled
     9p: fix compile error if !CONFIG_SYSCTL
has been added to the -mm tree.  Its filename is
     9p-fix-compile-error-if-config_sysctl.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: fix compile error if !CONFIG_SYSCTL
From: Andreas Herrmann <aherrman@arcor.de>

Fix compile error if !CONFIG_SYSCTL:

    ...
  LD      .tmp_vmlinux1
net/built-in.o: In function `init_p9':
net/9p/mod.c:59: undefined reference to `p9_sysctl_register'
net/built-in.o: In function `exit_p9':
net/9p/mod.c:75: undefined reference to `p9_sysctl_unregister'
make: *** [.tmp_vmlinux1] Error 1
    ...

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 9p/mod.c            |    0 
 include/net/9p/9p.h |   11 +++++++++++
 2 files changed, 11 insertions(+)

diff -puN include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl include/net/9p/9p.h
--- a/include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl
+++ a/include/net/9p/9p.h
@@ -415,6 +415,17 @@ int p9_idpool_check(int id, struct p9_id
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
+#ifdef CONFIG_SYSCTL
 int __init p9_sysctl_register(void);
 void __exit p9_sysctl_unregister(void);
+#else
+static inline int p9_sysctl_register(void)
+{
+	return 0;
+}
+
+static inline void p9_sysctl_unregister(void)
+{
+}
+
 #endif /* NET_9P_H */
diff -puN net/9p/mod.c~9p-fix-compile-error-if-config_sysctl net/9p/mod.c
_

Patches currently in -mm which might be from aherrman@arcor.de are

origin.patch
9p-fix-compile-error-if-config_sysctl.patch
mac_hid-fix-build-error-if-mac_emumousebtn-input.patch
