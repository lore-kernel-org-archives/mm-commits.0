From: akpm@linux-foundation.org
Subject: [merged] string-introduce-helper-to-get-base-file-name-from-given-path.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:56 -0800
Message-ID: <20121218200556.D8666820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:64686 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUF6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:58 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so125696vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, fweisbec@gmail.com, gregkh@linuxfoundation.org, jbaron@redhat.com, rostedt@goodmis.org, yamanetoshi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string: introduce helper to get base file name from given path
has been removed from the -mm tree.  Its filename was
     string-introduce-helper-to-get-base-file-name-from-given-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: string: introduce helper to get base file name from given path

There are several places in the kernel that use functionality like
basename(3) with the exception: in case of '/foo/bar/' we expect to get an
empty string.  Let's do it common helper for them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/string.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/string.h~string-introduce-helper-to-get-base-file-name-from-given-path include/linux/string.h
--- a/include/linux/string.h~string-introduce-helper-to-get-base-file-name-from-given-path
+++ a/include/linux/string.h
@@ -143,4 +143,15 @@ static inline bool strstarts(const char 
 
 extern size_t memweight(const void *ptr, size_t bytes);
 
+/**
+ * kbasename - return the last part of a pathname.
+ *
+ * @path: path to extract the filename from.
+ */
+static inline const char *kbasename(const char *path)
+{
+	const char *tail = strrchr(path, '/');
+	return tail ? tail + 1 : path;
+}
+
 #endif /* _LINUX_STRING_H_ */
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

