From: akpm@linux-foundation.org
Subject: + printk-remove-unnecessary-ifdef-config_printk.patch added to
 -mm tree
Date: Thu, 04 Aug 2016 14:25:10 -0700
Message-ID: <57a3b2b6.7ASA1hVJz99A0nc5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759019AbcHDVZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 17:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.ziegler@fau.de, bp@suse.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: remove unnecessary #ifdef CONFIG_PRINTK
has been added to the -mm tree.  Its filename is
     printk-remove-unnecessary-ifdef-config_printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-remove-unnecessary-ifdef-config_printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-remove-unnecessary-ifdef-config_printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Ziegler <andreas.ziegler@fau.de>
Subject: printk: remove unnecessary #ifdef CONFIG_PRINTK

In commit 874f9c7da9a4 ("printk: create pr_<level> functions") in
linux-next, new pr_level defines were added to printk.c.  These defines
are guarded by an #ifdef CONFIG_PRINTK - however, there is already a
surrounding #ifdef CONFIG_PRINTK starting a lot earlier in line 249 which
means the newly introduced #ifdef is unnecessary.

Let's remove it to avoid confusion.

Link: http://lkml.kernel.org/r/1470297129-28049-1-git-send-email-andreas.ziegler@fau.de
Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>
Cc: Joe Perches <joe@perches.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/printk/printk.c~printk-remove-unnecessary-ifdef-config_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-remove-unnecessary-ifdef-config_printk
+++ a/kernel/printk/printk.c
@@ -1930,7 +1930,6 @@ asmlinkage int printk_emit(int facility,
 }
 EXPORT_SYMBOL(printk_emit);
 
-#ifdef CONFIG_PRINTK
 #define define_pr_level(func, loglevel)				\
 asmlinkage __visible void func(const char *fmt, ...)		\
 {								\
@@ -1949,7 +1948,6 @@ define_pr_level(__pr_err, LOGLEVEL_ERR);
 define_pr_level(__pr_warn, LOGLEVEL_WARNING);
 define_pr_level(__pr_notice, LOGLEVEL_NOTICE);
 define_pr_level(__pr_info, LOGLEVEL_INFO);
-#endif
 
 int vprintk_default(int level, const char *fmt, va_list args)
 {
_

Patches currently in -mm which might be from andreas.ziegler@fau.de are

printk-remove-unnecessary-ifdef-config_printk.patch

