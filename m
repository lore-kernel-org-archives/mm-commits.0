From: akpm@linux-foundation.org
Subject: [patch 056/114] kallsyms: let print_ip_sym() print raw
 addresses
Date: Tue, 06 Feb 2018 15:39:18 -0800
Message-ID: <20180206233918.p9X19aJbw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chenhc@lemote.com, keescook@chromium.org, me@tobin.cc, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, zhangfx@lemote.com

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
