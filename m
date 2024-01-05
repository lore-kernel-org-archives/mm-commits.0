Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF642E84A
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2AiHYN9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1198C433C8;
	Fri,  5 Jan 2024 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704473441;
	bh=76Md/SXAupLILj/LL6pVcmJzWQW8pzAvErAQKK9m6oQ=;
	h=Date:To:From:Subject:From;
	b=2AiHYN9BGOFryr7dEKjsO/k9S6hVlrvsIF4iwaTpp1m7KKEjZ2A9J/o9wPde3VgKP
	 NNvEhw2w93H2H+vzxPMkTo6/eQZMxXNWwv1kGfhh0XBi8R60MCVrso0BmNCTMytLNX
	 mVf1yMSValf5riqmcGw5wljnqUYmy131NSgOdQBA=
Date: Fri, 05 Jan 2024 08:50:41 -0800
To: mm-commits@vger.kernel.org,thunder.leizhen@huawei.com,bhe@redhat.com,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kdump-defer-the-insertion-of-crashkernel-resources.patch added to mm-hotfixes-unstable branch
Message-Id: <20240105165041.A1198C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kdump: defer the insertion of crashkernel resources
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kdump-defer-the-insertion-of-crashkernel-resources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kdump-defer-the-insertion-of-crashkernel-resources.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: kdump: defer the insertion of crashkernel resources
Date: Fri, 29 Dec 2023 16:02:13 +0800

In /proc/iomem, sub-regions should be inserted after their parent,
otherwise the insertion of parent resource fails.  But after generic
crashkernel reservation applied, in both RISC-V and ARM64 (LoongArch will
also use generic reservation later on), crashkernel resources are inserted
before their parent, which causes the parent disappear in /proc/iomem.  So
we defer the insertion of crashkernel resources to an early_initcall().

1, Without 'crashkernel' parameter:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 90400000-fa17ffff : System RAM
   f6220000-f622ffff : Reserved
   f9ee0000-f9ee3fff : Reserved
   fa120000-fa17ffff : Reserved
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

2, With 'crashkernel' parameter, before this patch:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 e6200000-f61fffff : Crash kernel
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

3, With 'crashkernel' parameter, after this patch:

 100d0100-100d01ff : LOON0001:00
   100d0100-100d01ff : LOON0001:00 LOON0001:00
 100e0000-100e0bff : LOON0002:00
   100e0000-100e0bff : LOON0002:00 LOON0002:00
 1fe001e0-1fe001e7 : serial
 90400000-fa17ffff : System RAM
   e6200000-f61fffff : Crash kernel
   f6220000-f622ffff : Reserved
   f9ee0000-f9ee3fff : Reserved
   fa120000-fa17ffff : Reserved
 fa190000-fe0bffff : System RAM
   fa190000-fa1bffff : Reserved
 fe4e0000-47fffffff : System RAM
   43c000000-441ffffff : Reserved
   47ff98000-47ffa3fff : Reserved
   47ffa4000-47ffa7fff : Reserved
   47ffa8000-47ffabfff : Reserved
   47ffac000-47ffaffff : Reserved
   47ffb0000-47ffb3fff : Reserved

Link: https://lkml.kernel.org/r/20231229080213.2622204-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Fixes: 0ab97169aa051 ("crash_core: add generic function to do reservation")
Cc: Baoquan He <bhe@redhat.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~kdump-defer-the-insertion-of-crashkernel-resources
+++ a/kernel/crash_core.c
@@ -377,7 +377,6 @@ static int __init reserve_crashkernel_lo
 
 	crashk_low_res.start = low_base;
 	crashk_low_res.end   = low_base + low_size - 1;
-	insert_resource(&iomem_resource, &crashk_low_res);
 #endif
 	return 0;
 }
@@ -459,8 +458,19 @@ retry:
 
 	crashk_res.start = crash_base;
 	crashk_res.end = crash_base + crash_size - 1;
-	insert_resource(&iomem_resource, &crashk_res);
 }
+
+static __init int insert_crashkernel_resources(void)
+{
+	if (crashk_res.start < crashk_res.end)
+		insert_resource(&iomem_resource, &crashk_res);
+
+	if (crashk_low_res.start < crashk_low_res.end)
+		insert_resource(&iomem_resource, &crashk_low_res);
+
+	return 0;
+}
+early_initcall(insert_crashkernel_resources);
 #endif
 
 int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

kdump-defer-the-insertion-of-crashkernel-resources.patch

