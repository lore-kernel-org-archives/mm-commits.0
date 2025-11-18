Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A24331ED80
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763488306; cv=none; b=ZMdG18+4st2HpP5CFBwIxrIh1RgCcgsZh0X1ZcX25z4v98EqVJABn/eFQiQNdvk9SFxORUfT0KDbMEUcIGsFBf3K4XtT1rHL5WdkhrmptKYcOS6RrOkbTmdc4ESagtQUF8rfKtlj4z9I6HhmEdSAOoaJLSX+CL5mqt6wY4POUoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763488306; c=relaxed/simple;
	bh=ubwHY1Y8R+/gZZkcl0g8K4WMuNpWAbV5WP8FQvEFBuI=;
	h=Date:To:From:Subject:Message-Id; b=EkRnHOXZdLRAqo0Y910et2f1GpnZpNal5xoaS+wnbHRhZfFlXOQ1oD20QGIpf3QcEThNvBnvOOtngdsrUpZR1dWMR5Ca7WjPo81FBfiEIgMJLbMMN8AefYBD1Kv80zio8VMrNXuyDaUGRHdWmiM3hEBjFIoKtGFZMsR+GF8Ni6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ih51eBEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ih51eBEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C61CC2BC87;
	Tue, 18 Nov 2025 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763488305;
	bh=ubwHY1Y8R+/gZZkcl0g8K4WMuNpWAbV5WP8FQvEFBuI=;
	h=Date:To:From:Subject:From;
	b=ih51eBEmc7W9jWzoBVriYumJZngmsZ9xi4u7pezrM4y0Q7/i5iBkg/n8cJFB+MQMQ
	 xB7rMMLb3eUt+qRoPK3wwg6b8z/11EaEPxR5z2Msmcw8hTrPcY42nnUlnnVMU8KFl5
	 +6Z64KWkS+lavZvDZcQZxqYlxCoPuBCyVJAsg4y8=
Date: Tue, 18 Nov 2025 09:51:44 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-add-risc-v-svrsw60t59b-extension-support.patch added to mm-new branch
Message-Id: <20251118175145.3C61CC2BC87@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: add RISC-V Svrsw60t59b extension support
has been added to the -mm mm-new branch.  Its filename is
     riscv-add-risc-v-svrsw60t59b-extension-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-add-risc-v-svrsw60t59b-extension-support.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: riscv: add RISC-V Svrsw60t59b extension support
Date: Thu, 13 Nov 2025 15:28:03 +0800

The Svrsw60t59b extension allows to free the PTE reserved bits 60 and 59
for software to use.

Link: https://lkml.kernel.org/r/20251113072806.795029-4-zhangchunyan@iscas.ac.cn
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Deepak Gupta <debug@rivosinc.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Conor Dooley <conor.dooley@microchip.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig             |   14 ++++++++++++++
 arch/riscv/include/asm/hwcap.h |    1 +
 arch/riscv/kernel/cpufeature.c |    1 +
 3 files changed, 16 insertions(+)

--- a/arch/riscv/include/asm/hwcap.h~riscv-add-risc-v-svrsw60t59b-extension-support
+++ a/arch/riscv/include/asm/hwcap.h
@@ -106,6 +106,7 @@
 #define RISCV_ISA_EXT_ZAAMO		97
 #define RISCV_ISA_EXT_ZALRSC		98
 #define RISCV_ISA_EXT_ZICBOP		99
+#define RISCV_ISA_EXT_SVRSW60T59B	100
 
 #define RISCV_ISA_EXT_XLINUXENVCFG	127
 
--- a/arch/riscv/Kconfig~riscv-add-risc-v-svrsw60t59b-extension-support
+++ a/arch/riscv/Kconfig
@@ -849,6 +849,20 @@ config RISCV_ISA_ZICBOP
 
 	  If you don't know what to do here, say Y.
 
+config RISCV_ISA_SVRSW60T59B
+	bool "Svrsw60t59b extension support for using PTE bits 60 and 59"
+	depends on MMU && 64BIT
+	depends on RISCV_ALTERNATIVE
+	default y
+	help
+	  Adds support to dynamically detect the presence of the Svrsw60t59b
+	  extension and enable its usage.
+
+	  The Svrsw60t59b extension allows to free the PTE reserved bits 60
+	  and 59 for software to use.
+
+	  If you don't know what to do here, say Y.
+
 config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
 	def_bool y
 	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
--- a/arch/riscv/kernel/cpufeature.c~riscv-add-risc-v-svrsw60t59b-extension-support
+++ a/arch/riscv/kernel/cpufeature.c
@@ -539,6 +539,7 @@ const struct riscv_isa_ext_data riscv_is
 	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
 	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
 	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
+	__RISCV_ISA_EXT_DATA(svrsw60t59b, RISCV_ISA_EXT_SVRSW60T59B),
 	__RISCV_ISA_EXT_DATA(svvptc, RISCV_ISA_EXT_SVVPTC),
 };
 
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

mm-softdirty-add-pgtable_supports_soft_dirty.patch
mm-userfaultfd-add-pgtable_supports_uffd_wp.patch
riscv-add-risc-v-svrsw60t59b-extension-support.patch
riscv-mm-add-soft-dirty-page-tracking-support.patch
riscv-mm-add-userfaultfd-write-protect-support.patch
dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

