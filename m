Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3023314267
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QCdbG1DX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4470C433C7;
	Fri, 29 Dec 2023 20:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703881405;
	bh=05MwZCBBc+wj+PYByN/3erhoIyYwXrsp9P74wIdlvZw=;
	h=Date:To:From:Subject:From;
	b=QCdbG1DXrIgXFQ3/XAZ2N/eSArXIQe/diGqW+i6jEoL3soflCI8K68wbdd4JUuq8p
	 FW0TIZf2WGmfsKwx97bmk4QWuTAitzcPF0gIFAXh9kqOwbTFhUU3Ucs+3+L10kJvZj
	 6C/ZT2shv/JU8kUD0vY3x5tsEGRSRD6KV9SJhv2E=
Date: Fri, 29 Dec 2023 12:23:25 -0800
To: mm-commits@vger.kernel.org,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch removed from -mm tree
Message-Id: <20231229202325.A4470C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kexec: fix incorrect argument passed to kexec_dprintk()
has been removed from the -mm tree.  Its filename was
     x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/kexec: fix incorrect argument passed to kexec_dprintk()
Date: Wed, 20 Dec 2023 23:41:05 +0800

kexec_dprintk() expects the last argument to be kbuf.memsz, but the actual
argument being passed is kbuf.bufsz.

Although these two values are currently equal, it is better to pass the
correct one, in case these two values become different in the future.

Link: https://lkml.kernel.org/r/20231220154105.215610-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kexec-bzimage64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kexec-bzimage64.c~x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk
+++ a/arch/x86/kernel/kexec-bzimage64.c
@@ -496,7 +496,7 @@ static void *bzImage64_load(struct kimag
 		goto out_free_params;
 	bootparam_load_addr = kbuf.mem;
 	kexec_dprintk("Loaded boot_param, command line and misc at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
-		      bootparam_load_addr, kbuf.bufsz, kbuf.bufsz);
+		      bootparam_load_addr, kbuf.bufsz, kbuf.memsz);
 
 	/* Load kernel */
 	kbuf.buffer = kernel + kern16_size;
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch

