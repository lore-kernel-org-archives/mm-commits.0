Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF78B4F212
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DsxaBlUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764A0C433C7;
	Wed, 20 Dec 2023 23:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113415;
	bh=jlWmF7xnbTMgD0bedqvT73P5lxFuW6svSmj/pLY/vTg=;
	h=Date:To:From:Subject:From;
	b=DsxaBlUpbi//pTGi7S73dOjmhwCpv1I2S095iAvzUS4SqlxsiMWoZK2POV8oxrMKs
	 r0mEmHj54QkrG/mBzJuD6nnIxqgNs1OJnzM0krefVeRGI5BWx9xZ2V20f/AwpNo8k2
	 a+buhOT2m0KQe/5WJ9U+kZd1+lAIU3tiV9q/hnqg=
Date: Wed, 20 Dec 2023 15:03:34 -0800
To: mm-commits@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mick@ics.forth.gr,changbin.du@intel.com,aou@eecs.berkeley.edu,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch removed from -mm tree
Message-Id: <20231220230335.764A0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv, kexec: fix the ifdeffery for AFLAGS_kexec_relocate.o
has been removed from the -mm tree.  Its filename was
     riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: riscv, kexec: fix the ifdeffery for AFLAGS_kexec_relocate.o
Date: Fri, 1 Dec 2023 14:25:38 +0800

This was introduced in commit fba8a8674f68 ("RISC-V: Add kexec
support").

It should work on CONFIG_KEXEC_CORE, but not CONFIG_KEXEC only, since
we could set CONFIG_KEXEC_FILE=y and CONFIG_KEXEC=N, or only set
CONFIG_CRASH_DUMP=y and disable both CONFIG_KEXEC and CONFIG_KEXEC_FILE.
In these cases, the AFLAGS won't take effect with the current ifdeffery
for AFLAGS_kexec_relocate.o.

So fix it now.

Link: https://lkml.kernel.org/r/20231201062538.27240-1-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Nick Kossifidis <mick@ics.forth.gr>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/Makefile~riscv-kexec-fix-the-ifdeffery-for-aflags_kexec_relocateo
+++ a/arch/riscv/kernel/Makefile
@@ -11,7 +11,7 @@ endif
 CFLAGS_syscall_table.o	+= $(call cc-option,-Wno-override-init,)
 CFLAGS_compat_syscall_table.o += $(call cc-option,-Wno-override-init,)
 
-ifdef CONFIG_KEXEC
+ifdef CONFIG_KEXEC_CORE
 AFLAGS_kexec_relocate.o := -mcmodel=medany $(call cc-option,-mno-relax)
 endif
 
_

Patches currently in -mm which might be from bhe@redhat.com are


