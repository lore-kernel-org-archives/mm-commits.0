From: akpm@linux-foundation.org
Subject: + printk-fixup-declaration-of-kmsg_reasons.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:11:21 -0700
Message-ID: <201009212311.o8LNBLgf008378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158Ab0IUXLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, mingo@elte.hu


The patch titled
     printk: fixup declaration of kmsg_reasons
has been added to the -mm tree.  Its filename is
     printk-fixup-declaration-of-kmsg_reasons.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: fixup declaration of kmsg_reasons
From: Namhyung Kim <namhyung@gmail.com>

Move redundant 'const' after '*' to make pointer itself const

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk.c~printk-fixup-declaration-of-kmsg_reasons kernel/printk.c
--- a/kernel/printk.c~printk-fixup-declaration-of-kmsg_reasons
+++ a/kernel/printk.c
@@ -1511,7 +1511,7 @@ int kmsg_dump_unregister(struct kmsg_dum
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_unregister);
 
-static const char const *kmsg_reasons[] = {
+static const char * const kmsg_reasons[] = {
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

