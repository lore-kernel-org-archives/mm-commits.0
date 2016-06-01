From: akpm@linux-foundation.org
Subject: +
 kasan-change-memory-hot-add-error-messages-to-info-messages.patch added to
 -mm tree
Date: Wed, 01 Jun 2016 15:01:25 -0700
Message-ID: <574f5b35.n33o2/sAdGIsG3kF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbcFAWB0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 18:01:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkh@osg.samsung.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: change memory hot-add error messages to info messages
has been added to the -mm tree.  Its filename is
     kasan-change-memory-hot-add-error-messages-to-info-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-change-memory-hot-add-error-messages-to-info-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-change-memory-hot-add-error-messages-to-info-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from shuahkh@osg.samsung.com are

kasan-change-memory-hot-add-error-messages-to-info-messages.patch

