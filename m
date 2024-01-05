Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BF7358B0
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l3CfG5Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44932C433C8;
	Fri,  5 Jan 2024 18:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704480364;
	bh=7/gKJANNHxihgsq70+sF9IordKnXHaAuCqKCthajpJY=;
	h=Date:To:From:Subject:From;
	b=l3CfG5Sp8natTz1lC4cCvl/7vmjvYb200IdUFJ4NGXleMPGqXRU2gdX453czd4J4F
	 YuRjckTb5OC23N/Xce0qyfdCAYXY7gkmF1P8DUUGMFeI1S54USQ7i7ic9Hb/ueHdXE
	 ip1EQzM2oHYs0SfbB0/ZmXXqdaI7KGnXMIxN+60U=
Date: Fri, 05 Jan 2024 10:46:03 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,tiwai@suse.de,tglx@linutronix.de,sourabhjain@linux.ibm.com,mingo@redhat.com,hpa@zytor.com,hbathini@linux.ibm.com,dyoung@redhat.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch removed from -mm tree
Message-Id: <20240105184604.44932C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/crash: remove the unused image parameter from prepare_elf_headers()
has been removed from the -mm tree.  Its filename was
     x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/crash: remove the unused image parameter from prepare_elf_headers()
Date: Tue, 2 Jan 2024 22:49:03 +0800

Patch series "crash: Some cleanups and fixes", v2.

This patchset includes two cleanups and one fix.


This patch (of 3):

The image parameter is no longer in use, remove it.  Also, tidy up the
code formatting.

Link: https://lkml.kernel.org/r/20240102144905.110047-1-ytcoode@gmail.com
Link: https://lkml.kernel.org/r/20240102144905.110047-2-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/crash.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/crash.c~x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers
+++ a/arch/x86/kernel/crash.c
@@ -198,8 +198,8 @@ static int prepare_elf64_ram_headers_cal
 }
 
 /* Prepare elf headers. Return addr and size */
-static int prepare_elf_headers(struct kimage *image, void **addr,
-					unsigned long *sz, unsigned long *nr_mem_ranges)
+static int prepare_elf_headers(void **addr, unsigned long *sz,
+			       unsigned long *nr_mem_ranges)
 {
 	struct crash_mem *cmem;
 	int ret;
@@ -221,7 +221,7 @@ static int prepare_elf_headers(struct ki
 	*nr_mem_ranges = cmem->nr_ranges;
 
 	/* By default prepare 64bit headers */
-	ret =  crash_prepare_elf64_headers(cmem, IS_ENABLED(CONFIG_X86_64), addr, sz);
+	ret = crash_prepare_elf64_headers(cmem, IS_ENABLED(CONFIG_X86_64), addr, sz);
 
 out:
 	vfree(cmem);
@@ -349,7 +349,7 @@ int crash_load_segments(struct kimage *i
 				  .buf_max = ULONG_MAX, .top_down = false };
 
 	/* Prepare elf headers and add a segment */
-	ret = prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz, &pnum);
+	ret = prepare_elf_headers(&kbuf.buffer, &kbuf.bufsz, &pnum);
 	if (ret)
 		return ret;
 
@@ -452,7 +452,7 @@ void arch_crash_handle_hotplug_event(str
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (prepare_elf_headers(image, &elfbuf, &elfsz, &nr_mem_ranges)) {
+	if (prepare_elf_headers(&elfbuf, &elfsz, &nr_mem_ranges)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
_

Patches currently in -mm which might be from ytcoode@gmail.com are


