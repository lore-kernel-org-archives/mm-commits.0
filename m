Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4B826290;
	Thu,  4 Sep 2025 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944704; cv=none; b=dLIC5YArgpTCxNckuiHxp/aX1NyxWikXuYuYMJKqhWvpdPlCNXdog5s/xVGZw33SyIxjbU0TZ4vlxT4KEMSoVKXCmdDuj3moHs78pup9cmhdsM7Vy81S/UYvI3RXJYzzslPvxco0EQTxcI0+UhKjFM6jIOf3SN3XiNdMF2raRX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944704; c=relaxed/simple;
	bh=V7Q2JtIpHhRD/NfOi9KuqIDhB+ZSzPI6IdA676YAb18=;
	h=Date:To:From:Subject:Message-Id; b=Z8Cgex4FFZp1opl8yVyt+HFPd4frjpZTpmbiyjqL9liR45OnK62cQ7c+5TSq4yinv05O30oQPGgfGtVQuyx+u4FJExCP1PPzXeJxCc7YlN640H7Y4MZMiXID91cltXFPgj58XaX/qeYVkkqjhUWzRpeETTD7i6nnw+1pFvC2SCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ALI1t4zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ALI1t4zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7701BC4CEE7;
	Thu,  4 Sep 2025 00:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944703;
	bh=V7Q2JtIpHhRD/NfOi9KuqIDhB+ZSzPI6IdA676YAb18=;
	h=Date:To:From:Subject:From;
	b=ALI1t4zSjsYFLo9kl2M+ya67rmwp1aJkNvgxJd3TI0KOluZgE4UXcKwn1tEeSbpkr
	 3gtzdvyO3Pju2jOUejiwcia4E44keb+3kuWd8NiygrToA4xIJaHUJUIShthfFIdIZt
	 uRCQU9xouRl86cM1EgwZON4KOyQ/BpQr99zW2zBo=
Date: Wed, 03 Sep 2025 17:11:42 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,stable@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,coxu@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] riscv-kexec-initialize-kexec_buf-struct.patch removed from -mm tree
Message-Id: <20250904001143.7701BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: kexec: initialize kexec_buf struct
has been removed from the -mm tree.  Its filename was
     riscv-kexec-initialize-kexec_buf-struct.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: riscv: kexec: initialize kexec_buf struct
Date: Wed, 27 Aug 2025 03:42:22 -0700

The kexec_buf structure was previously declared without initialization.
commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
added a field that is always read but not consistently populated by all
architectures. This un-initialized field will contain garbage.

This is also triggering a UBSAN warning when the uninitialized data was
accessed:

	------------[ cut here ]------------
	UBSAN: invalid-load in ./include/linux/kexec.h:210:10
	load of value 252 is not a valid value for type '_Bool'

Zero-initializing kexec_buf at declaration ensures all fields are
cleanly set, preventing future instances of uninitialized memory being
used.

Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-2-1df9882bb01a@debian.org
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Breno Leitao <leitao@debian.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baoquan He <bhe@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/kernel/kexec_elf.c          |    4 ++--
 arch/riscv/kernel/kexec_image.c        |    2 +-
 arch/riscv/kernel/machine_kexec_file.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/riscv/kernel/kexec_elf.c~riscv-kexec-initialize-kexec_buf-struct
+++ a/arch/riscv/kernel/kexec_elf.c
@@ -28,7 +28,7 @@ static int riscv_kexec_elf_load(struct k
 	int i;
 	int ret = 0;
 	size_t size;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	const struct elf_phdr *phdr;
 
 	kbuf.image = image;
@@ -66,7 +66,7 @@ static int elf_find_pbase(struct kimage
 {
 	int i;
 	int ret;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	const struct elf_phdr *phdr;
 	unsigned long lowest_paddr = ULONG_MAX;
 	unsigned long lowest_vaddr = ULONG_MAX;
--- a/arch/riscv/kernel/kexec_image.c~riscv-kexec-initialize-kexec_buf-struct
+++ a/arch/riscv/kernel/kexec_image.c
@@ -41,7 +41,7 @@ static void *image_load(struct kimage *i
 	struct riscv_image_header *h;
 	u64 flags;
 	bool be_image, be_kernel;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	int ret;
 
 	/* Check Image header */
--- a/arch/riscv/kernel/machine_kexec_file.c~riscv-kexec-initialize-kexec_buf-struct
+++ a/arch/riscv/kernel/machine_kexec_file.c
@@ -261,7 +261,7 @@ int load_extra_segments(struct kimage *i
 	int ret;
 	void *fdt;
 	unsigned long initrd_pbase = 0UL;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	char *modified_cmdline = NULL;
 
 	kbuf.image = image;
_

Patches currently in -mm which might be from leitao@debian.org are


