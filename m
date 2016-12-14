From: akpm@linux-foundation.org
Subject: [merged] kasan-turn-on-fsanitize-address-use-after-scope.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:26:38 -0800
Message-ID: <58519cee.sKO8YGgD94bMBofo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756371AbcLNT0j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, andreyknvl@google.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: turn on -fsanitize-address-use-after-scope
has been removed from the -mm tree.  Its filename was
     kasan-turn-on-fsanitize-address-use-after-scope.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kasan: turn on -fsanitize-address-use-after-scope

In the upcoming gcc7 release, the -fsanitize=kernel-address option at
first implied new -fsanitize-address-use-after-scope option.  This would
cause link errors on older kernels because they don't have two new
functions required for use-after-scope support.  Therefore, gcc7 changed
default to -fno-sanitize-address-use-after-scope.

Now the kernel has everything required for that feature since commit
828347f8f9a5 ("kasan: support use-after-scope detection").  So, to make it
work, we just have to enable use-after-scope in CFLAGS.

Link: http://lkml.kernel.org/r/1481207977-28654-1-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |    2 ++
 1 file changed, 2 insertions(+)

diff -puN scripts/Makefile.kasan~kasan-turn-on-fsanitize-address-use-after-scope scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-turn-on-fsanitize-address-use-after-scope
+++ a/scripts/Makefile.kasan
@@ -28,4 +28,6 @@ else
         CFLAGS_KASAN := $(CFLAGS_KASAN_MINIMAL)
     endif
 endif
+
+CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
 endif
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


