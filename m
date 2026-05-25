Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045D312815
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 17:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779730887; cv=none; b=dSJHvfoIpWo1nogQHhYK/mFjphRPU+3uowUO0em6FsUWFR+6ehpQMOZaR3lFbFjgF7abAsA+zgT8x0aA8IxnINtazROhsnyTyOamjjrcLfzV0y6SYB5IGbreS51impXwLex8f6HpirMP7mk4I1XOo+gRNL+B7IVCRmrzG/jpq/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779730887; c=relaxed/simple;
	bh=7y3+3ZHyqngVhUKw7Ql/n1U4MICfNC2jpc1fdSPaoMc=;
	h=Date:To:From:Subject:Message-Id; b=GByP01bm7LZ94mfiOOwjQERyZffDg0FcfDJLFNRZ04E+4v27Op5aMQ7OrjAn9LHAmYyp7qehIuxLQlQMnZRH7DlzSdbOcVGXab3HoLeDwAvCRdX/9DUmoQUdIPgqnZORl8dx8jshQtwtqQh8jiWfY/y86EldEBcyY0EQ3i4vZVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vDKpIJf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vDKpIJf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746121F000E9;
	Mon, 25 May 2026 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779730885;
	bh=0H4/kkaFRJZFAXRUSB4XFuOnjnAidWc7mjgSAXHDTdM=;
	h=Date:To:From:Subject;
	b=vDKpIJf6mxVBMhCs5iui2fZVKwKYKyd6L1Ou/fhoyLTB9qiv6l/9kmtOa3B0H7xaM
	 tqXKqNA81upU9Q6syBYRcF8RDcga4aSTTeJZm0pjNcEA44TIRlna6OL3Ay03Lwa+FY
	 L7D5FNKtDjLW/T6GVp3IBwuIIh6Hohea1VAh5/0I=
Date: Mon, 25 May 2026 10:41:24 -0700
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,rientjes@google.com,harry@kernel.org,vbabka@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch added to mm-hotfixes-unstable branch
Message-Id: <20260525174125.746121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
Date: Mon, 25 May 2026 09:26:39 +0200

Make sure the maintainers and reviewers are CC'd on changes to the scripts
and tools that depend on slab internals.

Link: https://lore.kernel.org/20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/MAINTAINERS~maintainers-add-slab-related-scripts-and-tools-to-slab-allocator
+++ a/MAINTAINERS
@@ -24622,6 +24622,12 @@ F:	mm/mempool.c
 F:	mm/slab.h
 F:	mm/slab_common.c
 F:	mm/slub.c
+F:	scripts/gdb/linux/slab.py
+F:	tools/cgroup/memcg_slabinfo.py
+F:	tools/include/linux/slab.h
+F:	tools/lib/slab.c
+F:	tools/mm/slabinfo-gnuplot.sh
+F:	tools/mm/slabinfo.c
 
 SLCAN CAN NETWORK DRIVER
 M:	Dario Binacchi <dario.binacchi@amarulasolutions.com>
_

Patches currently in -mm which might be from vbabka@kernel.org are

maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch

