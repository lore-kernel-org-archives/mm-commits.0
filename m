From: akpm@linux-foundation.org
Subject: + drivers-block-mg_diskc-make-mg_times_out-static.patch added to
 -mm tree
Date: Mon, 12 Aug 2013 15:54:51 -0700
Message-ID: <520967bb.bINy92Yw+m1qb7bm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57706 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab3HLWy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 18:54:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + drivers-block-mg_diskc-make-mg_times_out-static.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 15:54:51 -0700


The patch titled
     Subject: drivers/block/mg_disk.c: make mg_times_out() static
has been added to the -mm tree.  Its filename is
     drivers-block-mg_diskc-make-mg_times_out-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-mg_diskc-make-mg_times_out-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-mg_diskc-make-mg_times_out-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/block/mg_disk.c: make mg_times_out() static

mg_times_out() is used only in this file.  Fix the following sparse
warning:

drivers/block/mg_disk.c:639:6: warning: symbol 'mg_times_out' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/mg_disk.c~drivers-block-mg_diskc-make-mg_times_out-static drivers/block/mg_disk.c
--- a/drivers/block/mg_disk.c~drivers-block-mg_diskc-make-mg_times_out-static
+++ a/drivers/block/mg_disk.c
@@ -636,7 +636,7 @@ ok_to_write:
 		mg_request(host->breq);
 }
 
-void mg_times_out(unsigned long data)
+static void mg_times_out(unsigned long data)
 {
 	struct mg_host *host = (struct mg_host *)data;
 	char *name;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
block-replace-strict_strtoul-with-kstrtoul.patch
block-blk-sysfs-replace-strict_strtoul-with-kstrtoul.patch
drivers-block-mg_diskc-make-mg_times_out-static.patch
drivers-block-brdc-make-rd_size-static.patch
mm-replace-strict_strtoul-with-kstrtoul.patch
drivers-firmware-google-gsmic-replace-strict_strtoul-with-kstrtoul.patch
kernel-replace-strict_strto-with-kstrto.patch
documentation-replace-strict_strtoul-with-kstrtoul.patch
w1-replace-strict_strtol-with-kstrtol.patch

