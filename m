From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-btrfs-handle-more-message-headers-fix.patch removed from -mm tree
Date: Mon, 12 Dec 2016 16:25:45 -0800
Message-ID: <584f4009.+aeHDYgbO3UhL5qe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38170 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAZC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk/btrfs: Fix a check of the valid message level
has been removed from the -mm tree.  Its filename was
     printk-btrfs-handle-more-message-headers-fix.patch

This patch was dropped because it was folded into printk-btrfs-handle-more-message-headers.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk/btrfs: Fix a check of the valid message level

Huh, this was a childish mistake.

Link: http://lkml.kernel.org/r/20161111183236.GD2145@dhcp128.suse.cz
Signed-off-by: Petr Mladek <pmladek@suse.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/btrfs/super.c~printk-btrfs-handle-more-message-headers-fix fs/btrfs/super.c
--- a/fs/btrfs/super.c~printk-btrfs-handle-more-message-headers-fix
+++ a/fs/btrfs/super.c
@@ -214,7 +214,7 @@ void btrfs_printk(const struct btrfs_fs_
 	while ((kern_level = printk_get_level(fmt)) != 0) {
 		size_t size = printk_skip_level(fmt) - fmt;
 
-		if (kern_level >= '0' || kern_level <= '7') {
+		if (kern_level >= '0' && kern_level <= '7') {
 			memcpy(lvl, fmt,  size);
 			lvl[size] = '\0';
 			type = logtypes[kern_level - '0'];
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-fix-up-handling-of-the-full-nmi-log-buffer.patch
printk-nmi-handle-continuous-lines-and-missing-newline.patch
printk-kdb-handle-more-message-headers.patch
printk-btrfs-handle-more-message-headers.patch
printk-sound-handle-more-message-headers.patch
printk-sound-handle-more-message-headers-fix.patch

