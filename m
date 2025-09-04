Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BE012CD88;
	Thu,  4 Sep 2025 00:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756944706; cv=none; b=NvuWMNYt/BI1V4wdBTf6ZG+Yu/JJYXxUMLOhAZIXql508fpz25cLFQReTsZ19rsPP9H+agRzFjYF5FvcuSCy2GJYDr44gc1RXOFO2OMFgDUB5ax73Tzqhq5uPVMBfiCcNPfP5lot5FnVIRGHK/Db9f6+9cNC+fCKKUyAvzbVEvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756944706; c=relaxed/simple;
	bh=ZjTi++VeW2Z/6D1JtWzpqKTXejIXWTDZ7aTvo8yRVb0=;
	h=Date:To:From:Subject:Message-Id; b=RL175ibuY6PchLdrWBysy0nqTZst8Ohpm2zjsVj9Pc1Ho5PcnqA2c4h5rrfC55jviR53RWXDvFCNYutqQCG50+f1JVxL1Xmh52uh55myI1PweKPolUjys9uSGu9JbBsCGIrYPjtXZgMPBsqiCnC3MRWAZ+Lv/pNq8c9wa2wKyn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K8SH7O2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K8SH7O2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B52AC4CEF4;
	Thu,  4 Sep 2025 00:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756944706;
	bh=ZjTi++VeW2Z/6D1JtWzpqKTXejIXWTDZ7aTvo8yRVb0=;
	h=Date:To:From:Subject:From;
	b=K8SH7O2WTxdkJSnrtg7Pk9ngRQVYjNX2ND4+YuDfE7ZNWbqBRERUKObiTYKD0tCr4
	 AgGOinuxm576OpzsfVFcH8/w8MidBPM3WmJaNDv0sdCecr/l7HZ80q17gApgbL867N
	 dibT/vs3SS3H1SYG3TRK2YT2GOU9XCVvBGWhGrE0=
Date: Wed, 03 Sep 2025 17:11:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,stable@vger.kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,coxu@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] s390-kexec-initialize-kexec_buf-struct.patch removed from -mm tree
Message-Id: <20250904001146.5B52AC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390: kexec: initialize kexec_buf struct
has been removed from the -mm tree.  Its filename was
     s390-kexec-initialize-kexec_buf-struct.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Breno Leitao <leitao@debian.org>
Subject: s390: kexec: initialize kexec_buf struct
Date: Wed, 27 Aug 2025 03:42:23 -0700

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

Link: https://lkml.kernel.org/r/20250827-kbuf_all-v1-3-1df9882bb01a@debian.org
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

 arch/s390/kernel/kexec_elf.c          |    2 +-
 arch/s390/kernel/kexec_image.c        |    2 +-
 arch/s390/kernel/machine_kexec_file.c |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/s390/kernel/kexec_elf.c~s390-kexec-initialize-kexec_buf-struct
+++ a/arch/s390/kernel/kexec_elf.c
@@ -16,7 +16,7 @@
 static int kexec_file_add_kernel_elf(struct kimage *image,
 				     struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	const Elf_Ehdr *ehdr;
 	const Elf_Phdr *phdr;
 	Elf_Addr entry;
--- a/arch/s390/kernel/kexec_image.c~s390-kexec-initialize-kexec_buf-struct
+++ a/arch/s390/kernel/kexec_image.c
@@ -16,7 +16,7 @@
 static int kexec_file_add_kernel_image(struct kimage *image,
 				       struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 
 	buf.image = image;
 
--- a/arch/s390/kernel/machine_kexec_file.c~s390-kexec-initialize-kexec_buf-struct
+++ a/arch/s390/kernel/machine_kexec_file.c
@@ -129,7 +129,7 @@ static int kexec_file_update_purgatory(s
 static int kexec_file_add_purgatory(struct kimage *image,
 				    struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	int ret;
 
 	buf.image = image;
@@ -152,7 +152,7 @@ static int kexec_file_add_purgatory(stru
 static int kexec_file_add_initrd(struct kimage *image,
 				 struct s390_load_data *data)
 {
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	int ret;
 
 	buf.image = image;
@@ -184,7 +184,7 @@ static int kexec_file_add_ipl_report(str
 {
 	__u32 *lc_ipl_parmblock_ptr;
 	unsigned int len, ncerts;
-	struct kexec_buf buf;
+	struct kexec_buf buf = {};
 	unsigned long addr;
 	void *ptr, *end;
 	int ret;
_

Patches currently in -mm which might be from leitao@debian.org are


