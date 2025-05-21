Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D8E22C331
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 17:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747849541; cv=none; b=g4pfyDNkQEk5pbEyan2AW7GsGPwS/2wl41jER1+zTpz+jXqZoX2/0u/rUCOC5GUEl4mW/2TYhqLJ3d0ZGVQfqyozgHYDiKoWWy2eDbnjB9kCGqYlmXYdoLryHrM+zdJO9+YUbTeUAmB7vTlkX4t32qxew4HXe4OK/pLakRa5iX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747849541; c=relaxed/simple;
	bh=F8w8HCfBGdPkwz3amD+BrNVecWk3cXHJQT7pKgHWyow=;
	h=Date:To:From:Subject:Message-Id; b=ghT8CRQokx0UMHvs0P5fesN9MLj5jbqQbZ+RDzT3VziO8rlIzQReYHGjWeJO4pA0ZmDEhv4bqljh/9ktOV4oK0t/+8TzuWPs2B/CtpogfF01doKwg49Aw/qX3/NtQy9GR+V4uIAAelKrzD2HZe9QR5a4cILebD48pccLgSJydfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9FWeDtH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9FWeDtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4219CC4CEE4;
	Wed, 21 May 2025 17:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747849539;
	bh=F8w8HCfBGdPkwz3amD+BrNVecWk3cXHJQT7pKgHWyow=;
	h=Date:To:From:Subject:From;
	b=m9FWeDtH0NscvDYI9wpm6XqP+YVQF33lsIeaGzyCj3a/u1cHysiw/J/4fzRflxXAa
	 SeiOPaTHJiyKk1l3W2FQb4r7/46yqMucMJm2DWBpbhXttkcEc2RHJT9yExpoSg8XcP
	 /aB1W2if++yIpBekTE8bqOD3fMlWO3IDMCFyEg1k=
Date: Wed, 21 May 2025 10:45:38 -0700
To: mm-commits@vger.kernel.org,vkuznets@redhat.com,okozina@redhat.com,kernelfans@gmail.com,jpazdziora@redhat.com,gmazyland@gmail.com,dyoung@redhat.com,dave.hansen@intel.com,coxu@redhat.com,bhe@redhat.com,berrange@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] revert-x86-mm-remove-unused-__set_memory_prot-fix.patch removed from -mm tree
Message-Id: <20250521174539.4219CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: revert-x86-mm-remove-unused-__set_memory_prot-fix
has been removed from the -mm tree.  Its filename was
     revert-x86-mm-remove-unused-__set_memory_prot-fix.patch

This patch was dropped because it was folded into revert-x86-mm-remove-unused-__set_memory_prot.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert-x86-mm-remove-unused-__set_memory_prot-fix
Date: Sat May  3 11:38:32 PM PDT 2025

x86 set_memory.h needs pgtable_types.h for pgprot_t.  Obtain it via the
higher-level pgtable.h.

Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Jan Pazdziora <jpazdziora@redhat.com>
Cc: Liu Pingfan <kernelfans@gmail.com>
Cc: Milan Broz <gmazyland@gmail.com>
Cc: Ondrej Kozina <okozina@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/set_memory.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/set_memory.h~revert-x86-mm-remove-unused-__set_memory_prot-fix
+++ a/arch/x86/include/asm/set_memory.h
@@ -4,6 +4,7 @@
 
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
+#include <asm/pgtable.h>
 
 #define set_memory_rox set_memory_rox
 int set_memory_rox(unsigned long addr, int numpages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-zblock-allocator-fix.patch
mm-add-zblock-allocator-fix-2.patch
mm-add-zblock-allocator-fix-2-fix.patch
mm-add-zblock-allocator-fix-3.patch
mm-zblock-avoid-failing-the-build-fix.patch
revert-x86-mm-remove-unused-__set_memory_prot.patch

