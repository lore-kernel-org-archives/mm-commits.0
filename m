Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F4A140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189498; cv=none; b=IZfRxPBOeUx7aP71o87iuRyygR6oD5AhjWqP6Uvd6FICbmyQgUIzUH0ajhrk4WkhVYH12LjaHXsBieUxYKE6Mk4whF2pSWsSn6PhJMahA+QUIdoLiJvAA/CrKJ5X1mssXVSR33AH48aCQazwYA5cCOOPmi1/evWhFQ+8Z1Nrhzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189498; c=relaxed/simple;
	bh=RWsYz7ypdGzobf/vw/Jc1qVl9sSmKRb4UPrHMQ7eY/c=;
	h=Date:To:From:Subject:Message-Id; b=rwShxqjQyzAdc96mlYGKAXcmWqsGakquatE16fld4D/BqFP+0LCtPWPY+zsZNx8vLuslrdUebkcUuQYLxqzq3Jh6Tsw/qwd6JHU+wJsV3IiYiVgAX6HUQ3e6Cw87H/20tbmPWxwPbIWaVJbywPOYcDxKLarlCaSv5dgpp/0iPUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N2rqhZR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N2rqhZR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5E4C4CEEC;
	Mon, 17 Mar 2025 05:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189497;
	bh=RWsYz7ypdGzobf/vw/Jc1qVl9sSmKRb4UPrHMQ7eY/c=;
	h=Date:To:From:Subject:From;
	b=N2rqhZR1rMxuCNCe4pMH3R9T4s3KuqWHHbKODFZoHrn6KKldya5T/Rz+/EAYPzvly
	 GSKaqDyFtTXVqG82oUSnCn3UrlQtw6Lp/oM1OXxgG7nPu9pTZeQjMWIBwcHJlTMmso
	 0zT4X9nSmOWoXiyCnr477gvmzAUsAmLIWMJkL01Q=
Date: Sun, 16 Mar 2025 22:31:37 -0700
To: mm-commits@vger.kernel.org,mpe@ellerman.id.au,mahesh@linux.ibm.com,maddy@linux.ibm.com,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch removed from -mm tree
Message-Id: <20250317053137.CA5E4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc: insert System RAM resource to prevent crashkernel conflict
has been removed from the -mm tree.  Its filename was
     powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: powerpc: insert System RAM resource to prevent crashkernel conflict
Date: Fri, 31 Jan 2025 17:08:29 +0530

The next patch in the series with title "powerpc/crash: use generic
crashkernel reservation" enables powerpc to use generic crashkernel
reservation instead of custom implementation.  This leads to exporting of
`Crash Kernel` memory to iomem_resource (/proc/iomem) via
insert_crashkernel_resources():kernel/crash_reserve.c or at another place
in the same file if HAVE_ARCH_ADD_CRASH_RES_TO_IOMEM_EARLY is set.

The add_system_ram_resources():arch/powerpc/mm/mem.c adds `System RAM` to
iomem_resource using request_resource().  This creates a conflict with
`Crash Kernel`, which is added by the generic crashkernel reservation
code.  As a result, the kernel ultimately fails to add `System RAM` to
iomem_resource.  Consequently, it does not appear in /proc/iomem.

There are multiple approches tried to avoid this:

1. Don't add Crash Kernel to iomem_resource:
    - This has two issues.
      First, it requires adding an architecture-specific hook in the
      generic code. There are already two code paths to choose when to
      add `Crash Kernel` to iomem_resource. This adds one more code path
      to skip it.

      Second, what if `Crash Kernel` is required in /proc/iomem in the
      future? Many architectures do export it.

2. Don't add `System RAM` to iomem_resource by reverting commit
   c40dd2f766440 ("powerpc: Add System RAM to /proc/iomem"):
    - It's not ideal to export `System RAM` via /proc/iomem, but since
      it already done ealier and userspace tools like kdump and
      kdump-utils rely on `System RAM` from /proc/iomem, removing it
      will break userspace.

3. Add Crash Kernel along with System RAM to /proc/iomem:

This patch takes the third approach by updating add_system_ram_resources()
to use insert_resource() instead of the request_resource() API to add the
`System RAM` resource to iomem_resource.  insert_resource() allows
inserting resources even if they overlap with existing ones.  Since `Crash
Kernel` and `System RAM` resources are added to iomem_resource early in
the boot, any other conflict is not expected.

With the changes introduced here and in the next patch, "powerpc/crash:
use generic crashkernel reservation," /proc/iomem now exports `System RAM`
and `Crash Kernel` as shown below:

$ cat /proc/iomem
00000000-3ffffffff : System RAM
  10000000-4fffffff : Crash kernel

The kdump script is capable of handling `System RAM` and `Crash Kernel` in
the above format.  The same format is used in other architectures.

Link: https://lkml.kernel.org/r/20250131113830.925179-7-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Baoquan he <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/mem.c~powerpc-insert-system-ram-resource-to-prevent-crashkernel-conflict
+++ a/arch/powerpc/mm/mem.c
@@ -376,7 +376,7 @@ static int __init add_system_ram_resourc
 			 */
 			res->end = end - 1;
 			res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
-			WARN_ON(request_resource(&iomem_resource, res) < 0);
+			WARN_ON(insert_resource(&iomem_resource, res) < 0);
 		}
 	}
 
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are


