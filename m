Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A782629D
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854819; cv=none; b=iephSIGRs9Kxuo84X9iKUdhctU/yzh9vWzYAuJZoAncjIkdiLoHlWFEjvA6pDns5KmKZ3RXg9joMDz8xPw/rN5P+yFg+T64h7CrKNwl1wA5uNMNtBB3BsgYv1zv8JklFkQDzwA1Tu5WNvt63uFJTNNXnn9f75ocgwls5g+bQM28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854819; c=relaxed/simple;
	bh=j3T0aoyfuuG5ewvSJh9RxYAaQP7KeaOZv70z0cH3j2o=;
	h=Date:To:From:Subject:Message-Id; b=UlpPcr+CBpmdZZm7Y6sRfC/OgCN7Ai+Hc8Nszj71Xa1WggSsAmdhG3KvyejHY5wwjw54ysSsRRuhP1iz5ttsqk/aWvSvdmRIIk2nNxIHGJRQodz/b+qqvn7aFJ31LsO1PacO95ltv8TdYyWcyjA/HlrRnLDiKfWK8ZVGfqyaNyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VsjileI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VsjileI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACEEC4CECF;
	Wed,  6 Nov 2024 01:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854819;
	bh=j3T0aoyfuuG5ewvSJh9RxYAaQP7KeaOZv70z0cH3j2o=;
	h=Date:To:From:Subject:From;
	b=VsjileI7A6DOgyL8Vy6DNxn3ugv4ZxHMMVxXVczfVBwr6cuG15ttslr5VPmIcV8Mx
	 rMC+7vNBkP7QYVjvyjf9W8Of+FFUGnw/1YzZNQS3hidwPiZzojPEdio7/zCb3DZhbi
	 V3mYnrQsFEIeV7EXzDLm7lTdmazK7+nqW5sJ1Km8=
Date: Tue, 05 Nov 2024 17:00:18 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch removed from -mm tree
Message-Id: <20241106010019.2ACEEC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools: testing: fix phys_addr_t size on 64-bit systems
has been removed from the -mm tree.  Its filename was
     tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools: testing: fix phys_addr_t size on 64-bit systems
Date: Thu, 17 Oct 2024 17:56:38 +0100

The phys_addr_t size is predicated on whether CONFIG_PHYS_ADDR_T_64BIT is
set or not.

In the VMA tests, virt_to_phys() from tools/include/linux casts a volatile
void * pointer to phys_addr_t, if CONFIG_PHYS_ADDR_T_64BIT is not set,
this will be 32-bit and trigger a warning.

Obviously this might also lead to truncation, which we would rather avoid.

Fix this by adjusting the generation of generated/bit-length.h to generate
a CONFIG_PHYS_ADDR_T{bits}BIT define.

This does result in the generation of the useless CONFIG_PHYS_ADDR_T_32BIT
define for 32-bit systems, but this should have no effect, and makes
implementation of this easier.

This resolves the issue and the warning.

[lorenzo.stoakes@oracle.com: VMA tests not properly importing bit-length.h]
  Link: https://lkml.kernel.org/r/a6183df9-3108-4d59-8128-4fc6c14e22a5@lucifer.local
Link: https://lkml.kernel.org/r/20241017165638.95602-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/shared/shared.mk |    1 +
 tools/testing/vma/vma.c        |    2 ++
 2 files changed, 3 insertions(+)

--- a/tools/testing/shared/shared.mk~tools-testing-fix-phys_addr_t-size-on-64-bit-systems
+++ a/tools/testing/shared/shared.mk
@@ -69,6 +69,7 @@ generated/bit-length.h: FORCE
 	@if ! grep -qws CONFIG_$(LONG_BIT)BIT generated/bit-length.h; then   \
 		echo "Generating $@";                                        \
 		echo "#define CONFIG_$(LONG_BIT)BIT 1" > $@;                 \
+		echo "#define CONFIG_PHYS_ADDR_T_$(LONG_BIT)BIT 1" >> $@;    \
 	fi
 
 FORCE: ;
--- a/tools/testing/vma/vma.c~tools-testing-fix-phys_addr_t-size-on-64-bit-systems
+++ a/tools/testing/vma/vma.c
@@ -4,6 +4,8 @@
 #include <stdio.h>
 #include <stdlib.h>
 
+#include "generated/bit-length.h"
+
 #include "maple-shared.h"
 #include "vma_internal.h"
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

