Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3317E78E79
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cl6gYfyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96741C433C7;
	Wed, 13 Dec 2023 20:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702498488;
	bh=6CGVwULgD1v/5xUuAq387Zqps2Kis51d+/H7x4H/CTo=;
	h=Date:To:From:Subject:From;
	b=cl6gYfyC7uZv2wCvD9/DDnpjhSWgCDJBmBASYQxmuclFOmiFxyNu4GpDbd1NC7BD7
	 J8F+vTNCpXuS5o5RlGNguqKinPD7aCs6yzj/teKQHm60wopX19ZWN/irc0nkfz3qoW
	 Ht0kdjRVOyLBiI831rEblF3Tb82YRUWlUDbP1PiI=
Date: Wed, 13 Dec 2023 12:14:48 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec_file-parisc-print-out-debugging-message-if-required.patch added to mm-unstable branch
Message-Id: <20231213201448.96741C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec_file, parisc: print out debugging message if required
has been added to the -mm mm-unstable branch.  Its filename is
     kexec_file-parisc-print-out-debugging-message-if-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec_file-parisc-print-out-debugging-message-if-required.patch

This patch will later appear in the mm-unstable branch at
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
Subject: kexec_file, parisc: print out debugging message if required
Date: Wed, 13 Dec 2023 13:57:47 +0800

Then when specifying '-d' for kexec_file_load interface, loaded locations
of kernel/initrd/cmdline etc can be printed out to help debug.

Here replace pr_debug() with the newly added kexec_dprintk() in kexec_file
loading related codes.

Link: https://lkml.kernel.org/r/20231213055747.61826-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Conor Dooley <conor@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/kexec_file.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/parisc/kernel/kexec_file.c~kexec_file-parisc-print-out-debugging-message-if-required
+++ a/arch/parisc/kernel/kexec_file.c
@@ -38,8 +38,8 @@ static void *elf_load(struct kimage *ima
 	for (i = 0; i < image->nr_segments; i++)
 		image->segment[i].mem = __pa(image->segment[i].mem);
 
-	pr_debug("Loaded the kernel at 0x%lx, entry at 0x%lx\n",
-		 kernel_load_addr, image->start);
+	kexec_dprintk("Loaded the kernel at 0x%lx, entry at 0x%lx\n",
+		      kernel_load_addr, image->start);
 
 	if (initrd != NULL) {
 		kbuf.buffer = initrd;
@@ -51,7 +51,7 @@ static void *elf_load(struct kimage *ima
 		if (ret)
 			goto out;
 
-		pr_debug("Loaded initrd at 0x%lx\n", kbuf.mem);
+		kexec_dprintk("Loaded initrd at 0x%lx\n", kbuf.mem);
 		image->arch.initrd_start = kbuf.mem;
 		image->arch.initrd_end = kbuf.mem + initrd_len;
 	}
@@ -68,7 +68,7 @@ static void *elf_load(struct kimage *ima
 		if (ret)
 			goto out;
 
-		pr_debug("Loaded cmdline at 0x%lx\n", kbuf.mem);
+		kexec_dprintk("Loaded cmdline at 0x%lx\n", kbuf.mem);
 		image->arch.cmdline = kbuf.mem;
 	}
 out:
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

