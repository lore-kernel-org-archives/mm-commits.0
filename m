From: akpm@linux-foundation.org
Subject: [patch 069/101] mm/zsmalloc: add __init,__exit attribute
Date: Thu, 28 Jul 2016 15:47:57 -0700
Message-ID: <579a8b9d.a/tk6hNe+XpEoJ1F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcG1Wr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: add __init,__exit attribute

Add __init,__exit attribute for function that only called in
module init/exit to save memory.

Link: http://lkml.kernel.org/r/1467882338-4300-6-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-add-__init__exit-attribute mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-add-__init__exit-attribute
+++ a/mm/zsmalloc.c
@@ -1341,7 +1341,7 @@ static void zs_unregister_cpu_notifier(v
 	cpu_notifier_register_done();
 }
 
-static void init_zs_size_classes(void)
+static void __init init_zs_size_classes(void)
 {
 	int nr;
 
_
