From: akpm@linux-foundation.org
Subject: [patch 2/7] kasan: change memory hot-add error messages to info
 messages
Date: Wed, 08 Jun 2016 15:33:45 -0700
Message-ID: <57589d49.2QhUCzoSH49MDpZ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271AbcFHWdq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2016 18:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shuahkh@osg.samsung.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: kasan: change memory hot-add error messages to info messages

Change the following memory hot-add error messages to info messages. 
There is no need for these to be errors.

[    8.221108] kasan: WARNING: KASAN doesn't support memory hot-add
[    8.221117] kasan: Memory hot-add will be disabled

Link: http://lkml.kernel.org/r/1464794430-5486-1-git-send-email-shuahkh@osg.samsung.com
Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-change-memory-hot-add-error-messages-to-info-messages mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-change-memory-hot-add-error-messages-to-info-messages
+++ a/mm/kasan/kasan.c
@@ -763,8 +763,8 @@ static int kasan_mem_notifier(struct not
 
 static int __init kasan_memhotplug_init(void)
 {
-	pr_err("WARNING: KASAN doesn't support memory hot-add\n");
-	pr_err("Memory hot-add will be disabled\n");
+	pr_info("WARNING: KASAN doesn't support memory hot-add\n");
+	pr_info("Memory hot-add will be disabled\n");
 
 	hotplug_memory_notifier(kasan_mem_notifier, 0);
 
_
