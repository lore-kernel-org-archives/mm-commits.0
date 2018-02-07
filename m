From: akpm@linux-foundation.org
Subject: [merged]
 kallsyms-let-print_ip_sym-print-raw-addresses.patch removed from -mm tree
Date: Wed, 07 Feb 2018 11:57:56 -0800
Message-ID: <20180207195756.H6LU20l4G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbeBGT55 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenhc@lemote.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, zhangfx@lemote.com


The patch titled
     Subject: kallsyms: let print_ip_sym() print raw addresses
has been removed from the -mm tree.  Its filename was
     kallsyms-let-print_ip_sym-print-raw-addresses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -167,7 +167,7 @@ static inline int kallsyms_show_value(vo
 
 static inline void print_ip_sym(unsigned long ip)
 {
-	printk("[<%p>] %pS\n", (void *) ip, (void *) ip);
+	printk("[<%px>] %pS\n", (void *) ip, (void *) ip);
 }
 
 #endif /*_LINUX_KALLSYMS_H*/
_

Patches currently in -mm which might be from chenhc@lemote.com are


