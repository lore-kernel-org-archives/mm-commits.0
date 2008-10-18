From: akpm@linux-foundation.org
Subject: - w1-new-module-parameter-search_count.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:55 -0700
Message-ID: <200810182319.m9INJtEu029593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbYJRXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     W1: new module parameter search_count
has been removed from the -mm tree.  Its filename was
     w1-new-module-parameter-search_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: new module parameter search_count
From: David Fries <david@fries.net>

Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1_int.c~w1-new-module-parameter-search_count drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-new-module-parameter-search_count
+++ a/drivers/w1/w1_int.c
@@ -30,6 +30,8 @@
 #include "w1_int.h"
 
 static u32 w1_ids = 1;
+static int w1_search_count = -1; /* Default is continual scan */
+module_param_named(search_count, w1_search_count, int, 0);
 
 static int w1_enable_pullup = 1;
 module_param_named(enable_pullup, w1_enable_pullup, int, 0);
@@ -62,8 +64,8 @@ static struct w1_master * w1_alloc_dev(u
 	dev->initialized	= 0;
 	dev->id			= id;
 	dev->slave_ttl		= slave_ttl;
+	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
-        dev->search_count	= -1; /* continual scan */
 
 	/* 1 for w1_process to decrement
 	 * 1 for __w1_remove_master_device to decrement
_

Patches currently in -mm which might be from david@fries.net are

origin.patch

