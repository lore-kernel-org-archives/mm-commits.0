From: akpm@linux-foundation.org
Subject: + printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch added to -mm tree
Date: Mon, 23 Jun 2014 15:44:43 -0700
Message-ID: <53a8addb.UcE6TPgAsXiIPMpD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaFWWop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 18:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, andrew@lunn.ch, arunks.linux@gmail.com, cmetcalf@tilera.com, davidlohr@hp.com, gregkh@linuxfoundation.org, jack@suse.cz, joe@perches.com, keescook@chromium.org, mhocko@suse.cz, pmladek@suse.cz, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: make dynamic kernel ring buffer alignment explicit
has been added to the -mm tree.  Its filename is
     printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
it can be reduced to a non aligned value.  Commit 6ebb017de9 by Andrew
ensures the static buffer is always aligned and the decision of alignment
is done by the compiler by using __alignof__(struct log).

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

printk-make-dynamic-kernel-ring-buffer-alignment-explicit.patch
printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus.patch

