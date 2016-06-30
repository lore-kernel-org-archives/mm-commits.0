From: akpm@linux-foundation.org
Subject: + kasan-add-newline-to-messages.patch added to -mm tree
Date: Thu, 30 Jun 2016 09:52:27 -0700
Message-ID: <57754e4b.QAa3LaVri6EqC9AS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbcF3Qw3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jun 2016 12:52:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add newline to messages
has been added to the -mm tree.  Its filename is
     kasan-add-newline-to-messages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-newline-to-messages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-newline-to-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: add newline to messages

Currently GPF messages with KASAN look as follows:
kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
Add newlines.

Link: http://lkml.kernel.org/r/1467294357-98002-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kasan_init_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/kasan_init_64.c~kasan-add-newline-to-messages arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~kasan-add-newline-to-messages
+++ a/arch/x86/mm/kasan_init_64.c
@@ -54,8 +54,8 @@ static int kasan_die_handler(struct noti
 			     void *data)
 {
 	if (val == DIE_GPF) {
-		pr_emerg("CONFIG_KASAN_INLINE enabled");
-		pr_emerg("GPF could be caused by NULL-ptr deref or user memory access");
+		pr_emerg("CONFIG_KASAN_INLINE enabled\n");
+		pr_emerg("GPF could be caused by NULL-ptr deref or user memory access\n");
 	}
 	return NOTIFY_OK;
 }
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-add-newline-to-messages.patch

