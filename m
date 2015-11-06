From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:32:17 -0800
Message-ID: <563c1131./LVq/28S9g91sf3l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:32:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

This patch was dropped because it was folded into mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix

little fixes, per David

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    2 +-
 mm/slub.c               |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/kasan.txt~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix Documentation/kasan.txt
--- a/Documentation/kasan.txt~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix
+++ a/Documentation/kasan.txt
@@ -28,7 +28,7 @@ the latter is 1.1 - 2 times faster. Inli
 version 5.0 or later.
 
 Currently KASAN works only with the SLUB memory allocator.
-For better bug detection and nicer report and enable CONFIG_STACKTRACE.
+For better bug detection and nicer reporting, enable CONFIG_STACKTRACE.
 
 To disable instrumentation for specific files or directories, add a line
 similar to the following to the respective kernel Makefile:
diff -puN mm/slub.c~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix mm/slub.c
--- a/mm/slub.c~mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix
+++ a/mm/slub.c
@@ -459,7 +459,7 @@ static void get_map(struct kmem_cache *s
 /*
  * Debug settings:
  */
-#ifdef CONFIG_SLUB_DEBUG_ON
+#if defined(CONFIG_SLUB_DEBUG_ON)
 static int slub_debug = DEBUG_DEFAULT_FLAGS;
 #elif defined(CONFIG_KASAN)
 static int slub_debug = SLAB_STORE_USER;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-vmstatc-uninline-node_page_state.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y.patch

