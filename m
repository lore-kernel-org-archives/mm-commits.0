From: akpm@linux-foundation.org
Subject: [merged] zram-add-compact-sysfs-entry-to-documentation.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:54 -0700
Message-ID: <5591ad1a.HNzr/k1LmAZkKtPo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbF2Ujy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add `compact` sysfs entry to documentation
has been removed from the -mm tree.  Its filename was
     zram-add-compact-sysfs-entry-to-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add `compact` sysfs entry to documentation

We currently don't support zram on-demand device creation.  The only way
to have N zram devices is to specify num_devices module parameter (default
value 1).  That means that if, for some reason, at some point, user wants
to have N + 1 devies he/she must umount all the existing devices, unload
the module, load the module passing num_devices equals to N + 1.

This patchset introduces zram-control sysfs class, which has two sysfs
attrs:

 - hot_add     -- add a new zram device
 - hot_remove  -- remove a specific (device_id) zram device

    Usage example:
        # add a new specific zram device
        cat /sys/class/zram-control/hot_add
        1

        # remove a specific zram device
        echo 4 > /sys/class/zram-control/hot_remove




This patch (of 10):

Briefly describe missing `compact` sysfs entry.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/blockdev/zram.txt~zram-add-compact-sysfs-entry-to-documentation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-add-compact-sysfs-entry-to-documentation
+++ a/Documentation/blockdev/zram.txt
@@ -126,7 +126,7 @@ mem_used_max      RW    the maximum amou
 mem_limit         RW    the maximum amount of memory ZRAM can use to store
                         the compressed data
 num_migrated      RO    the number of objects migrated migrated by compaction
