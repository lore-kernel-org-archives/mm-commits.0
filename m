From: akpm@linux-foundation.org
Subject: [folded-merged] kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch removed from -mm tree
Date: Tue, 30 Apr 2013 15:19:46 -0700
Message-ID: <20130430221947.0F7525A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:60633 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab3D3WTs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 18:19:48 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so114218yen.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 15:19:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, arnd@arndb.de, rdunlap@infradead.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig-consolidate-config_debug_strict_user_copy_checks-fix
has been removed from the -mm tree.  Its filename was
     kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch

This patch was dropped because it was folded into kconfig-consolidate-config_debug_strict_user_copy_checks.patch

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
 	 earlycpio.o
 
-lib-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch

