Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134902E6CC2
	for <mm-commits@vger.kernel.org>; Wed,  3 Dec 2025 22:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764800128; cv=none; b=mGMzhoVi2fNpIQyRCoGrLjt6pNcwVMDfaT9aRHBhxNADWBAjqeR/+c4GUZbgGptQT6MY7qrHRkqVBRfF1BigMijMeyj7jzovwbwPBkP+sDhRmMzKCrOBXRZ4zBHRy3UG5caC5sOTJHrVVubDMX+30RN/gy37Q2tL2aVyVp6tyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764800128; c=relaxed/simple;
	bh=Pzs6YW7z8rkKRSnZkViLCpz3d5nzpPe7zZG4uLEzamk=;
	h=Date:To:From:Subject:Message-Id; b=Qi1Z/smM5FskGHTNmTInCsZrq0DKImp2/Xqf8F6y6CUOYXasEM1yRGklCdFSPUuo4sM5ZfALf6/TgJ3qzpyq/TJ+vnrHgZlGUnZNLnozUyQUstlfTIf1NmiwdmWlinkh1J7F9k2K1OQjiM3JzVFBL0f02Ihwi5ELZsFD6u8TPcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ahPABvRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ahPABvRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36EFC4CEF5;
	Wed,  3 Dec 2025 22:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764800127;
	bh=Pzs6YW7z8rkKRSnZkViLCpz3d5nzpPe7zZG4uLEzamk=;
	h=Date:To:From:Subject:From;
	b=ahPABvRIZz2SG/wF3R89jUyucH4LeAYrdi5GPKFD3p70TLqgjpzSmFo+ZpugE3xSi
	 /7pC4WjixKwwBGQIm8+dMlPVd9uvyYIM9fnpYGsNY5cQy5mw3tkw9k+F3QYvPfLUD8
	 LqZzDpAeJE/wFBDZz0qFWgUu+GabepQjO31WyWwI=
Date: Wed, 03 Dec 2025 14:15:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,aboorvad@linux.ibm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251203221527.C36EFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
Date: Wed Dec  3 02:13:35 PM PST 2025

add comment, per Michal

Link: https://lkml.kernel.org/r/aS_y9AuJQFydLEXo@tiehlicka
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix
+++ a/mm/page_alloc.c
@@ -6611,6 +6611,11 @@ static int percpu_pagelist_high_fraction
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	/*
+	 * Avoid using pcp_batch_high_lock for reads as the value is read
+	 * atomically and a race with offlining is harmless.
+	 */
+
 	if (!write)
 		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch
mm-page_alloc-make-percpu_pagelist_high_fraction-reads-lock-free-fix.patch

