From: akpm@linux-foundation.org
Subject: - 9p-fix-compile-error-if-config_sysctl.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:23:09 -0700
Message-ID: <200709270123.l8R1N9pM013263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46504 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752340AbXI0BYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aherrman@arcor.de, ericvh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     9p: fix compile error if !CONFIG_SYSCTL
has been removed from the -mm tree.  Its filename was
     9p-fix-compile-error-if-config_sysctl.patch

This patch was dropped because it is obsolete

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
 include/net/9p/9p.h |   12 ++++++++++++
 2 files changed, 12 insertions(+)

diff -puN include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl include/net/9p/9p.h
--- a/include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl
+++ a/include/net/9p/9p.h
@@ -412,6 +412,18 @@ int p9_idpool_check(int id, struct p9_id
 
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
+#endif
+
 #endif /* NET_9P_H */
diff -puN net/9p/mod.c~9p-fix-compile-error-if-config_sysctl net/9p/mod.c
_

Patches currently in -mm which might be from aherrman@arcor.de are

git-acpi.patch
git-input.patch
9p-fix-compile-error-if-config_sysctl.patch
