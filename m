From: akpm@linux-foundation.org
Subject: [wrecked] staging-rts_pstor-use-kbasename.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:43:26 -0700
Message-ID: <20121029194327.2DB5F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:61345 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2J2Tn3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:43:29 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so341396fae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:43:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, yamanetoshi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: staging: rts_pstor: use kbasename()
has been removed from the -mm tree.  Its filename was
     staging-rts_pstor-use-kbasename.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: staging: rts_pstor: use kbasename()

The custom filename function mostly repeats the kernel's kbasename. This patch
simplifies it. The updated filename() will not check for the '\' in the
filenames. It seems redundant in Linux. The __FILE__ macro always defined if
we compile an existing file. Thus, NULL check is not needed there as well.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
mm-use-kbasename.patch
procfs-use-kbasename.patch
trace-use-kbasename.patch

