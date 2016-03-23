From: akpm@linux-foundation.org
Subject: [merged]
 input-redefine-input_compat_test-as-in_compat_syscall.patch removed from
 -mm tree
Date: Wed, 23 Mar 2016 10:40:57 -0700
Message-ID: <56f2d529.scSwFFyFAAjMf15N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbcCWRk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2016 13:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luto@kernel.org, dmitry.torokhov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: input: redefine INPUT_COMPAT_TEST as in_compat_syscall()
has been removed from the -mm tree.  Its filename was
     input-redefine-input_compat_test-as-in_compat_syscall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Lutomirski <luto@kernel.org>
Subject: input: redefine INPUT_COMPAT_TEST as in_compat_syscall()

The input compat code should work like all other compat code: for 32-bit
syscalls, use the 32-bit ABI and for 64-bit syscalls, use the 64-bit ABI. 
We have a helper for that (in_compat_syscall()): just use it.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input-compat.h |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff -puN drivers/input/input-compat.h~input-redefine-input_compat_test-as-in_compat_syscall drivers/input/input-compat.h
--- a/drivers/input/input-compat.h~input-redefine-input_compat_test-as-in_compat_syscall
+++ a/drivers/input/input-compat.h
@@ -17,17 +17,7 @@
 
 #ifdef CONFIG_COMPAT
 
-/* Note to the author of this code: did it ever occur to
-   you why the ifdefs are needed? Think about it again. -AK */
-#if defined(CONFIG_X86_64) || defined(CONFIG_TILE)
-#  define INPUT_COMPAT_TEST is_compat_task()
-#elif defined(CONFIG_S390)
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_31BIT)
-#elif defined(CONFIG_MIPS)
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT_ADDR)
-#else
-#  define INPUT_COMPAT_TEST test_thread_flag(TIF_32BIT)
-#endif
+#define INPUT_COMPAT_TEST in_compat_syscall()
 
 struct input_event_compat {
 	struct compat_timeval time;
_

Patches currently in -mm which might be from luto@kernel.org are


