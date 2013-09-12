From: akpm@linux-foundation.org
Subject: [merged] drivers-block-mg_diskc-make-mg_times_out-static.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:05 -0700
Message-ID: <5232190d.AvncA/YWINXzB8QH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTmF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] drivers-block-mg_diskc-make-mg_times_out-static.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:05 -0700


The patch titled
     Subject: drivers/block/mg_disk.c: make mg_times_out() static
has been removed from the -mm tree.  Its filename was
     drivers-block-mg_diskc-make-mg_times_out-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
kernel-replace-strict_strto-with-kstrto.patch

