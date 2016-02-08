From: akpm@linux-foundation.org
Subject: + x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
 added to -mm tree
Date: Mon, 08 Feb 2016 13:44:19 -0800
Message-ID: <56b90c33.HBHvaqUOQTNcq/0W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37955 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbcBHVoU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2016 16:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, keescook@chromium.org, linux@roeck-us.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5
has been added to the -mm tree.  Its filename is
     x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

extable-add-support-for-relative-extables-to-search-and-sort-routines.patch
alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch
arm64-switch-to-relative-exception-tables.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp-v5.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table-v5.patch
scripts-link-vmlinuxsh-force-error-on-kallsyms-failure.patch

