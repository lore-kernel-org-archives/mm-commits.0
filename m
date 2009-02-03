From: akpm@linux-foundation.org
Subject: + uv-fix-header-struct-usage.patch added to -mm tree
Date: Mon, 02 Feb 2009 22:56:27 -0800
Message-ID: <200902030656.n136uRd4017424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbZBCG4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 01:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu


The patch titled
     uv: fix header struct usage
has been added to the -mm tree.  Its filename is
     uv-fix-header-struct-usage.patch

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
Subject: uv: fix header struct usage
From: Randy Dunlap <randy.dunlap@oracle.com>

arch/x86/include/asm/uv/uv.h:16: warning: 'struct mm_struct' declared inside parameter list
arch/x86/include/asm/uv/uv.h:16: warning: its scope is only this definition or declaration, which is probably not what you want

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/x86/include/asm/uv/uv.h~uv-fix-header-struct-usage arch/x86/include/asm/uv/uv.h
--- a/arch/x86/include/asm/uv/uv.h~uv-fix-header-struct-usage
+++ a/arch/x86/include/asm/uv/uv.h
@@ -3,6 +3,9 @@
 
 enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 
+struct cpumask;
+struct mm_struct;
+
 #ifdef CONFIG_X86_UV
 
 extern enum uv_system_type get_uv_system_type(void);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
maintainers-general-listsopenfabricsorg-is-moderated.patch
atyfb-fix-config_-namespace-violations.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver-dont-use-bus_id.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-fix.patch
atyfb-fix-header-file-trailing-whitespace.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

