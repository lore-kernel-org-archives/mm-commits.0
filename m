From: akpm@linux-foundation.org
Subject: + string-introduce-helper-to-get-base-file-name-from-given-path.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:15 -0700
Message-ID: <20121016213516.31E9F1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50254 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2JPVfR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:17 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so841478qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, fweisbec@gmail.com, gregkh@linuxfoundation.org, jbaron@redhat.com, rostedt@goodmis.org, yamanetoshi@gmail.com


The patch titled
     Subject: string: introduce helper to get base file name from given path
has been added to the -mm tree.  Its filename is
     string-introduce-helper-to-get-base-file-name-from-given-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
staging-rts_pstor-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

