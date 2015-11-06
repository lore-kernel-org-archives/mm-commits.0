From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:17:54 -0800
Message-ID: <563d0af2.oy0tqSJj2Dizz+NK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161810AbbKFURz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub, kasan: enable user tracking by default with KASAN=y
has been removed from the -mm tree.  Its filename was
     mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm, slub, kasan: enable user tracking by default with KASAN=y

It's recommended to have slub's user tracking enabled with CONFIG_KASAN,
because:

a) User tracking disables slab merging which improves
    detecting out-of-bounds accesses.
b) User tracking metadata acts as redzone which also improves
    detecting out-of-bounds accesses.
c) User tracking provides additional information about object.
    This information helps to understand bugs.

Currently it is not enabled by default.  Besides recompiling the kernel
with KASAN and reinstalling it, user also have to change the boot cmdline,
which is not very handy.

Enable slub user tracking by default with KASAN=y, since there is no good
reason to not do this.

[akpm@linux-foundation.org: little fixes, per David]
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    3 +--
 lib/Kconfig.kasan       |    3 +--
 mm/slub.c               |    4 +++-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN Documentation/kasan.txt~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y Documentation/kasan.txt
--- a/Documentation/kasan.txt~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y
+++ a/Documentation/kasan.txt
@@ -28,8 +28,7 @@ the latter is 1.1 - 2 times faster. Inli
 version 5.0 or later.
 
 Currently KASAN works only with the SLUB memory allocator.
-For better bug detection and nicer report, enable CONFIG_STACKTRACE and put
-at least 'slub_debug=U' in the boot cmdline.
+For better bug detection and nicer reporting, enable CONFIG_STACKTRACE.
 
 To disable instrumentation for specific files or directories, add a line
 similar to the following to the respective kernel Makefile:
diff -puN lib/Kconfig.kasan~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y lib/Kconfig.kasan
--- a/lib/Kconfig.kasan~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y
+++ a/lib/Kconfig.kasan
@@ -15,8 +15,7 @@ config KASAN
 	  global variables requires gcc 5.0 or later.
 	  This feature consumes about 1/8 of available memory and brings about
 	  ~x3 performance slowdown.
-	  For better error detection enable CONFIG_STACKTRACE,
-	  and add slub_debug=U to boot cmdline.
+	  For better error detection enable CONFIG_STACKTRACE.
 
 choice
 	prompt "Instrumentation type"
diff -puN mm/slub.c~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y mm/slub.c
--- a/mm/slub.c~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y
+++ a/mm/slub.c
@@ -459,8 +459,10 @@ static void get_map(struct kmem_cache *s
 /*
  * Debug settings:
  */
-#ifdef CONFIG_SLUB_DEBUG_ON
+#if defined(CONFIG_SLUB_DEBUG_ON)
 static int slub_debug = DEBUG_DEFAULT_FLAGS;
+#elif defined(CONFIG_KASAN)
+static int slub_debug = SLAB_STORE_USER;
 #else
 static int slub_debug;
 #endif
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


