Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAAF7404E
	for <mm-commits@vger.kernel.org>; Fri,  2 May 2025 00:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746146622; cv=none; b=PtYe+IUQdnVpAfKzs5g7tu/Azvjvig7e25F6Qqh//CRYvlcxIUuRObB61Z3W4vAFGfwnhguI9TlxdAMpBtK1LdEbrCVUtt9uYiu0go45pgCBRDc34RV1FnJ71PbK0op+Vtr9VLLedZgldRUFmi+2rWrWgehHQRRBr8ubP3qXa54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746146622; c=relaxed/simple;
	bh=lKBHMPgBcl1LBm6Q+nHC0PAp+vWNueZ2Ve+dJpbzVD4=;
	h=Date:To:From:Subject:Message-Id; b=KNvHBHH0FAEEcEX/38IJNeAYLsKkUZaTfazxvGiU97HxmShM5LpKX9AVBGRpQNLXNhHZbR22WdlXlMoAhtEQdc8RTK9SVqEZVUlwaNtRTnbixCU9QxEwVDc1yhz/s4G/o0dcyYZa2V3SMHCYTm9gl/tQL7UsspN97CSpjHrVidk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ksQkTM/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ksQkTM/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F671C4CEE3;
	Fri,  2 May 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746146622;
	bh=lKBHMPgBcl1LBm6Q+nHC0PAp+vWNueZ2Ve+dJpbzVD4=;
	h=Date:To:From:Subject:From;
	b=ksQkTM/veMfOqwsY2b5nkywygzXamIdST3fuawaE17hCyQfgxA1tJczljx0Sunnp/
	 snjsFMyqPVDscEk3bZHSDJLUCPRkIFilCWPUpUpqFgzYCsuBavv7nEIuquWYQjk/vj
	 3kU2vYac3TGphG41rgbDK7GWEaI3t7XvxkjOoQEM=
Date: Thu, 01 May 2025 17:43:41 -0700
To: mm-commits@vger.kernel.org,dave.hansen@linux.intel.com,changyuanl@google.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch added to mm-unstable branch
Message-Id: <20250502004342.3F671C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/setup: use memblock_reserve_kern for memory used by kernel
has been added to the -mm mm-unstable branch.  Its filename is
     x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/setup: use memblock_reserve_kern for memory used by kernel
Date: Thu, 1 May 2025 15:54:18 -0700

memblock_reserve() does not distinguish memory used by firmware from
memory used by kernel.

The distinction is nice to have for accounting of early memory allocations
and reservations, but it is essential for kexec handover (kho) to know how
much memory kernel consumes during boot.

Use memblock_reserve_kern() to reserve kernel memory, such as kernel
image, initrd and setup data.

Link: https://lkml.kernel.org/r/20250501225425.635167-12-changyuanl@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/setup.c~x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel
+++ a/arch/x86/kernel/setup.c
@@ -286,8 +286,8 @@ static void __init cleanup_highmap(void)
 static void __init reserve_brk(void)
 {
 	if (_brk_end > _brk_start)
-		memblock_reserve(__pa_symbol(_brk_start),
-				 _brk_end - _brk_start);
+		memblock_reserve_kern(__pa_symbol(_brk_start),
+				      _brk_end - _brk_start);
 
 	/* Mark brk area as locked down and no longer taking any
 	   new allocations */
@@ -360,7 +360,7 @@ static void __init early_reserve_initrd(
 	    !ramdisk_image || !ramdisk_size)
 		return;		/* No initrd provided by bootloader */
 
-	memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
+	memblock_reserve_kern(ramdisk_image, ramdisk_end - ramdisk_image);
 }
 
 static void __init reserve_initrd(void)
@@ -413,7 +413,7 @@ static void __init add_early_ima_buffer(
 	}
 
 	if (data->size) {
-		memblock_reserve(data->addr, data->size);
+		memblock_reserve_kern(data->addr, data->size);
 		ima_kexec_buffer_phys = data->addr;
 		ima_kexec_buffer_size = data->size;
 	}
@@ -553,7 +553,7 @@ static void __init memblock_x86_reserve_
 		len = sizeof(*data);
 		pa_next = data->next;
 
-		memblock_reserve(pa_data, sizeof(*data) + data->len);
+		memblock_reserve_kern(pa_data, sizeof(*data) + data->len);
 
 		if (data->type == SETUP_INDIRECT) {
 			len += data->len;
@@ -567,7 +567,7 @@ static void __init memblock_x86_reserve_
 			indirect = (struct setup_indirect *)data->data;
 
 			if (indirect->type != SETUP_INDIRECT)
-				memblock_reserve(indirect->addr, indirect->len);
+				memblock_reserve_kern(indirect->addr, indirect->len);
 		}
 
 		pa_data = pa_next;
@@ -770,8 +770,8 @@ static void __init early_reserve_memory(
 	 * __end_of_kernel_reserve symbol must be explicitly reserved with a
 	 * separate memblock_reserve() or they will be discarded.
 	 */
-	memblock_reserve(__pa_symbol(_text),
-			 (unsigned long)__end_of_kernel_reserve - (unsigned long)_text);
+	memblock_reserve_kern(__pa_symbol(_text),
+			      (unsigned long)__end_of_kernel_reserve - (unsigned long)_text);
 
 	/*
 	 * The first 4Kb of memory is a BIOS owned area, but generally it is
_

Patches currently in -mm which might be from rppt@kernel.org are

memblock-add-memblock_rsrv_kern-flag.patch
memblock-introduce-memmap_init_kho_scratch.patch
kexec-enable-kho-support-for-memory-preservation.patch
x86-setup-use-memblock_reserve_kern-for-memory-used-by-kernel.patch
documentation-kho-add-memblock-bindings.patch
execmem-enforce-allocation-size-aligment-to-page_size.patch

