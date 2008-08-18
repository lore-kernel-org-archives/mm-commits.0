From: akpm@linux-foundation.org
Subject: - suspend-fix-section-mismatch-warning-register_nosave_region.patch removed from -mm tree
Date: Mon, 18 Aug 2008 12:39:19 -0700
Message-ID: <200808181939.m7IJdJnM008283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762676AbYHRTj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Aug 2008 15:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, pavel@suse.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     suspend: fix section mismatch warning - register_nosave_region
has been removed from the -mm tree.  Its filename was
     suspend-fix-section-mismatch-warning-register_nosave_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

