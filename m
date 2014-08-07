From: akpm@linux-foundation.org
Subject: [merged]
 printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:07:09 -0700
Message-ID: <53e3dc6d.H90tsYgsvUA9Q2ho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:60806 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaHGUHK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:10 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so878768igd.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, andrew@lunn.ch, arunks.linux@gmail.com, cmetcalf@tilera.com, davidlohr@hp.com, gregkh@linuxfoundation.org, jack@suse.cz, joe@perches.com, keescook@chromium.org, mhocko@suse.cz, pmladek@suse.cz, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: make dynamic kernel ring buffer alignment explicit
has been removed from the -mm tree.  Its filename was
     printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: printk: make dynamic kernel ring buffer alignment explicit

We have to consider alignment for the ring buffer both for the default
static size, and then also for when an dynamic allocation is made when the
log_buf_len=n kernel parameter is passed to set the size specifically to a
size larger than the default size set by the architecture through
CONFIG_LOG_BUF_SHIFT.

The default static kernel ring buffer can be aligned properly if
architectures set CONFIG_LOG_BUF_SHIFT properly, we provide ranges for the
size though so even if CONFIG_LOG_BUF_SHIFT has a sensible aligned value
it can be reduced to a non aligned value.  Commit 6ebb017de9 ("printk: Fix
alignment of buf causing crash on ARM EABI") by Andrew Lunn ensures the
static buffer is always aligned and the decision of alignment is done by
the compiler by using __alignof__(struct log).

When log_buf_len=n is used we allocate the ring buffer dynamically. 
Dynamic allocation varies, for the early allocation called before
setup_arch() memblock_virt_alloc() requests a page aligment and for the
default kernel allocation memblock_virt_alloc_nopanic() requests no
special alignment, which in turn ends up aligning the allocation to
SMP_CACHE_BYTES, which is L1 cache aligned.

Since we already have the required alignment for the kernel ring buffer
though we can do better and request explicit alignment for LOG_ALIGN. 
This does that to be safe and make dynamic allocation alignment explicit.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Tested-by: Petr Mladek <pmladek@suse.cz>
Acked-by: Petr Mladek <pmladek@suse.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-make-dynamic-kernel-ring-buffer-alignment-explicit kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-make-dynamic-kernel-ring-buffer-alignment-explicit
+++ a/kernel/printk/printk.c
@@ -853,9 +853,10 @@ void __init setup_log_buf(int early)
 
 	if (early) {
 		new_log_buf =
-			memblock_virt_alloc(new_log_buf_len, PAGE_SIZE);
+			memblock_virt_alloc(new_log_buf_len, LOG_ALIGN);
 	} else {
-		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len, 0);
+		new_log_buf = memblock_virt_alloc_nopanic(new_log_buf_len,
+							  LOG_ALIGN);
 	}
 
 	if (unlikely(!new_log_buf)) {
_

Patches currently in -mm which might be from mcgrof@suse.com are

origin.patch

