Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD52D168BD;
	Thu, 17 Oct 2024 20:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729198339; cv=none; b=XaFXnIqayX/lAFa4a/HXwjnWFt0sYM/LS9JmAP5XemKjVIeXX1FOMYUqvYkRfAQ7Q2nNd7KoG9sG7wPPuIC8FIHiZav2IhuvVp4eGwJ4FtUlibrzdaoZmrLIe8GyJeHzuRzfsNXopcDHEmKz6l5cQvk9+ttWjbxNhT7tib0XS1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729198339; c=relaxed/simple;
	bh=2A2LtDgVVnlxC7k8bQwyi6wORTN/aqYrA+noOJgPyrk=;
	h=Date:To:From:Subject:Message-Id; b=ikga6vqKA6bInjkOKnb0xLkC4kdiFocoziV+xRwve3P23Hezd22Pla/ks4We7xHnHrpStjAE5oO0zDlA9McAfPM/Z/j8LX9DzW12izCPqHpSIR94FkH8iveIOXHsPU1NIjq3nJg7iuy9a/LIVpy7eapq929z7g+WT1qHtCIw4O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wezihhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wezihhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071DCC4CEC3;
	Thu, 17 Oct 2024 20:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729198339;
	bh=2A2LtDgVVnlxC7k8bQwyi6wORTN/aqYrA+noOJgPyrk=;
	h=Date:To:From:Subject:From;
	b=0wezihhvl+P2f5MawTXsxPRtDCpP9ZPCO2oIrYVVuxtxlkoIEw3gGakGoGHRUHebJ
	 enIGKOfCeINsGa4UYMTgfzzBxRUYH7tq6iH3zWyXVeWUftUpFNRSmG0fbu9abowVF5
	 WkVOXNwDq2HfzmaR4AFMvKl5dxb6xvEQAjOuA0Jc=
Date: Thu, 17 Oct 2024 13:52:18 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,tglx@linutronix.de,takahiro.akashi@linaro.org,stable@vger.kernel.org,mika.westerberg@linux.intel.com,ilpo.jarvinen@linux.intel.com,bhe@redhat.com,bhelgaas@google.com,andriy.shevchenko@linux.intel.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + resourcekexec-walk_system_ram_res_rev-must-retain-resource-flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20241017205219.071DCC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: resource,kexec: walk_system_ram_res_rev must retain resource flags
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     resourcekexec-walk_system_ram_res_rev-must-retain-resource-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/resourcekexec-walk_system_ram_res_rev-must-retain-resource-flags.patch

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
From: Gregory Price <gourry@gourry.net>
Subject: resource,kexec: walk_system_ram_res_rev must retain resource flags
Date: Thu, 17 Oct 2024 15:03:47 -0400

walk_system_ram_res_rev() erroneously discards resource flags when passing
the information to the callback.

This causes systems with IORESOURCE_SYSRAM_DRIVER_MANAGED memory to have
these resources selected during kexec to store kexec buffers if that
memory happens to be at placed above normal system ram.

This leads to undefined behavior after reboot.  If the kexec buffer is
never touched, nothing happens.  If the kexec buffer is touched, it could
lead to a crash (like below) or undefined behavior.

Tested on a system with CXL memory expanders with driver managed memory,
TPM enabled, and CONFIG_IMA_KEXEC=y.  Adding printk's showed the flags
were being discarded and as a result the check for
IORESOURCE_SYSRAM_DRIVER_MANAGED passes.

find_next_iomem_res: name(System RAM (kmem))
		     start(10000000000)
		     end(1034fffffff)
		     flags(83000200)

locate_mem_hole_top_down: start(10000000000) end(1034fffffff) flags(0)

[.] BUG: unable to handle page fault for address: ffff89834ffff000
[.] #PF: supervisor read access in kernel mode
[.] #PF: error_code(0x0000) - not-present page
[.] PGD c04c8bf067 P4D c04c8bf067 PUD c04c8be067 PMD 0
[.] Oops: 0000 [#1] SMP
[.] RIP: 0010:ima_restore_measurement_list+0x95/0x4b0
[.] RSP: 0018:ffffc900000d3a80 EFLAGS: 00010286
[.] RAX: 0000000000001000 RBX: 0000000000000000 RCX: ffff89834ffff000
[.] RDX: 0000000000000018 RSI: ffff89834ffff000 RDI: ffff89834ffff018
[.] RBP: ffffc900000d3ba0 R08: 0000000000000020 R09: ffff888132b8a900
[.] R10: 4000000000000000 R11: 000000003a616d69 R12: 0000000000000000
[.] R13: ffffffff8404ac28 R14: 0000000000000000 R15: ffff89834ffff000
[.] FS:  0000000000000000(0000) GS:ffff893d44640000(0000) knlGS:0000000000000000
[.] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[.] ata5: SATA link down (SStatus 0 SControl 300)
[.] CR2: ffff89834ffff000 CR3: 000001034d00f001 CR4: 0000000000770ef0
[.] PKRU: 55555554
[.] Call Trace:
[.]  <TASK>
[.]  ? __die+0x78/0xc0
[.]  ? page_fault_oops+0x2a8/0x3a0
[.]  ? exc_page_fault+0x84/0x130
[.]  ? asm_exc_page_fault+0x22/0x30
[.]  ? ima_restore_measurement_list+0x95/0x4b0
[.]  ? template_desc_init_fields+0x317/0x410
[.]  ? crypto_alloc_tfm_node+0x9c/0xc0
[.]  ? init_ima_lsm+0x30/0x30
[.]  ima_load_kexec_buffer+0x72/0xa0
[.]  ima_init+0x44/0xa0
[.]  __initstub__kmod_ima__373_1201_init_ima7+0x1e/0xb0
[.]  ? init_ima_lsm+0x30/0x30
[.]  do_one_initcall+0xad/0x200
[.]  ? idr_alloc_cyclic+0xaa/0x110
[.]  ? new_slab+0x12c/0x420
[.]  ? new_slab+0x12c/0x420
[.]  ? number+0x12a/0x430
[.]  ? sysvec_apic_timer_interrupt+0xa/0x80
[.]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[.]  ? parse_args+0xd4/0x380
[.]  ? parse_args+0x14b/0x380
[.]  kernel_init_freeable+0x1c1/0x2b0
[.]  ? rest_init+0xb0/0xb0
[.]  kernel_init+0x16/0x1a0
[.]  ret_from_fork+0x2f/0x40
[.]  ? rest_init+0xb0/0xb0
[.]  ret_from_fork_asm+0x11/0x20
[.]  </TASK>

Link: https://lore.kernel.org/all/20231114091658.228030-1-bhe@redhat.com/
Link: https://lkml.kernel.org/r/20241017190347.5578-1-gourry@gourry.net
Fixes: 7acf164b259d ("resource: add walk_system_ram_res_rev()")
Signed-off-by: Gregory Price <gourry@gourry.net>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/resource.c~resourcekexec-walk_system_ram_res_rev-must-retain-resource-flags
+++ a/kernel/resource.c
@@ -459,9 +459,7 @@ int walk_system_ram_res_rev(u64 start, u
 			rams_size += 16;
 		}
 
-		rams[i].start = res.start;
-		rams[i++].end = res.end;
-
+		rams[i++] = res;
 		start = res.end + 1;
 	}
 
_

Patches currently in -mm which might be from gourry@gourry.net are

resourcekexec-walk_system_ram_res_rev-must-retain-resource-flags.patch

