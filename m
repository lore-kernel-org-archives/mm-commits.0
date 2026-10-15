Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DAC25EF87
	for <mm-commits@vger.kernel.org>; Thu, 15 Oct 2026 23:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105276; cv=none; b=UjzA/36LiZ/Ex64e33q/vWiOcWNzE9FEc72iK641QtOKFKi/rgd1R03mvqtnVu+LTEAGlJE9+nXatW0etzGzoMclL8xDmgygUFEfiH81M/ANwHoFAfao180ZDSrOjVNb1aNZhrUA1uj9Z9gBjm5vPHDFqTN0Z5csU+j9pq+1Y6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105276; c=relaxed/simple;
	bh=kNBFfeW1zoZkIj8JgW9gKcjS6AvXG/ypvdfvAFuJkSg=;
	h=Date:To:From:Subject:Message-Id; b=UxefBaFTp7f9r9EZtdFlZtFMWeK+j7F+ZHbPSxlsvecdZzDfIdCfznyvddjkOz1/CaKsK2EBn3eEazsWyRCCjvIfjiZ5Q7dTkFuwGWpaZWkByBbIEe0ikwMd7mbkiL9FIpqmw6AbVGyllsuy/hYgthqXRaTu5OUZtJWTW0g+2f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wYSufh8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wYSufh8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BF1F000C4;
	Thu, 15 Oct 2026 23:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105274;
	bh=dBkyDeCMS2lS7uM9Nb/Vq73sdu69CAOVBnuP8m8NJBI=;
	h=Date:To:From:Subject;
	b=wYSufh8somqZs41BkgpQ1pnld/c2lQL/5k1+dWBsLCuWZGatDAGrDg9aAY9hnA5ni
	 QN11aSaTDfWhGh/L1R1WdXapvAbXzvRu1oA/Xuwmy1N20vCVMZJ94H/lDghjKrHY/J
	 SkkMP2v/FtnEMUCYHMMYRlJj4uwsGwLcBvCfLlYU=
Date: Thu, 15 Oct 2026 16:01:14 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,skhan@linuxfoundation.org,sj@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-exclude-damon-docs-from-memory-management-misc.patch added to mm-unstable branch
Message-Id: <20261015230114.BE5BF1F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-exclude-damon-docs-from-memory-management-misc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-exclude-damon-docs-from-memory-management-misc.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT - MISC
Date: Thu, 15 Oct 2026 18:31:46 +0200

MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
catch-all for the mm Documentation subdirectories. Documentation for
DAMON is well maintained within its own subsystem and also actively
updated, so there's no need to Cc all MISC maintainers for them as well.
Thus add exclusion entries for them.

Link: https://lore.kernel.org/20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-exclude-damon-docs-from-memory-management-misc
+++ a/MAINTAINERS
@@ -17273,6 +17273,8 @@ F:	Documentation/admin-guide/mm/
 F:	Documentation/core-api/memory-allocation.rst
 F:	Documentation/core-api/mm-api.rst
 F:	Documentation/mm/
+X:	Documentation/admin-guide/mm/damon/
+X:	Documentation/mm/damon/
 F:	mm/char-mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-exclude-damon-docs-from-memory-management-misc.patch

