Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7435C7640E;
	Tue,  6 Jan 2026 01:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767664324; cv=none; b=dLM9A4+W5UhUk7vN1ibcJJnYJZnhtoECzOKeHMltHy779eAynDeXsgOx/yzB7fRnXgERqvSx6KZiz+nzrtwmRg7elzny1+9Y21c4YcF81k082FSwS4QiiT4EvHjpbtFwc9XNe9sBzdgwyzlSrjYz+AnCKJlEUMhqn2luxona+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767664324; c=relaxed/simple;
	bh=8M9WRPosv+pmCUnT3zeKqoQ7dPSwfGhrEoTLfOqZu5M=;
	h=Date:To:From:Subject:Message-Id; b=IndA+XpibSsbbdi26c5+XBVmuzsyuPLqfBMmu2lNOQVbeXrZEx0xoCNQhdJMiowT3ckJs8paa7kgeRQ5Evm8pH2iEt9P4vZ/vncuiOxWRyndrMPG1snCwUZPXTC2cwI3P3UTk7MTQbvAZYdLiOilQ8LGX+xKZyxu8aRZQUU2O7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dIexnNYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dIexnNYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0C0C116D0;
	Tue,  6 Jan 2026 01:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767664324;
	bh=8M9WRPosv+pmCUnT3zeKqoQ7dPSwfGhrEoTLfOqZu5M=;
	h=Date:To:From:Subject:From;
	b=dIexnNYG1TggHmaSA3WWCn0hcuI6Dy0pdrfcwoXoa0SwIFLT+PP/g0zWYEr5ReWV2
	 gwOYo1sXleXII6GEOfJE8ymwh80+pXgGbmneq05N5TV3RojPXgal0UfdQ9ctdjccgy
	 G1Q62T1yglhAEy2r8+SNEA4VEAae0NFSE7Hzv51Y=
Date: Mon, 05 Jan 2026 17:52:03 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,mark.rutland@arm.com,leitao@debian.org,coxu@redhat.com,catalin.marinas@arm.com,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arm64-kernel-initialize-missing-kexec_buf-random-field.patch removed from -mm tree
Message-Id: <20260106015204.2C0C0C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: kernel: initialize missing kexec_buf->random field
has been removed from the -mm tree.  Its filename was
     arm64-kernel-initialize-missing-kexec_buf-random-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: arm64: kernel: initialize missing kexec_buf->random field
Date: Mon, 1 Dec 2025 10:51:18 +0000

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

Link: https://lkml.kernel.org/r/20251201105118.2786335-1-yeoreum.yun@arm.com
Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Suggested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: levi.yun <yeoreum.yun@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/kexec_image.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/kexec_image.c~arm64-kernel-initialize-missing-kexec_buf-random-field
+++ a/arch/arm64/kernel/kexec_image.c
@@ -41,7 +41,7 @@ static void *image_load(struct kimage *i
 	struct arm64_image_header *h;
 	u64 flags, value;
 	bool be_image, be_kernel;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	unsigned long text_offset, kernel_segment_number;
 	struct kexec_segment *kernel_segment;
 	int ret;
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


