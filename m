From: akpm@linux-foundation.org
Subject: + vmcoreinfo-add-the-symbol-phys_base.patch added to -mm tree
Date: Tue, 01 Apr 2008 13:27:33 -0700
Message-ID: <200804012027.m31KRX04011718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197AbYDAU1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 16:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oomichi@mxs.nes.nec.co.jp, ebiederm@xmission.com, stable@kernel.org


The patch titled
     vmcoreinfo: add the symbol "phys_base"
has been added to the -mm tree.  Its filename is
     vmcoreinfo-add-the-symbol-phys_base.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmcoreinfo: add the symbol "phys_base"
From: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>

Fix the problem that makedumpfile sometimes fails on x86_64 machine.

This patch adds the symbol "phys_base" to a vmcoreinfo data.  The vmcoreinfo
data has the minimum debugging information only for dump filtering. 
makedumpfile (dump filtering command) gets it to distinguish unnecessary
pages, and makedumpfile creates a small dumpfile.

On x86_64 kernel which compiled with CONFIG_PHYSICAL_START=0x0 and
CONFIG_RELOCATABLE=y, makedumpfile fails like the following:

 # makedumpfile -d31 /proc/vmcore dumpfile
 The kernel version is not supported.
 The created dumpfile may be incomplete.
 _exclude_free_page: Can't get next online node.

 makedumpfile Failed.
 #

The cause is the lack of the symbol "phys_base" in a vmcoreinfo data.  If the
symbol "phys_base" does not exist, makedumpfile considers an x86_64 kernel as
non relocatable.  As the result, makedumpfile misunderstands the physical
address where the kernel is loaded, and it cannot translate a kernel virtual
address to physical address correctly.  To fix this proble, the attached patch
which adds the symbol "phys_base" to a vmcoreinfo data.

Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/kernel/machine_kexec_64.c~vmcoreinfo-add-the-symbol-phys_base arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~vmcoreinfo-add-the-symbol-phys_base
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -233,6 +233,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void arch_crash_save_vmcoreinfo(void)
 {
+	VMCOREINFO_SYMBOL(phys_base);
 	VMCOREINFO_SYMBOL(init_level4_pgt);
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from oomichi@mxs.nes.nec.co.jp are

vmcoreinfo-add-the-symbol-phys_base.patch
vmcoreinfo-add-page-flags-values.patch

