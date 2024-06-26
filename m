Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B20617BAF
	for <mm-commits@vger.kernel.org>; Wed, 26 Jun 2024 02:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719369129; cv=none; b=Al7XdNsa6oRi0cvNtTtj4EDOmzPZeT+FXL603tQUl/S5S5WRUDQo1BIg2wYOkWKojL5tKnxboO8rdXukLumnwKYUxNQ6Eg4lMmuDjdRtst5HEsVqRwQurvrlKy05IVMu9oXInthNEKGhiIKdpga/hKIAFygW5qzHc6eKmT1idS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719369129; c=relaxed/simple;
	bh=NUlpGrX7fJhTvKlm2ozugL1raDHz/VPCabxDjZwqAsM=;
	h=Date:To:From:Subject:Message-Id; b=WDU/2zrjgznOzUkvzeZGaPJa0he/ZQJXNKWc4CIIR2jdqrUExEAuYpMfS/h2GlPpoT1882QnYk/ONnLkqcT04z3ENCGzzPFyEZGqlZNitUUqSp6jrlU0qPAb71vzmbdhm6bZHlNekH7wdjxxBNi6ylEZmoldEXZl6h4faHsNoYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oEsCUxqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oEsCUxqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773B1C32781;
	Wed, 26 Jun 2024 02:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719369128;
	bh=NUlpGrX7fJhTvKlm2ozugL1raDHz/VPCabxDjZwqAsM=;
	h=Date:To:From:Subject:From;
	b=oEsCUxqWaks+VdceoIFOxKB/2cLJ+dR4smuQK533Hm+jlHFlWTvUXotpnZ+4zcFXt
	 uvdPf2KfBY5L8O+wjCfJ0Ohnsbm3RGAAkb97oEj5GCfgqB6QNXj2DKslTunjdpOxkA
	 K9SVKbViK1vCelzm6q0hL0Q657kBLMUYQwLQAEkI=
Date: Tue, 25 Jun 2024 19:32:07 -0700
To: mm-commits@vger.kernel.org,quic_charante@quicinc.com,longman@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch added to mm-hotfixes-unstable branch
Message-Id: <20240626023208.773B1C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prevent derefencing NULL ptr in pfn_section_valid()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch

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
From: Waiman Long <longman@redhat.com>
Subject: mm: prevent derefencing NULL ptr in pfn_section_valid()
Date: Tue, 25 Jun 2024 20:16:39 -0400

Commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") changed pfn_section_valid() to add a READ_ONCE()
call around "ms->usage" to fix a race with section_deactivate() where
ms->usage can be cleared.  The READ_ONCE() call, by itself, is not enough
to prevent NULL pointer dereference.  We need to check its value before
dereferencing it.

Link: https://lkml.kernel.org/r/20240626001639.1350646-1-longman@redhat.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-prevent-derefencing-null-ptr-in-pfn_section_valid
+++ a/include/linux/mmzone.h
@@ -1979,8 +1979,9 @@ static inline int subsection_map_index(u
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
+	struct mem_section_usage *usage = READ_ONCE(ms->usage);
 
-	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
+	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
_

Patches currently in -mm which might be from longman@redhat.com are

mm-prevent-derefencing-null-ptr-in-pfn_section_valid.patch

