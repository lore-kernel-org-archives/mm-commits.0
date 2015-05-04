From: akpm@linux-foundation.org
Subject: + zram-add-compact-sysfs-entry-to-documentation.patch added to
 -mm tree
Date: Mon, 04 May 2015 15:56:55 -0700
Message-ID: <5547f937.3ngAUWT0jjOvtVbm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbEDW44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 18:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add `compact` sysfs entry to documentation
has been added to the -mm tree.  Its filename is
     zram-add-compact-sysfs-entry-to-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-compact-sysfs-entry-to-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-compact-sysfs-entry-to-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
