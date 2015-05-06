From: akpm@linux-foundation.org
Subject: [withdrawn] zram-add-compact-sysfs-entry-to-documentation.patch
 removed from -mm tree
Date: Wed, 06 May 2015 12:52:14 -0700
Message-ID: <554a70ee.PFZObXkXw1fKJxn0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbEFTwP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add `compact` sysfs entry to documentation
has been removed from the -mm tree.  Its filename was
     zram-add-compact-sysfs-entry-to-documentation.patch

This patch was dropped because it was withdrawn

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

 - zram_add     -- add a new zram device
 - zram_remove  -- remove a specific (device_id) zram device

    Usage example:
        # add a new specific zram device
        cat /sys/class/zram-control/zram_add
        1

        # remove a specific zram device
        echo 4 > /sys/class/zram-control/zram_remove



This patch (of 10):

Briefly describe missing `compact` sysfs entry.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
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
