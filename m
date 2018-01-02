From: akpm@linux-foundation.org
Subject: + kallsyms-let-print_ip_sym-print-raw-addresses.patch added to
 -mm tree
Date: Tue, 02 Jan 2018 15:44:29 -0800
Message-ID: <5a4c195d.hSv1NmCe5DWjN65h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbeABXob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 18:44:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenhc@lemote.com, keescook@chromium.org, me@tobin.cc, zhangfx@lemote.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kallsyms: let print_ip_sym() print raw addresses
has been added to the -mm tree.  Its filename is
     kallsyms-let-print_ip_sym-print-raw-addresses.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kallsyms-let-print_ip_sym-print-raw-addresses.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kallsyms-let-print_ip_sym-print-raw-addresses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huacai Chen <chenhc@lemote.com>
Subject: kallsyms: let print_ip_sym() print raw addresses

print_ip_sym() is mostly used for debugging, so I think it should print
the raw addresses.

Link: http://lkml.kernel.org/r/1514519382-405-1-git-send-email-chenhc@lemote.com
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: "Tobin C. Harding" <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kallsyms.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kallsyms.h~kallsyms-let-print_ip_sym-print-raw-addresses include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~kallsyms-let-print_ip_sym-print-raw-addresses
+++ a/include/linux/kallsyms.h
@@ -131,7 +131,7 @@ static inline void print_symbol(const ch
 
 static inline void print_ip_sym(unsigned long ip)
 {
-	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
+	printk("[<%px>] %pS\n", (void *) ip, (void *) ip);
 }
 
 #endif /*_LINUX_KALLSYMS_H*/
_

Patches currently in -mm which might be from chenhc@lemote.com are

kallsyms-let-print_ip_sym-print-raw-addresses.patch

