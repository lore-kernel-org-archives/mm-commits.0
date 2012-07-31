From: akpm@linux-foundation.org
Subject: [merged] kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:19 -0700
Message-ID: <20120731184919.B25F110007F@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab2GaStU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:20 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kay@vrfy.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure
has been removed from the -mm tree.  Its filename was
     kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kay Sievers <kay@vrfy.org>
Subject: kmsg: /dev/kmsg - properly return possible copy_from_user() failure

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/printk.c~kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure kernel/printk.c
--- a/kernel/printk.c~kmsg-dev-kmsg-properly-return-possible-copy_from_user-failure
+++ a/kernel/printk.c
@@ -389,8 +389,10 @@ static ssize_t devkmsg_writev(struct kio
 
 	line = buf;
 	for (i = 0; i < count; i++) {
-		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len))
+		if (copy_from_user(line, iv[i].iov_base, iv[i].iov_len)) {
+			ret = -EFAULT;
 			goto out;
+		}
 		line += iv[i].iov_len;
 	}
 
_

Patches currently in -mm which might be from kay@vrfy.org are

origin.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use.patch
dynamic_debug-restore-dev_dbg-netdev_dbg-functionality-reduce-stack-use-v2.patch

