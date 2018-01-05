From: akpm@linux-foundation.org
Subject: [patch 6/9] mm/zsmalloc.c: include fs.h
Date: Thu, 04 Jan 2018 16:18:02 -0800
Message-ID: <5a4ec43a.4rDoGlDLC/ADlksA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35428 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbeAEASE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jan 2018 19:18:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky.work@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: mm/zsmalloc.c: include fs.h

`struct file_system_type' and alloc_anon_inode() function are defined in
fs.h, include it directly.

Link: http://lkml.kernel.org/r/20171219104219.3017-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zsmalloc.c~zsmalloc-add-fsh-include mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-add-fsh-include
+++ a/mm/zsmalloc.c
@@ -53,6 +53,7 @@
 #include <linux/mount.h>
 #include <linux/migrate.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 
 #define ZSPAGE_MAGIC	0x58
 
_
