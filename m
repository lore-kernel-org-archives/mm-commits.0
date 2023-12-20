Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38084F204
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKBwo7EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0D8C433CA;
	Wed, 20 Dec 2023 23:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113414;
	bh=8cpHTF0/oCY/EwGMuOttDyk6FVYEfHtCiXMC1kCmas0=;
	h=Date:To:From:Subject:From;
	b=nKBwo7EPLgNAvI/9TUYv23MGI75XZ3ontuBWywNyqtO1XW+TK/zlrcrMeU8MZsvYP
	 Vgy5LrMyAOPn8jDOwXlnmKAmfUGJoC1xfYQCixHAvw7cxxywqiTCEquVYEoKjwtx44
	 /DLD/j6ZMiFzlVwGY/xIAXGxvmA475Co+E0rHlps=
Date: Wed, 20 Dec 2023 15:03:33 -0800
To: mm-commits@vger.kernel.org,nathan@kernel.org,joe@perches.com,conor@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec_file-parisc-print-out-debugging-message-if-required.patch removed from -mm tree
Message-Id: <20231220230334.7D0D8C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec_file, parisc: print out debugging message if required
has been removed from the -mm tree.  Its filename was
     kexec_file-parisc-print-out-debugging-message-if-required.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


