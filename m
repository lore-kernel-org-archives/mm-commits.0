Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBE910957
	for <mm-commits@vger.kernel.org>; Fri,  6 Dec 2024 01:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733447925; cv=none; b=B76Rxvdm+R4uf7EWUzK1cbRYhK0PxGDj/ozyOvoYztuqxL8iGrTu1UDZmVrc35ejrnU+1RbiyEohiL4gG15TekRyyMLWtYdTLjQcdE1YRXmh9bYbLoNsV2frojIJL4k0YhbO2NS6Ypo7uQpGgK34ANG17YwHrXKobyHxIRehZCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733447925; c=relaxed/simple;
	bh=6HKteAQ+mKLPMtloFCCioPxhtJOQXfP08SzjsdDhhcs=;
	h=Date:To:From:Subject:Message-Id; b=dCrUgo2jTaEhiUbE0Nmw/iIwzFA1gPQ0skRGukh+6jUuc3oR+RrW01RmP9guneiB94QMvnZEj0WJyclxlfWfEbRw/adlSdbavtak0MhEvdXZEhuFNBvh14euVa36qq2eQiDZamtMWVtutoerqxvxjWcl9/v+b079BaOSpPYwr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pP/GJEyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pP/GJEyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8554AC4CED1;
	Fri,  6 Dec 2024 01:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733447924;
	bh=6HKteAQ+mKLPMtloFCCioPxhtJOQXfP08SzjsdDhhcs=;
	h=Date:To:From:Subject:From;
	b=pP/GJEynLSAl/XQF7pBt+O8DuGR3KrQgoW9saP1yHXYqD3bdYg9gGl5mKjhke+a1G
	 gejAY0/GW+jct4hcwZ9ff4n65PorThLnFrYm70gxNXSKBbRXcaJ4Sv3dlv42wnOuW0
	 b0VOWiK7Cv60SjQg7U8Jw1G1EYNJu4I7xTSFX6eg=
Date: Thu, 05 Dec 2024 17:18:43 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,surenb@google.com,souravpanda@google.com,rppt@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,kent.overstreet@linux.dev,00107082@163.com,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-fix-module-allocation-tags-populated-area-calculation-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20241206011844.8554AC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/alloc_tag: fix vm_module_tags_populate's KASAN poisoning logic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-fix-module-allocation-tags-populated-area-calculation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-fix-module-allocation-tags-populated-area-calculation-fix.patch

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
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/alloc_tag: fix vm_module_tags_populate's KASAN poisoning logic
Date: Fri, 6 Dec 2024 01:05:28 +0800

After commit 233e89322cbe ("alloc_tag: fix module allocation tags
populated area calculation"), We still encountered a KASAN bug.

This is because we have only actually performed page allocation and
address mapping here.  we need to unpoisoned portions of underlying
memory.

Here is the log for KASAN:

[    5.041171][    T1] ==================================================================
[    5.042047][    T1] BUG: KASAN: vmalloc-out-of-bounds in move_module+0x2c0/0x708
[    5.042723][    T1] Write of size 240 at addr ffff80007e510000 by task systemd/1
[    5.043412][    T1]
[    5.043523][   T72] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:01.1/0000:02:001
[    5.043614][    T1] CPU: 0 UID: 0 PID: 1 Comm: systemd Not tainted 6.13.0-rc1+ #28
[    5.045560][    T1] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[    5.046328][    T1] Call trace:
[    5.046670][    T1]  show_stack+0x20/0x38 (C)
[    5.047127][    T1]  dump_stack_lvl+0x80/0xf8
[    5.047533][    T1]  print_address_description.constprop.0+0x58/0x358
[    5.048092][   T72] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Mouse [QEMU 0
[    5.048126][    T1]  print_report+0xb0/0x280
[    5.049682][    T1]  kasan_report+0xb8/0x108
[    5.050170][    T1]  kasan_check_range+0xe8/0x190
[    5.050685][    T1]  memcpy+0x58/0xa0
[    5.051135][    T1]  move_module+0x2c0/0x708
[    5.051586][    T1]  layout_and_allocate.constprop.0+0x308/0x5b8
[    5.052219][    T1]  load_module+0x134/0x16c8
[    5.052671][    T1]  init_module_from_file+0xdc/0x138
[    5.053193][    T1]  idempotent_init_module+0x344/0x600
[    5.053742][    T1]  __arm64_sys_finit_module+0xbc/0x150
[    5.054289][    T1]  invoke_syscall+0xd4/0x258
[    5.054749][    T1]  el0_svc_common.constprop.0+0xb4/0x240
[    5.055319][    T1]  do_el0_svc+0x48/0x68
[    5.055743][    T1]  el0_svc+0x40/0xe0
[    5.056142][    T1]  el0t_64_sync_handler+0x10c/0x138
[    5.056658][    T1]  el0t_64_sync+0x1ac/0x1b0

Link: https://lkml.kernel.org/r/20241205170528.81000-1-hao.ge@linux.dev
Fixes: 233e89322cbe ("alloc_tag: fix module allocation tags populated area calculation")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/lib/alloc_tag.c~alloc_tag-fix-module-allocation-tags-populated-area-calculation-fix
+++ a/lib/alloc_tag.c
@@ -424,6 +424,15 @@ static int vm_module_tags_populate(void)
 		vm_module_tags->nr_pages += nr;
 	}
 
+	/*
+	 * Mark the pages as accessible, now that they are mapped.
+	 * With hardware tag-based KASAN, marking is skipped for
+	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
+	 */
+	kasan_unpoison_vmalloc((void *)module_tags.start_addr,
+				new_end - module_tags.start_addr,
+				KASAN_VMALLOC_PROT_NORMAL);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from gehao@kylinos.cn are

alloc_tag-fix-module-allocation-tags-populated-area-calculation-fix.patch

