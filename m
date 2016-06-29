From: akpm@linux-foundation.org
Subject: [merged] mm-prevent-kasan-false-positives-in-kmemleak.patch
 removed from -mm tree
Date: Tue, 28 Jun 2016 19:03:01 -0700
Message-ID: <57732c55.GnFmefjTCOfkESJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbcF2CLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jun 2016 22:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, catalin.marinas@arm.com, glider@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: prevent KASAN false positives in kmemleak
has been removed from the -mm tree.  Its filename was
     mm-prevent-kasan-false-positives-in-kmemleak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: mm: prevent KASAN false positives in kmemleak

When kmemleak dumps contents of leaked objects it reads whole
objects regardless of user-requested size. This upsets KASAN.
Disable KASAN checks around object dump.

Link: http://lkml.kernel.org/r/1466617631-68387-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/kmemleak.c~mm-prevent-kasan-false-positives-in-kmemleak mm/kmemleak.c
--- a/mm/kmemleak.c~mm-prevent-kasan-false-positives-in-kmemleak
+++ a/mm/kmemleak.c
@@ -307,8 +307,10 @@ static void hex_dump_object(struct seq_f
 	len = min_t(size_t, object->size, HEX_MAX_LINES * HEX_ROW_SIZE);
 
 	seq_printf(seq, "  hex dump (first %zu bytes):\n", len);
+	kasan_disable_current();
 	seq_hex_dump(seq, "    ", DUMP_PREFIX_NONE, HEX_ROW_SIZE,
 		     HEX_GROUP_SIZE, ptr, len, HEX_ASCII);
+	kasan_enable_current();
 }
 
 /*
_

Patches currently in -mm which might be from dvyukov@google.com are


