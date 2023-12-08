Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF27F50252
	for <mm-commits@vger.kernel.org>; Fri,  8 Dec 2023 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTyQk+30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B5BC433C7;
	Fri,  8 Dec 2023 19:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702065028;
	bh=dVrzWQhDJITGlS21feTjepBbDKMGRNluVsGg5FTGRaE=;
	h=Date:To:From:Subject:From;
	b=eTyQk+30j3o5iSO28LNFBQSacyFuFoQzSbKZs8s3afTlZCjCy+/lgChTvLtmyzhni
	 cHdJ/P3ofOl+/2w5GdbyABTkbK6MXCLQ4cb6xffN2W2U6r00GGjdiug+/aiYyxzVZn
	 8WX8YkrPKC/XsiiNJfxsFijFjwfhtCPmEf/aAw6o=
Date: Fri, 08 Dec 2023 11:50:27 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch added to mm-hotfixes-unstable branch
Message-Id: <20231208195028.12B5BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86, kexec: fix the wrong ifdeffery CONFIG_KEXEC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: x86, kexec: fix the wrong ifdeffery CONFIG_KEXEC
Date: Fri, 8 Dec 2023 15:30:36 +0800

With the current ifdeffery CONFIG_KEXEC, get_cmdline_acpi_rsdp() is only
available when kexec_load interface is taken, while kexec_file_load
interface can't make use of it.

Now change it to CONFIG_KEXEC_CORE.

Link: https://lkml.kernel.org/r/20231208073036.7884-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/boot/compressed/acpi.c~x86-kexec-fix-the-wrong-ifdeffery-config_kexec
+++ a/arch/x86/boot/compressed/acpi.c
@@ -178,7 +178,7 @@ static unsigned long get_cmdline_acpi_rs
 {
 	unsigned long addr = 0;
 
-#ifdef CONFIG_KEXEC
+#ifdef CONFIG_KEXEC_CORE
 	char val[MAX_ADDR_LEN] = { };
 	int ret;
 
_

Patches currently in -mm which might be from bhe@redhat.com are

riscv-fix-vmallc_start-definition.patch
loongarch-kexec-change-dependency-of-object-files.patch
m68k-kexec-fix-the-incorrect-ifdeffery-and-build-dependency-of-config_kexec.patch
mips-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
sh-kexec-fix-the-incorrect-ifdeffery-and-dependency-of-config_kexec.patch
x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch
resource-add-walk_system_ram_res_rev.patch
kexec_file-load-kernel-at-top-of-system-ram-if-required.patch
kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

