From: akpm@linux-foundation.org
Subject: + kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch added to -mm tree
Date: Thu, 14 Mar 2013 14:20:29 -0700
Message-ID: <20130314212029.6B74931C0AC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34427 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3CNVUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Mar 2013 17:20:30 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so267478vbi.3
        for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2013 14:20:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, arnd@arndb.de, rdunlap@infradead.org, sfr@canb.auug.org.au


The patch titled
     Subject: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
has been added to the -mm tree.  Its filename is
     kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: kconfig-consolidate-config_debug_strict_user_copy_checks-fix

>   CC [M]  fs/binfmt_misc.o
> In file included from arch/x86/include/asm/uaccess.h:537:0,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:8,
>                  from include/linux/pagemap.h:10,
>                  from fs/binfmt_misc.c:27:
> arch/x86/include/asm/uaccess_32.h: In function 'parse_command.part.1':
> arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct [enabled by default]

Hm.. That's because it's part of lib and not obj, right?

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks-fix lib/Makefile
--- a/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks-fix
+++ a/lib/Makefile
@@ -15,7 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o percpu-refcount.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
timer_list-split-timer_list_show_tickdevices-v4.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm-introduce-free_highmem_page-helper-to-free-highmem-pages-into-buddy-system.patch
mm-arm-use-free_highmem_page-to-free-highmem-pages-into-buddy-system.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch

