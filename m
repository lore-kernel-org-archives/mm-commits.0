From: akpm@linux-foundation.org
Subject: + staging-rts_pstor-use-kbasename.patch added to -mm tree
Date: Tue, 16 Oct 2012 14:35:21 -0700
Message-ID: <20121016213522.8175E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:52814 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab2JPVfZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Oct 2012 17:35:25 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so257975eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 16 Oct 2012 14:35:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, yamanetoshi@gmail.com


The patch titled
     Subject: staging: rts_pstor: use kbasename()
has been added to the -mm tree.  Its filename is
     staging-rts_pstor-use-kbasename.patch

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
Subject: staging: rts_pstor: use kbasename()

The custom filename function mostly repeats the kernel's kbasename. This patch
simplifies it. The updated filename() will not check for the '\' in the
filenames. It seems redundant in Linux. The __FILE__ macro always defined if
we compile an existing file. Thus, NULL check is not needed there as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/rts_pstor/trace.h |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff -puN drivers/staging/rts_pstor/trace.h~staging-rts_pstor-use-kbasename drivers/staging/rts_pstor/trace.h
--- a/drivers/staging/rts_pstor/trace.h~staging-rts_pstor-use-kbasename
+++ a/drivers/staging/rts_pstor/trace.h
@@ -24,31 +24,15 @@
 #ifndef __REALTEK_RTSX_TRACE_H
 #define __REALTEK_RTSX_TRACE_H
 
+#include <linux/string.h>
+
 #define _MSG_TRACE
 
 #ifdef _MSG_TRACE
-static inline char *filename(char *path)
-{
-	char *ptr;
-
-	if (path == NULL)
-		return NULL;
-
-	ptr = path;
-
-	while (*ptr != '\0') {
-		if ((*ptr == '\\') || (*ptr == '/'))
-			path = ptr + 1;
-		
-		ptr++;
-	}
-
-	return path;
-}
 
 #define TRACE_RET(chip, ret)   										\
 do {													\
-	char *_file = filename(__FILE__);								\
+	const char *_file = kbasename(__FILE__);								\
 	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
 	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
 	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
@@ -64,7 +48,7 @@ do {													\
 
 #define TRACE_GOTO(chip, label)   									\
 do {													\
-	char *_file = filename(__FILE__);								\
+	const char *_file = kbasename(__FILE__);								\
 	RTSX_DEBUGP("[%s][%s]:[%d]\n", _file, __func__, __LINE__);					\
 	(chip)->trace_msg[(chip)->msg_idx].line = (u16)(__LINE__);					\
 	strncpy((chip)->trace_msg[(chip)->msg_idx].func, __func__, MSG_FUNC_LEN-1);			\
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
string-introduce-helper-to-get-base-file-name-from-given-path.patch
lib-dynamic_debug-use-kbasename.patch
staging-rts_pstor-use-kbasename.patch
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

