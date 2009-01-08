From: akpm@linux-foundation.org
Subject: - generic-swap-introduce-global-macro-swapa-b.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:51:16 -0800
Message-ID: <200901082251.n08MpGHm030400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763416AbZAHWvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     generic swap(): introduce global macro swap(a, b)
has been removed from the -mm tree.  Its filename was
     generic-swap-introduce-global-macro-swapa-b.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): introduce global macro swap(a, b)
From: Wu Fengguang <fengguang.wu@intel.com>

There have been some local definitions of swap(), it's time to replace
them all with a uniform one.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kernel.h~generic-swap-introduce-global-macro-swapa-b include/linux/kernel.h
--- a/include/linux/kernel.h~generic-swap-introduce-global-macro-swapa-b
+++ a/include/linux/kernel.h
@@ -476,6 +476,12 @@ static inline char *pack_hex_byte(char *
 	__val = __val < __min ? __min: __val;	\
 	__val > __max ? __max: __val; })
 
+
+/*
+ * swap - swap value of @a and @b
+ */
+#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

