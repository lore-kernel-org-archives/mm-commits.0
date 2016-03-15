From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch removed from
 -mm tree
Date: Tue, 15 Mar 2016 14:43:38 -0700
Message-ID: <56e8820a.8bLlunXNU6cAaoOE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbcCOVnj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, keescook@chromium.org, linux@roeck-us.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5
has been removed from the -mm tree.  Its filename was
     x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch

This patch was dropped because it was folded into x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig            |    4 ++++
 scripts/link-vmlinux.sh |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN init/Kconfig~x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5 init/Kconfig
--- a/init/Kconfig~x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5
+++ a/init/Kconfig
@@ -1442,6 +1442,10 @@ config KALLSYMS_ALL
 
 	   Say N unless you really need all symbols.
 
+config KALLSYMS_ABSOLUTE_PERCPU
+	bool
+	default X86_64 && SMP
+
 config PRINTK
 	default y
 	bool "Enable support for printk" if EXPERT
diff -puN scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5 scripts/link-vmlinux.sh
--- a/scripts/link-vmlinux.sh~x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5
+++ a/scripts/link-vmlinux.sh
@@ -86,7 +86,7 @@ kallsyms()
 		kallsymopt="${kallsymopt} --page-offset=$CONFIG_PAGE_OFFSET"
 	fi
 
-	if [ -n "${CONFIG_X86_64}" ] && [ -n "${CONFIG_SMP}" ]; then
+	if [ -n "${CONFIG_KALLSYMS_ABSOLUTE_PERCPU}" ]; then
 		kallsymopt="${kallsymopt} --absolute-percpu"
 	fi
 
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch

