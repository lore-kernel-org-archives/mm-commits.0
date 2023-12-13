Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B018517C2
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoHrAeiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB0BC433C8;
	Wed, 13 Dec 2023 01:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430452;
	bh=/LoB+oM9cn/adp0WQ0WgJZpTQamVfU6N7qKgEf6Qp6o=;
	h=Date:To:From:Subject:From;
	b=EoHrAeiWKetu8mH4ayWaqxanrEIKEhTuyTpYOkrymXxtYl2IupbtJMTt+mh+jPuPk
	 JkRf1x8wT2elfkbjmXSRAE0FueT5K0UL17CFhkl+ntyFDJQ0An37Sjr5QZk4YXgYKg
	 swteuY4ZMe50XufNgUr48JfkVNZRnlKEY0NkT8y8=
Date: Tue, 12 Dec 2023 17:20:51 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,lkp@intel.com,ignat@cloudflare.com,eric_devolder@yahoo.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch removed from -mm tree
Message-Id: <20231213012052.6AB0BC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86, kexec: fix the wrong ifdeffery CONFIG_KEXEC
has been removed from the -mm tree.  Its filename was
     x86-kexec-fix-the-wrong-ifdeffery-config_kexec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kexec_file-add-kexec_file-flag-to-control-debug-printing.patch
kexec_file-print-out-debugging-message-if-required.patch
kexec_file-x86-print-out-debugging-message-if-required.patch
kexec_file-arm64-print-out-debugging-message-if-required.patch
kexec_file-ricv-print-out-debugging-message-if-required.patch
kexec_file-power-print-out-debugging-message-if-required.patch
kexec_file-parisc-print-out-debugging-message-if-required.patch
riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

