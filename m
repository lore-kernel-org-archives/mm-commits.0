Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D77310EA
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 01:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gLEy///y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75572C433C7;
	Wed, 13 Dec 2023 01:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702430443;
	bh=SrYzx2tUd+hVO66BGM5XjfMNX/IUxJgUqq6VuV5cHQY=;
	h=Date:To:From:Subject:From;
	b=gLEy///yCCBvWd06hYXn6mjb3hgYFQKJ0W8wUCTmNcEZ8IHh7+q+OLPrZMtqj4xJ1
	 0a9Z02jo8DHskv1Z+sNY48bLGKkpAVS/akKipDQ9Xt3k8JNwQ8n+obYn2vlrbD7XY/
	 MdVOR3KmKJfb1Gl+bW3zLeoY5pZlraCPd4fY89Y4=
Date: Tue, 12 Dec 2023 17:20:42 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,rdunlap@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,ignat@cloudflare.com,eric_devolder@yahoo.com,aou@eecs.berkeley.edu,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-fix-vmallc_start-definition.patch removed from -mm tree
Message-Id: <20231213012043.75572C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: fix VMALLOC_START definition
has been removed from the -mm tree.  Its filename was
     riscv-fix-vmallc_start-definition.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: riscv: fix VMALLOC_START definition
Date: Tue, 5 Dec 2023 11:02:55 +0800

When below config items are set, compiler complained:

--------------------
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
......
-----------------------

-------------------------------------------------------------------
arch/riscv/kernel/crash_core.c: In function 'arch_crash_save_vmcoreinfo':
arch/riscv/kernel/crash_core.c:11:58: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'int' [-Wformat=]
11 |         vmcoreinfo_append_str("NUMBER(VMALLOC_START)=0x%lx\n", VMALLOC_START);
   |                                                        ~~^
   |                                                          |
   |                                                          long unsigned int
   |                                                        %x
----------------------------------------------------------------------

This is because on riscv macro VMALLOC_START has different type when
CONFIG_MMU is set or unset.

arch/riscv/include/asm/pgtable.h:
--------------------------------------------------

Changing it to _AC(0, UL) in case CONFIG_MMU=n can fix the warning.

Link: https://lkml.kernel.org/r/ZW7OsX4zQRA3mO4+@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>	# build-tested
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/include/asm/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-fix-vmallc_start-definition
+++ a/arch/riscv/include/asm/pgtable.h
@@ -899,7 +899,7 @@ static inline pte_t pte_swp_clear_exclus
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
 #define TASK_SIZE		0xffffffffUL
-#define VMALLOC_START		0
+#define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
 #endif /* !CONFIG_MMU */
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

