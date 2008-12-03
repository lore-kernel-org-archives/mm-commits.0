From: akpm@linux-foundation.org
Subject: + generic-swap-introduce-global-macro-swapa-b.patch added to -mm tree
Date: Wed, 03 Dec 2008 00:19:12 -0800
Message-ID: <200812030819.mB38JCjt010242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbYLCITO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 03:19:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com


The patch titled
     generic swap(): introduce global macro swap(a, b)
has been added to the -mm tree.  Its filename is
     generic-swap-introduce-global-macro-swapa-b.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -488,6 +488,12 @@ static inline char *pack_hex_byte(char *
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

linux-next.patch
9p-convert-d_iname-references-to-d_namename.patch
nfs-remove-redundant-tests-on-reading-new-pages.patch
generic-swap-ath9k-rename-swap-to-swap_array.patch
generic-swap-sparc-rename-swap-to-swap_ulong.patch
generic-swap-iphase-rename-swap-to-swap_byte_order.patch
generic-swap-lib-sortc-rename-swap-to-swap_func.patch
generic-swap-introduce-global-macro-swapa-b.patch
generic-swap-ext3-remove-local-swap-macro.patch
generic-swap-ext4-remove-local-swap-macro.patch
generic-swap-sched-remove-local-swap-macro.patch
generic-swap-dcache-use-swap-instead-of-private-do_switch.patch

