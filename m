From: akpm@linux-foundation.org
Subject: - net-irda-parametersc-trivial-fixes.patch removed from -mm tree
Date: Mon, 03 Dec 2007 09:50:25 -0800
Message-ID: <200712031750.lB3HoP1a010657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39293 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbXLCRui (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 12:50:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     net/irda/parameters.c: trivial fixes
has been removed from the -mm tree.  Its filename was
     net-irda-parametersc-trivial-fixes.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: net/irda/parameters.c: trivial fixes
From: Richard Knutsson <ricknu-0@student.ltu.se>

Make a single va_start() -> va_end() path + fixing:
  CHECK   /home/kernel/src/net/irda/parameters.c
/home/kernel/src/net/irda/parameters.c:466:2: warning: Using plain integer as NULL pointer
/home/kernel/src/net/irda/parameters.c:520:2: warning: Using plain integer as NULL pointer
/home/kernel/src/net/irda/parameters.c:573:2: warning: Using plain integer as NULL pointer

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/irda/parameters.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN net/irda/parameters.c~net-irda-parametersc-trivial-fixes net/irda/parameters.c
--- a/net/irda/parameters.c~net-irda-parametersc-trivial-fixes
+++ a/net/irda/parameters.c
@@ -368,10 +368,11 @@ int irda_param_pack(__u8 *buf, char *fmt
 	va_list args;
 	char *p;
 	int n = 0;
+	int retval = 0;
 
 	va_start(args, fmt);
 
-	for (p = fmt; *p != '\0'; p++) {
+	for (p = fmt; *p != '\0' && retval == 0; p++) {
 		switch (*p) {
 		case 'b':  /* 8 bits unsigned byte */
 			buf[n++] = (__u8)va_arg(args, int);
@@ -392,13 +393,12 @@ int irda_param_pack(__u8 *buf, char *fmt
 			break;
 #endif
 		default:
-			va_end(args);
-			return -1;
+			retval = -1;
 		}
 	}
 	va_end(args);
 
-	return 0;
+	return retval;
 }
 EXPORT_SYMBOL(irda_param_pack);
 
@@ -411,10 +411,11 @@ static int irda_param_unpack(__u8 *buf, 
 	va_list args;
 	char *p;
 	int n = 0;
+	int retval = 0;
 
 	va_start(args, fmt);
 
-	for (p = fmt; *p != '\0'; p++) {
+	for (p = fmt; *p != '\0' && retval == 0; p++) {
 		switch (*p) {
 		case 'b':  /* 8 bits byte */
 			arg.ip = va_arg(args, __u32 *);
@@ -436,14 +437,13 @@ static int irda_param_unpack(__u8 *buf, 
 			break;
 #endif
 		default:
-			va_end(args);
-			return -1;
+			retval = -1;
 		}
 
 	}
 	va_end(args);
 
-	return 0;
+	return retval;
 }
 
 /*
@@ -463,7 +463,7 @@ int irda_param_insert(void *self, __u8 p
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	pi_minor = pi & info->pi_mask;
 	pi_major = pi >> info->pi_major_offset;
@@ -517,7 +517,7 @@ static int irda_param_extract(void *self
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	pi_minor = buf[n] & info->pi_mask;
 	pi_major = buf[n] >> info->pi_major_offset;
@@ -570,7 +570,7 @@ int irda_param_extract_all(void *self, _
 	int n = 0;
 
 	IRDA_ASSERT(buf != NULL, return ret;);
-	IRDA_ASSERT(info != 0, return ret;);
+	IRDA_ASSERT(info != NULL, return ret;);
 
 	/*
 	 * Parse all parameters. Each parameter must be at least two bytes
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

origin.patch
kernel-compliment-va_copy-with-va_end.patch
net-irda-parametersc-trivial-fixes.patch
dio-array_size-cleanup-update.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
reiserfs-complement-va_start-with-va_end.patch
