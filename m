From: akpm@linux-foundation.org
Subject: [merged]
 printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:07:11 -0700
Message-ID: <53e3dc6f.zQaGVF8uKXQNFXl8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:47674 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaHGUHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:12 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1178283pab.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, andrew@lunn.ch, arunks.linux@gmail.com, cmetcalf@tilera.com, davidlohr@hp.com, gregkh@linuxfoundation.org, jack@suse.cz, joe@perches.com, keescook@chromium.org, mhocko@suse.cz, pmladek@suse.cz, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: move power of 2 practice of ring buffer size to a helper
has been removed from the -mm tree.  Its filename was
     printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: printk: move power of 2 practice of ring buffer size to a helper

In practice the power of 2 practice of the size of the kernel ring buffer
remains purely historical but not a requirement, specially now that we
have LOG_ALIGN and use it for both static and dynamic allocations.  It
could have helped with implicit alignment back in the days given the even
the dynamically sized ring buffer was guaranteed to be aligned so long as
CONFIG_LOG_BUF_SHIFT was set to produce a __LOG_BUF_LEN which is
architecture aligned, since log_buf_len=n would be allowed only if it was
> __LOG_BUF_LEN and we always ended up rounding the log_buf_len=n to the
next power of 2 with roundup_pow_of_two(), any multiple of 2 then should
be also architecture aligned.  These assumptions of course relied heavily
on CONFIG_LOG_BUF_SHIFT producing an aligned value but users can always
change this.

We now have precise alignment requirements set for the log buffer size for
both static and dynamic allocations, but lets upkeep the old practice of
using powers of 2 for its size to help with easy expected scalable values
and the allocators for dynamic allocations.  We'll reuse this later so
move this into a helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
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

 kernel/printk/printk.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN kernel/printk/printk.c~printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-move-power-of-2-practice-of-ring-buffer-size-to-a-helper
+++ a/kernel/printk/printk.c
@@ -828,15 +828,21 @@ void log_buf_kexec_setup(void)
 /* requested log_buf_len from kernel cmdline */
 static unsigned long __initdata new_log_buf_len;
 
-/* save requested log_buf_len since it's too early to process it */
-static int __init log_buf_len_setup(char *str)
+/* we practice scaling the ring buffer by powers of 2 */
+static void __init log_buf_len_update(unsigned size)
 {
-	unsigned size = memparse(str, &str);
