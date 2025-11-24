Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC533507C
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025866; cv=none; b=CcC6ox1cVz7AJXHDnGLkeyZs/RLqEyB9+AarK2bXF8NiVwVUbIMIkceyfXKAwSB4EcEh6v5nvXuPq/ns1s9aAKbm6wj4xYsGvSq+l41/aLJuNy0g2tKHRv2doTa3GNR2aPLjKJ0jXzn0BSKiEhLMjV5B4JF64rjzFm6P+huDI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025866; c=relaxed/simple;
	bh=9KunQo9Jutm/L2VWKdp4D2E7VhR3dhS/CuM9AR+xN74=;
	h=Date:To:From:Subject:Message-Id; b=os4oDPRhhbFoipAQ0H/kbliXkWUY12mSB+N5qR8fD0+AECXrexoLBIn49Ww/DW2urZlIvIPdS2FZavrp4saCrUm3zk7WT3/tN+2LPdWn5k59MGi3WLiNASTzEW0TbrgCKR8XMlyPKi/Y8fap6+U7oIKbNceX8MILZyRxD4DWnCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YnzNyfdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YnzNyfdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6465CC4CEF1;
	Mon, 24 Nov 2025 23:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025866;
	bh=9KunQo9Jutm/L2VWKdp4D2E7VhR3dhS/CuM9AR+xN74=;
	h=Date:To:From:Subject:From;
	b=YnzNyfdYevCfzNOCVwofWeBOQd0zM9tvIWx8LWHWx4ymohCkdEs9KCwI8NUrLxhMr
	 wbcrxenLdxfRKryuQjesjOrXKxje2p56Uf5LqF71TI4koc6j5Jm3nmHsXZKT03ku4b
	 dBmdD8UegIfZinjwemDQ7ouvfOJHWg3RaPtBFwiw=
Date: Mon, 24 Nov 2025 15:11:05 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-add-risc-v-svrsw60t59b-extension-support.patch removed from -mm tree
Message-Id: <20251124231106.6465CC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: add RISC-V Svrsw60t59b extension support
has been removed from the -mm tree.  Its filename was
     riscv-add-risc-v-svrsw60t59b-extension-support.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


