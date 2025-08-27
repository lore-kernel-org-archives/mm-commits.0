Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029566FC5
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 23:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756336166; cv=none; b=IM0JVvPyZMbuqLKcWY9S8C3hK9qgYmnzK7UHsJDZmpgF1/DqRgUwH1EhWOEvM6fGbb0WA+ZuLa/ypklOAbRTHcsVzRo6W5nQYG9G3jtGlRFqmDE3K+tV4j2V5QiDFTxaC2t2o41mtuAaswxEXuMHHME+SjDC/ZX7Vq+simv5YwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756336166; c=relaxed/simple;
	bh=TMF09TL4vTYplJsSbseoNmi5SQoehML6d/uHfgZhRbc=;
	h=Date:To:From:Subject:Message-Id; b=MA2Qx/me3jWU/Get23cDq75im1pzBVLOq2fE+Stmy3q9+RnxzhRf/tYGsb55MMaj8RY1USiYND/b9Q+QNdXw1Asg9xpxUcchdzvyVPdaQvtJEiWivycrwdegc6I+lpIH9f/+cQZ7k6+eaPX+6rI1ce7Q2wSWa8TyT9E46R4i+Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LiVcGl75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LiVcGl75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A186C4CEEB;
	Wed, 27 Aug 2025 23:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756336165;
	bh=TMF09TL4vTYplJsSbseoNmi5SQoehML6d/uHfgZhRbc=;
	h=Date:To:From:Subject:From;
	b=LiVcGl75fRV7tPtLLyyMbE9PxKtNF/6P3kljxc3hQa+nkOGvJFf4iIdrjNS9pLWeL
	 BhZjwCMBdhBcfpH3hF8NIPq3t2x/QgnhU8lxE25Fl38JdQvPikLgmwNIYIax3+US33
	 owTGMczII+n2XCVaYet/I/ggUA6ZKWLQ8iNVU3hk=
Date: Wed, 27 Aug 2025 16:09:24 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,svens@linux.ibm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,hca@linux.ibm.com,gor@linux.ibm.com,coxu@redhat.com,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-kexec-initialize-kexec_buf-struct.patch added to mm-hotfixes-unstable branch
Message-Id: <20250827230925.6A186C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390: kexec: initialize kexec_buf struct
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     s390-kexec-initialize-kexec_buf-struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-kexec-initialize-kexec_buf-struct.patch

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

arm64-kexec-initialize-kexec_buf-struct-in-image_load.patch
arm64-kexec-initialize-kexec_buf-struct-in-load_other_segments.patch
riscv-kexec-initialize-kexec_buf-struct.patch
s390-kexec-initialize-kexec_buf-struct.patch

