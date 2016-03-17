From: akpm@linux-foundation.org
Subject: [folded-merged] sscanf-implement-basic-character-sets-fix.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 14:03:38 -0700
Message-ID: <56eb1baa.wV6F1lc93CKTw/S2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030620AbcCQVDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 17:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeyu@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sscanf-implement-basic-character-sets-fix
has been removed from the -mm tree.  Its filename was
     sscanf-implement-basic-character-sets-fix.patch

This patch was dropped because it was folded into sscanf-implement-basic-character-sets.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: sscanf-implement-basic-character-sets-fix

80-col tweaks

Cc: Jessica Yu <jeyu@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~sscanf-implement-basic-character-sets-fix lib/vsprintf.c
--- a/lib/vsprintf.c~sscanf-implement-basic-character-sets-fix
+++ a/lib/vsprintf.c
@@ -2721,13 +2721,15 @@ int vsscanf(const char *buf, const char
 		/*
 		 * Warning: This implementation of the '[' conversion specifier
 		 * deviates from its glibc counterpart in the following ways:
-		 * (1) It does NOT support ranges i.e. '-' is NOT a special character
+		 * (1) It does NOT support ranges i.e. '-' is NOT a special
+		 *     character
 		 * (2) It cannot match the closing bracket ']' itself
 		 * (3) A field width is required
 		 * (4) '%*[' (discard matching input) is currently not supported
 		 *
 		 * Example usage:
-		 * ret = sscanf("00:0a:95","%2[^:]:%2[^:]:%2[^:]", buf1, buf2, buf3);
+		 * ret = sscanf("00:0a:95","%2[^:]:%2[^:]:%2[^:]",
+		 *		buf1, buf2, buf3);
 		 * if (ret < 3)
 		 *    // etc..
 		 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
sscanf-implement-basic-character-sets.patch

