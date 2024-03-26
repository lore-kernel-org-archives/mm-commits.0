Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6152140397
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711485007; cv=none; b=WSgx2Z/9iMWKO6gTv60PFPYa2csEFfFgcCmSNKWIXMDvKum2UqXRnfpXZqsDkzYYiN7PmiGerTKpIGJMPD/RWvXtT+WvIINJeXHVY7gzzjRm7VgGcLOnAh27V9eA9M9VsB8ByywG69J6ZsAJLj04oOdYePlo6zP4q/6wgbIdqYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711485007; c=relaxed/simple;
	bh=e4EDvJebQcqoZr6LUXaP3X7SRN4AKwaJl8HxOkW79p4=;
	h=Date:To:From:Subject:Message-Id; b=E5mt/3YKBv8Ezi6oW3oApmMxnPexaPSsoc1V9+hBYmxRNPRkCz8zs4Yxy4+k797hklI0xc1Z4JITELjS4bZ2f2PK2qVsyE6gPuyuz3yJhWl0ccTomRRJKOFzbVgpwEYnjIRSyFvkFgfMekgpvPEtrTnZuwTzLpDw9aJO4pUJbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=egc8R4Qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="egc8R4Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBD9C433C7;
	Tue, 26 Mar 2024 20:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711485006;
	bh=e4EDvJebQcqoZr6LUXaP3X7SRN4AKwaJl8HxOkW79p4=;
	h=Date:To:From:Subject:From;
	b=egc8R4QmU++yQqS+8OfIjyegP2eLlhgijxj2pmtq5qPyeyfHXUOTs579QJBAw7TXj
	 2fccr28vyT4wzjd8I8RxKW0SH542I/b1WPRYZmNeT+s7gLJU6SBy6Yx30WHYm+ogzF
	 Ab7XFFfczexJij70s044ld0r1YECnXwR9tfawQ2s=
Date: Tue, 26 Mar 2024 13:30:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,oleksiy.avramchenko@sony.com,lstoakes@gmail.com,linux@roeck-us.net,hch@infradead.org,hca@linux.ibm.com,david@fromorbit.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-bail-out-early-in-find_vmap_area-if-vmap-is-not-init.patch added to mm-hotfixes-unstable branch
Message-Id: <20240326203006.5EBD9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmalloc: bail out early in find_vmap_area() if vmap is not init
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vmalloc-bail-out-early-in-find_vmap_area-if-vmap-is-not-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-bail-out-early-in-find_vmap_area-if-vmap-is-not-init.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: bail out early in find_vmap_area() if vmap is not init
Date: Sat, 23 Mar 2024 15:15:44 +0100

During the boot the s390 system triggers "spinlock bad magic" messages
if the spinlock debugging is enabled:

[    0.465445] BUG: spinlock bad magic on CPU#0, swapper/0
[    0.465490]  lock: single+0x1860/0x1958, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    0.466067] CPU: 0 PID: 0 Comm: swapper Not tainted 6.8.0-12955-g8e938e398669 #1
[    0.466188] Hardware name: QEMU 8561 QEMU (KVM/Linux)
[    0.466270] Call Trace:
[    0.466470]  [<00000000011f26c8>] dump_stack_lvl+0x98/0xd8
[    0.466516]  [<00000000001dcc6a>] do_raw_spin_lock+0x8a/0x108
[    0.466545]  [<000000000042146c>] find_vmap_area+0x6c/0x108
[    0.466572]  [<000000000042175a>] find_vm_area+0x22/0x40
[    0.466597]  [<000000000012f152>] __set_memory+0x132/0x150
[    0.466624]  [<0000000001cc0398>] vmem_map_init+0x40/0x118
[    0.466651]  [<0000000001cc0092>] paging_init+0x22/0x68
[    0.466677]  [<0000000001cbbed2>] setup_arch+0x52a/0x708
[    0.466702]  [<0000000001cb6140>] start_kernel+0x80/0x5c8
[    0.466727]  [<0000000000100036>] startup_continue+0x36/0x40

it happens because such system tries to access some vmap areas
whereas the vmalloc initialization is not even yet done:

[    0.465490] lock: single+0x1860/0x1958, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[    0.466067] CPU: 0 PID: 0 Comm: swapper Not tainted 6.8.0-12955-g8e938e398669 #1
[    0.466188] Hardware name: QEMU 8561 QEMU (KVM/Linux)
[    0.466270] Call Trace:
[    0.466470] dump_stack_lvl (lib/dump_stack.c:117)
[    0.466516] do_raw_spin_lock (kernel/locking/spinlock_debug.c:87 kernel/locking/spinlock_debug.c:115)
[    0.466545] find_vmap_area (mm/vmalloc.c:1059 mm/vmalloc.c:2364)
[    0.466572] find_vm_area (mm/vmalloc.c:3150)
[    0.466597] __set_memory (arch/s390/mm/pageattr.c:360 arch/s390/mm/pageattr.c:393)
[    0.466624] vmem_map_init (./arch/s390/include/asm/set_memory.h:55 arch/s390/mm/vmem.c:660)
[    0.466651] paging_init (arch/s390/mm/init.c:97)
[    0.466677] setup_arch (arch/s390/kernel/setup.c:972)
[    0.466702] start_kernel (init/main.c:899)
[    0.466727] startup_continue (arch/s390/kernel/head64.S:35)
[    0.466811] INFO: lockdep is turned off.
...
[    0.718250] vmalloc init - busy lock init 0000000002871860
[    0.718328] vmalloc init - busy lock init 00000000028731b8

Some background. It worked before because the lock that is in question
was statically defined and initialized. As of now, the locks and data
structures are initialized in the vmalloc_init() function.

To address that issue add the check whether the "vmap_initialized"
variable is set, if not find_vmap_area() bails out on entry returning NULL.

Link: https://lkml.kernel.org/r/20240323141544.4150-1-urezki@gmail.com
Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-bail-out-early-in-find_vmap_area-if-vmap-is-not-init
+++ a/mm/vmalloc.c
@@ -2343,6 +2343,9 @@ struct vmap_area *find_vmap_area(unsigne
 	struct vmap_area *va;
 	int i, j;
 
+	if (unlikely(!vmap_initialized))
+		return NULL;
+
 	/*
 	 * An addr_to_node_id(addr) converts an address to a node index
 	 * where a VA is located. If VA spans several zones and passed
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-bail-out-early-in-find_vmap_area-if-vmap-is-not-init.patch

