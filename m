From: akpm@linux-foundation.org
Subject: [patch 111/111] ipc: delete "nr_ipc_ns"
Date: Tue, 02 Aug 2016 14:07:32 -0700
Message-ID: <57a10b94.2jFn7YZRWyNBYb6l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbcHBVXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: ipc: delete "nr_ipc_ns"

Write-only variable.

Link: http://lkml.kernel.org/r/20160708214356.GA6785@p183.telecom.by
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ipc_namespace.h |    2 --
 ipc/msgutil.c                 |    2 --
 ipc/namespace.c               |    2 --
 3 files changed, 6 deletions(-)

diff -puN include/linux/ipc_namespace.h~ipc-delete-nr_ipc_ns include/linux/ipc_namespace.h
--- a/include/linux/ipc_namespace.h~ipc-delete-nr_ipc_ns
+++ a/include/linux/ipc_namespace.h
@@ -63,8 +63,6 @@ struct ipc_namespace {
 };
 
 extern struct ipc_namespace init_ipc_ns;
-extern atomic_t nr_ipc_ns;
-
 extern spinlock_t mq_lock;
 
 #ifdef CONFIG_SYSVIPC
diff -puN ipc/msgutil.c~ipc-delete-nr_ipc_ns ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-delete-nr_ipc_ns
+++ a/ipc/msgutil.c
@@ -37,8 +37,6 @@ struct ipc_namespace init_ipc_ns = {
 #endif
 };
 
-atomic_t nr_ipc_ns = ATOMIC_INIT(1);
