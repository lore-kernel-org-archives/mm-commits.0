Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163D30506A;
	Thu, 27 Nov 2025 19:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764272230; cv=none; b=qcG7EJ+bde5qavfIGLzXb8jFZAKyZ66NCCySLlgrI/0fzVF7lkr+Yzhv8u2mrjdxFnAuRRjnJG1mkbsn6FE/Kl1TC4dgMcy+HWrDKSRn/VrN0lS/9FtxzLV0hUV/zePALEX9V3+nh3PjPT8tdN1I49eBnFkqh+yab+eB1f53HMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764272230; c=relaxed/simple;
	bh=oFv6rFYosJ9FFGLFKn092gXULUdhZUkpj+COxCMFt9Q=;
	h=Date:To:From:Subject:Message-Id; b=oBUQ9I8TURKjQOJ9HBdy347OtrYNHxY5ka5FbkBc9phy/YvO9RQg8FsycCefjBG1OqGrvtpvE0qinB8vTmpsvt5D7J3dELxgayjMj/z5KxF2sZ6sJaQBmqYwlzz80Bvi8YJWISAZiyaQch2k2NrsYkfHIvHLPqt5HseybVS5ywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CQqGlVCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CQqGlVCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B9C4CEFB;
	Thu, 27 Nov 2025 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764272230;
	bh=oFv6rFYosJ9FFGLFKn092gXULUdhZUkpj+COxCMFt9Q=;
	h=Date:To:From:Subject:From;
	b=CQqGlVCeSq8l0cJzn9iUI27qtZ9R+Y8XtjMLHwy58pshYHoLmjZUh0ggTjRQ+o+vh
	 2Tk5KdhzsQw2pyHKVo6Y24WQVf1/CsLdgFCO6JSHKUwLNag1LjJMDksOnz39DAZGaT
	 uWgcFPM5MV9twHag7Tf+Ld6VlP5iJkZSE12UFGWs=
Date: Thu, 27 Nov 2025 11:37:10 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,leitao@debian.org,jpazdziora@redhat.com,coxu@redhat.com,catalin.marinas@arm.com,bhe@redhat.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-kernel-initialize-missing-kexec_buf-random-field.patch added to mm-hotfixes-unstable branch
Message-Id: <20251127193710.922B9C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: kernel: initialize missing kexec_buf->random field
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-kernel-initialize-missing-kexec_buf-random-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-kernel-initialize-missing-kexec_buf-random-field.patch

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
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: arm64: kernel: initialize missing kexec_buf->random field
Date: Thu, 27 Nov 2025 18:26:44 +0000

Commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
introduced the kexec_buf->random field to enable random placement of
kexec_buf.

However, this field was never properly initialized for kexec images that
do not need to be placed randomly, leading to the following UBSAN warning:

[  +0.364528] ------------[ cut here ]------------
[  +0.000019] UBSAN: invalid-load in ./include/linux/kexec.h:210:12
[  +0.000131] load of value 2 is not a valid value for type 'bool' (aka '_Bool')
[  +0.000003] CPU: 4 UID: 0 PID: 927 Comm: kexec Not tainted 6.18.0-rc7+ #3 PREEMPT(full)
[  +0.000002] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[  +0.000000] Call trace:
[  +0.000001]  show_stack+0x24/0x40 (C)
[  +0.000006]  __dump_stack+0x28/0x48
[  +0.000002]  dump_stack_lvl+0x7c/0xb0
[  +0.000002]  dump_stack+0x18/0x34
[  +0.000001]  ubsan_epilogue+0x10/0x50
[  +0.000002]  __ubsan_handle_load_invalid_value+0xc8/0xd0
[  +0.000003]  locate_mem_hole_callback+0x28c/0x2a0
[  +0.000003]  kexec_locate_mem_hole+0xf4/0x2f0
[  +0.000001]  kexec_add_buffer+0xa8/0x178
[  +0.000002]  image_load+0xf0/0x258
[  +0.000001]  __arm64_sys_kexec_file_load+0x510/0x718
[  +0.000002]  invoke_syscall+0x68/0xe8
[  +0.000001]  el0_svc_common+0xb0/0xf8
[  +0.000002]  do_el0_svc+0x28/0x48
[  +0.000001]  el0_svc+0x40/0xe8
[  +0.000002]  el0t_64_sync_handler+0x84/0x140
[  +0.000002]  el0t_64_sync+0x1bc/0x1c0

To address this, initialise kexec_buf->random field properly.

Link: https://lkml.kernel.org/r/20251127182644.1577592-1-yeoreum.yun@arm.com
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c        |    3 +++
 arch/arm64/kernel/machine_kexec_file.c |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/kexec_image.c~arm64-kernel-initialize-missing-kexec_buf-random-field
+++ a/arch/arm64/kernel/kexec_image.c
@@ -76,6 +76,9 @@ static void *image_load(struct kimage *i
 	kbuf.buf_min = 0;
 	kbuf.buf_max = ULONG_MAX;
 	kbuf.top_down = false;
+#ifdef CONFIG_CRASH_DUMP
+	kbuf.random = false;
+#endif
 
 	kbuf.buffer = kernel;
 	kbuf.bufsz = kernel_len;
--- a/arch/arm64/kernel/machine_kexec_file.c~arm64-kernel-initialize-missing-kexec_buf-random-field
+++ a/arch/arm64/kernel/machine_kexec_file.c
@@ -94,7 +94,11 @@ int load_other_segments(struct kimage *i
 			char *initrd, unsigned long initrd_len,
 			char *cmdline)
 {
-	struct kexec_buf kbuf = {};
+	struct kexec_buf kbuf = {
+#ifdef CONFIG_CRASH_DUMP
+		.random = false,
+#endif
+	};
 	void *dtb = NULL;
 	unsigned long initrd_load_addr = 0, dtb_len,
 		      orig_segments = image->nr_segments;
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are

arm64-kernel-initialize-missing-kexec_buf-random-field.patch

