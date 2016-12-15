From: akpm@linux-foundation.org
Subject: [merged] btrfs-better-handle-btrfs_printk-defaults.patch removed
 from -mm tree
Date: Thu, 15 Dec 2016 10:44:55 -0800
Message-ID: <5852e4a7.0Rkac6xtxUYdkY2b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48290 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753119AbcLOSo5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, dsterba@suse.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: btrfs: better handle btrfs_printk() defaults
has been removed from the -mm tree.  Its filename was
     btrfs-better-handle-btrfs_printk-defaults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: btrfs: better handle btrfs_printk() defaults

commit 262c5e86fec7cfd ("printk/btrfs: handle more message headers")
triggers:

    warning: `ratelimit' may be used uninitialized in this function

with gcc (4.1.2) and probably many other versions.  The code actually is
correct but a bit twisted.  Let's make it more straightforward and set the
default values at the beginning.

Link: http://lkml.kernel.org/r/20161213135246.GQ3506@pathway.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN fs/btrfs/super.c~btrfs-better-handle-btrfs_printk-defaults fs/btrfs/super.c
--- a/fs/btrfs/super.c~btrfs-better-handle-btrfs_printk-defaults
+++ a/fs/btrfs/super.c
@@ -202,12 +202,12 @@ static struct ratelimit_state printk_lim
 void btrfs_printk(const struct btrfs_fs_info *fs_info, const char *fmt, ...)
 {
 	struct super_block *sb = fs_info->sb;
-	char lvl[PRINTK_MAX_SINGLE_HEADER_LEN + 1];
+	char lvl[PRINTK_MAX_SINGLE_HEADER_LEN + 1] = "\0";
 	struct va_format vaf;
 	va_list args;
-	const char *type = NULL;
 	int kern_level;
-	struct ratelimit_state *ratelimit;
+	const char *type = logtypes[4];
+	struct ratelimit_state *ratelimit = &printk_limits[4];
 
 	va_start(args, fmt);
 
@@ -223,12 +223,6 @@ void btrfs_printk(const struct btrfs_fs_
 		fmt += size;
 	}
 
-	if (!type) {
-		*lvl = '\0';
-		type = logtypes[4];
-		ratelimit = &printk_limits[4];
-	}
