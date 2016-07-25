From: akpm@linux-foundation.org
Subject: [merged] futex-fix-shared-futex-operations-on-nommu.patch removed from -mm tree
Date: Mon, 25 Jul 2016 12:05:20 -0700
Message-ID: <579662f0.vvhxoTtqNgwObFaX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcGYTFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 15:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dalias@libc.org, bigeasy@linutronix.de, dave@stgolabs.net, dvhart@linux.intel.com, geert@linux-m68k.org, gerg@uclinux.org, kirill.shutemov@linux.intel.com, mgorman@suse.de, mingo@kernel.org, tglx@linutronix.de, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: futex: fix shared futex operations on nommu
has been removed from the -mm tree.  Its filename was
     futex-fix-shared-futex-operations-on-nommu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rich Felker <dalias@libc.org>
Subject: futex: fix shared futex operations on nommu

The shared get_futex_key code does not work on nommu, but is not needed
anyway because it's impossible for a given backing to have multiple
distinct virtual addresses on nommu.  Simply disable these code paths by
refraining from setting FLAG_SHARED when CONFIG_MMU is not enabled.

Signed-off-by: Rich Felker <dalias@libc.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/futex.c~futex-fix-shared-futex-operations-on-nommu kernel/futex.c
--- a/kernel/futex.c~futex-fix-shared-futex-operations-on-nommu
+++ a/kernel/futex.c
@@ -3158,8 +3158,10 @@ long do_futex(u32 __user *uaddr, int op,
 	int cmd = op & FUTEX_CMD_MASK;
 	unsigned int flags = 0;
 
+#ifdef CONFIG_MMU
 	if (!(op & FUTEX_PRIVATE_FLAG))
 		flags |= FLAGS_SHARED;
+#endif
 
 	if (op & FUTEX_CLOCK_REALTIME) {
 		flags |= FLAGS_CLOCKRT;
_

Patches currently in -mm which might be from dalias@libc.org are


