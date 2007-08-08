From: akpm@linux-foundation.org
Subject: + alpha-o_cloexec-definition.patch added to -mm tree
Date: Wed, 08 Aug 2007 13:34:32 -0700
Message-ID: <200708082034.l78KYW9S028969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522AbXHHUgh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 16:36:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rth@twiddle.net


The patch titled
     Alpha O_CLOEXEC definition
has been added to the -mm tree.  Its filename is
     alpha-o_cloexec-definition.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Alpha O_CLOEXEC definition
From: Richard Henderson <rth@twiddle.net>

The default definition in asm-generic conflicts with Alpha's O_DIRECT,
so, like several other arches, it needs to be redefined.

Signed-off-by: Richard Hendersion  <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/fcntl.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/asm-alpha/fcntl.h~alpha-o_cloexec-definition include/asm-alpha/fcntl.h
--- a/include/asm-alpha/fcntl.h~alpha-o_cloexec-definition
+++ a/include/asm-alpha/fcntl.h
@@ -16,6 +16,7 @@
 #define O_LARGEFILE	0400000 /* will be set by the kernel on every open */
 #define O_DIRECT	02000000 /* direct disk access - should check with OSF/1 */
 #define O_NOATIME	04000000
+#define O_CLOEXEC	010000000 /* set close_on_exec */
 
 #define F_GETLK		7
 #define F_SETLK		8
_

Patches currently in -mm which might be from rth@twiddle.net are

alpha-o_cloexec-definition.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
cleanup-arch-alpha-makefile.patch
report-the-per-irq-statistics-on-allarches.patch
