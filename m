From: akpm@linux-foundation.org
Subject: + suspend-fix-section-mismatch-warning-register_nosave_region.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:40:25 -0700
Message-ID: <200808122340.m7CNeP3P019798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYHLXkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, pavel@suse.cz, rjw@sisk.pl


The patch titled
     suspend: fix section mismatch warning - register_nosave_region
has been added to the -mm tree.  Its filename is
     suspend-fix-section-mismatch-warning-register_nosave_region.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: suspend: fix section mismatch warning - register_nosave_region
From: Marcin Slusarz <marcin.slusarz@gmail.com>

WARNING: vmlinux.o(.text+0xe684): Section mismatch in reference from the function register_nosave_region() to the function .init.text:__register_nosave_region()
The function register_nosave_region() references
the function __init __register_nosave_region().
This is often because register_nosave_region lacks a __init
annotation or the annotation of __register_nosave_region is wrong.

register_nosave_region calls __init function and is called only from
__init functions

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/suspend.h~suspend-fix-section-mismatch-warning-register_nosave_region include/linux/suspend.h
--- a/include/linux/suspend.h~suspend-fix-section-mismatch-warning-register_nosave_region
+++ a/include/linux/suspend.h
@@ -217,11 +217,11 @@ struct platform_hibernation_ops {
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
-static inline void register_nosave_region(unsigned long b, unsigned long e)
+static inline void __init register_nosave_region(unsigned long b, unsigned long e)
 {
 	__register_nosave_region(b, e, 0);
 }
-static inline void register_nosave_region_late(unsigned long b, unsigned long e)
+static inline void __init register_nosave_region_late(unsigned long b, unsigned long e)
 {
 	__register_nosave_region(b, e, 1);
 }
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

suspend-fix-section-mismatch-warning-register_nosave_region.patch

