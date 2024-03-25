Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51EC4DA18;
	Mon, 25 Mar 2024 20:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711398554; cv=none; b=dAgh7+ZmuFlqeBsxc9yziq70pE1oPmAMJOmZ+CaT7u22sI4OB75tI12q5J5Jvsdn3WXAKoA3lZmKh5wb3JFj/RAJWXoWcpn1Gcwr/msM+CQZCbcg6R7nz/x81Na/B0rQjMk/Spn5sZ1OkAwCMz0vFC1bh+neK02KLISRX74Lrho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711398554; c=relaxed/simple;
	bh=PvD6akxqXI8/dNMFrZHvCiPd/3vfM/WpSDW74xBnt+4=;
	h=Date:To:From:Subject:Message-Id; b=jCxdPcocAn9RvEVr3aSODg2TJZCjDtTwL8vBtzj/H6mi6RyYFpUmQsU71R0pkVBFXL29Vi2negFpnA0LnuwTpPr1TFjMlptN5ncqoxizR4SqEe+ejAzhXygTrd0ODQj9qbGPYexH6dnUDVhi1cp3ZJ80TMqze/C/BQTnKHbuj5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OdK1arWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OdK1arWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346C6C43390;
	Mon, 25 Mar 2024 20:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711398554;
	bh=PvD6akxqXI8/dNMFrZHvCiPd/3vfM/WpSDW74xBnt+4=;
	h=Date:To:From:Subject:From;
	b=OdK1arWFcKEtnTbBLG/S3JiZCgQHy7IaSJseo585fyMJOV7IppMnwiMAQ/oGRnE8g
	 p3XBX2dmXrbglgvKjd2ZUvsefFdTFJHQ1syVNT0ELh0OOgrDb6sNtStuSpLrsA07d9
	 CzkA+wplnN2ZkdrIuazFwtlFH1soqfll0yMi9oOI=
Date: Mon, 25 Mar 2024 13:29:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mingo@kernel.org,lihuafei1@huawei.com,jbohac@suse.cz,dyoung@redhat.com,chenhuacai@loongson.cn,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240325202914.346C6C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: use macro to add crashk_res into iomem early for specific arch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: crash: use macro to add crashk_res into iomem early for specific arch
Date: Mon, 25 Mar 2024 09:50:50 +0800

There are regression reports[1][2] that crashkernel region on x86_64 can't
be added into iomem tree sometime.  This causes the later failure of kdump
loading.

This happened after commit 4a693ce65b18 ("kdump: defer the insertion of
crashkernel resources") was merged.

Even though, these reported issues are proved to be related to other
component, they are just exposed after above commmit applied, I still
would like to keep crashk_res and crashk_low_res being added into iomem
early as before because the early adding has been always there on x86_64
and working very well.  For safety of kdump, Let's change it back.

Here, add a macro HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY to limit that
only ARCH defining the macro can have the early adding
crashk_res/_low_res into iomem. Then define
HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY on x86 to enable it.

Note: In reserve_crashkernel_low(), there's a remnant of crashk_low_res
handling which was mistakenly added back in commit 85fcde402db1 ("kexec:
split crashkernel reservation code out from crash_core.c").

[1]
[PATCH V2] x86/kexec: do not update E820 kexec table for setup_data
https://lore.kernel.org/all/Zfv8iCL6CT2JqLIC@darkstar.users.ipa.redhat.com/T/#u

[2]
Question about Address Range Validation in Crash Kernel Allocation
https://lore.kernel.org/all/4eeac1f733584855965a2ea62fa4da58@huawei.com/T/#u

Link: https://lkml.kernel.org/r/ZgDYemRQ2jxjLkq+@MiWiFi-R3L-srv
Fixes: 4a693ce65b18 ("kdump: defer the insertion of crashkernel resources")
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Li Huafei <lihuafei1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/crash_reserve.h |    2 ++
 kernel/crash_reserve.c               |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/arch/x86/include/asm/crash_reserve.h~crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch
+++ a/arch/x86/include/asm/crash_reserve.h
@@ -39,4 +39,6 @@ static inline unsigned long crash_low_si
 #endif
 }
 
+#define HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+
 #endif /* _X86_CRASH_RESERVE_H */
--- a/kernel/crash_reserve.c~crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch
+++ a/kernel/crash_reserve.c
@@ -366,8 +366,10 @@ static int __init reserve_crashkernel_lo
 
 	crashk_low_res.start = low_base;
 	crashk_low_res.end   = low_base + low_size - 1;
+#ifdef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 	insert_resource(&iomem_resource, &crashk_low_res);
 #endif
+#endif
 	return 0;
 }
 
@@ -448,8 +450,12 @@ retry:
 
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
+#ifdef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
+	insert_resource(&iomem_resource, &crashk_res);
+#endif
 }
 
+#ifndef HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY
 static __init int insert_crashkernel_resources(void)
 {
 	if (crashk_res.start < crashk_res.end)
@@ -462,3 +468,4 @@ static __init int insert_crashkernel_res
 }
 early_initcall(insert_crashkernel_resources);
 #endif
+#endif
_

Patches currently in -mm which might be from bhe@redhat.com are

crash-use-macro-to-add-crashk_res-into-iomem-early-for-specific-arch.patch
mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

