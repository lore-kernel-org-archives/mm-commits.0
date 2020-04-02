From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 028/155] mm/Makefile: disable KCSAN for kmemleak
Date: Wed, 01 Apr 2020 21:04:37 -0700
Message-ID: <20200402040437.fy8hlNigx%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:39 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, catalin.marinas@arm.com, elver@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Qian Cai <cai@lca.pw>
Subject: mm/Makefile: disable KCSAN for kmemleak

Kmemleak could scan task stacks while plain writes happens to those stack
variables which could results in data races.  For example, in
sys_rt_sigaction and do_sigaction(), it could have plain writes in a
32-byte size.  Since the kmemleak does not care about the actual values of
a non-pointer and all do_sigaction() call sites only copy to stack
variables, just disable KCSAN for kmemleak to avoid annotating anything
outside Kmemleak just because Kmemleak scans everything.

Link: http://lkml.kernel.org/r/1583263716-25150-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/Makefile~mm-disable-kcsan-for-kmemleak
+++ a/mm/Makefile
@@ -6,6 +6,7 @@
 KASAN_SANITIZE_slab_common.o := n
 KASAN_SANITIZE_slab.o := n
 KASAN_SANITIZE_slub.o := n
+KCSAN_SANITIZE_kmemleak.o := n
 
 # These files are disabled because they produce non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. E.g. slab is out of
_
