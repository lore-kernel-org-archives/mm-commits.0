From: akpm@linux-foundation.org
Subject: + lib-kconfigdebug-add-list_sort-debugging-switch.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:16 -0700
Message-ID: <201009271905.o8RJ5GwN010706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757175Ab0I0TFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/Kconfig.debug: add list_sort debugging switch
has been added to the -mm tree.  Its filename is
     lib-kconfigdebug-add-list_sort-debugging-switch.patch

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
Subject: lib/Kconfig.debug: add list_sort debugging switch
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    9 +++++++++
 lib/list_sort.c   |    4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~lib-kconfigdebug-add-list_sort-debugging-switch lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-kconfigdebug-add-list_sort-debugging-switch
+++ a/lib/Kconfig.debug
@@ -748,6 +748,15 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config TEST_LIST_SORT
+	bool "Linked list sorting test"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on 'list_sort()' function test. This test is
+	  executed only once during system boot, so affects only boot time.
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
diff -puN lib/list_sort.c~lib-kconfigdebug-add-list_sort-debugging-switch lib/list_sort.c
--- a/lib/list_sort.c~lib-kconfigdebug-add-list_sort-debugging-switch
+++ a/lib/list_sort.c
@@ -141,7 +141,7 @@ void list_sort(void *priv, struct list_h
 }
 EXPORT_SYMBOL(list_sort);
 
-#ifdef DEBUG_LIST_SORT
+#ifdef CONFIG_TEST_LIST_SORT
 struct debug_el {
 	struct list_head l_h;
 	int value;
@@ -214,4 +214,4 @@ static int __init list_sort_test(void)
 	return 0;
 }
 module_init(list_sort_test);
-#endif
+#endif /* CONFIG_TEST_LIST_SORT */
_

Patches currently in -mm which might be from Artem.Bityutskiy@nokia.com are

linux-next.patch
jffs2-use-cond_resched-instead-of-yield.patch
lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch
lib-kconfigdebug-add-list_sort-debugging-switch.patch
lib-list_sort-test-use-more-reasonable-printk-levels.patch
lib-list_sort-test-use-generic-random32.patch
lib-list_sort-test-improve-errors-handling.patch
lib-list_sort-test-unify-test-messages.patch
lib-list_sort-test-check-element-addresses.patch

