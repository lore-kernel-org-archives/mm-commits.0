Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E82D40858
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 18:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716576952; cv=none; b=dIHZ4LP0GTRuwEq9exoxdxk0DR1idUa1CZoRIAZGUh4qlSkoqkxubC5HfLeVU0rlGPG5oA5aA1r03+SM3Tenco0haDJaxDa48gePM5WiM6Q+5xIaP2XFgW4D/sa6UiS6Alj6rswmYBuvUaqKdanqwfT2M0HA2sdBn/Dza+WCQvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716576952; c=relaxed/simple;
	bh=d7dHt9xr6Fc5ovv6mOXPe1iPWS3TBvWtBl7NxLxL5s0=;
	h=Date:To:From:Subject:Message-Id; b=P8VuRWmv4AgKXdzI75CfK3nZJlqjK3OreAarQFrKmjncdYXqNM0JyuUHCT30UcCOnC/fcUxyDlbfrC2K4rqRtvrEt+7XWtAzTM+A+1L0+iVUs/4La0j3gGJ5U9Khc1KjUQ5T3H9A5M4WWZZv6/WKgG457lxVRfa7HuANKrEP6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CylkqGiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CylkqGiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E70C32789;
	Fri, 24 May 2024 18:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716576952;
	bh=d7dHt9xr6Fc5ovv6mOXPe1iPWS3TBvWtBl7NxLxL5s0=;
	h=Date:To:From:Subject:From;
	b=CylkqGiDtjB8xx6tBPgD3TJ/qg/uTmkNACr9eGcsiwKG6dMUPvuaSxEFauhiiUvEU
	 z51vSxxymn5VbLRG1U8URXAiuTyhP7fepk9AguPNfb1g0chItcEsq1RSZ5NHf17Nco
	 5nfWRCfJhWmC7vT1vgozQtPhUvFrIhHvBJ9kiq2M=
Date: Fri, 24 May 2024 11:55:51 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mcgrof@kernel.org,klarasmodin@gmail.com,bjorn@kernel.org,will@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-patching-fix-handling-of-execmem-addresses.patch removed from -mm tree
Message-Id: <20240524185552.19E70C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: patching: fix handling of execmem addresses
has been removed from the -mm tree.  Its filename was
     arm64-patching-fix-handling-of-execmem-addresses.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Will Deacon <will@kernel.org>
Subject: arm64: patching: fix handling of execmem addresses
Date: Wed, 22 May 2024 00:38:13 +0300

Klara Modin reported warnings for a kernel configured with BPF_JIT but
without MODULES:

[   44.131296] Trying to vfree() bad address (000000004a17c299)
[   44.138024] WARNING: CPU: 1 PID: 193 at mm/vmalloc.c:3189 remove_vm_area (mm/vmalloc.c:3189 (discriminator 1))
[   44.146675] CPU: 1 PID: 193 Comm: kworker/1:2 Tainted: G      D W          6.9.0-01786-g2c9e5d4a0082 #25
[   44.158229] Hardware name: Raspberry Pi 3 Model B (DT)
[   44.164433] Workqueue: events bpf_prog_free_deferred
[   44.170492] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   44.178601] pc : remove_vm_area (mm/vmalloc.c:3189 (discriminator 1))
[   44.183705] lr : remove_vm_area (mm/vmalloc.c:3189 (discriminator 1))
[   44.188772] sp : ffff800082a13c70
[   44.193112] x29: ffff800082a13c70 x28: 0000000000000000 x27: 0000000000000000
[   44.201384] x26: 0000000000000000 x25: ffff00003a44efa0 x24: 00000000d4202000
[   44.209658] x23: ffff800081223dd0 x22: ffff00003a198a40 x21: ffff8000814dd880
[   44.217924] x20: 00000000d4202000 x19: ffff8000814dd880 x18: 0000000000000006
[   44.226206] x17: 0000000000000000 x16: 0000000000000020 x15: 0000000000000002
[   44.234460] x14: ffff8000811a6370 x13: 0000000020000000 x12: 0000000000000000
[   44.242710] x11: ffff8000811a6370 x10: 0000000000000144 x9 : ffff8000811fe370
[   44.250959] x8 : 0000000000017fe8 x7 : 00000000fffff000 x6 : ffff8000811fe370
[   44.259206] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
[   44.267457] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000002203240
[   44.275703] Call trace:
[   44.279158] remove_vm_area (mm/vmalloc.c:3189 (discriminator 1))
[   44.283858] vfree (mm/vmalloc.c:3322)
[   44.287835] execmem_free (mm/execmem.c:70)
[   44.292347] bpf_jit_free_exec+0x10/0x1c
[   44.297283] bpf_prog_pack_free (kernel/bpf/core.c:1006)
[   44.302457] bpf_jit_binary_pack_free (kernel/bpf/core.c:1195)
[   44.307951] bpf_jit_free (include/linux/filter.h:1083 arch/arm64/net/bpf_jit_comp.c:2474)
[   44.312342] bpf_prog_free_deferred (kernel/bpf/core.c:2785)
[   44.317785] process_one_work (kernel/workqueue.c:3273)
[   44.322684] worker_thread (kernel/workqueue.c:3342 (discriminator 2) kernel/workqueue.c:3429 (discriminator 2))
[   44.327292] kthread (kernel/kthread.c:388)
[   44.331342] ret_from_fork (arch/arm64/kernel/entry.S:861)

The problem is because bpf_arch_text_copy() silently fails to write to the
read-only area as a result of patch_map() faulting and the resulting
-EFAULT being chucked away.

Update patch_map() to use CONFIG_EXECMEM instead of
CONFIG_STRICT_MODULE_RWX to check for vmalloc addresses.

Link: https://lkml.kernel.org/r/20240521213813.703309-1-rppt@kernel.org
Fixes: 2c9e5d4a0082 ("bpf: remove CONFIG_BPF_JIT dependency on CONFIG_MODULES of")
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reported-by: Klara Modin <klarasmodin@gmail.com>
Closes: https://lore.kernel.org/all/7983fbbf-0127-457c-9394-8d6e4299c685@gmail.com
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/patching.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/patching.c~arm64-patching-fix-handling-of-execmem-addresses
+++ a/arch/arm64/kernel/patching.c
@@ -36,7 +36,7 @@ static void __kprobes *patch_map(void *a
 
 	if (image)
 		page = phys_to_page(__pa_symbol(addr));
-	else if (IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
+	else if (IS_ENABLED(CONFIG_EXECMEM))
 		page = vmalloc_to_page(addr);
 	else
 		return addr;
_

Patches currently in -mm which might be from will@kernel.org are


