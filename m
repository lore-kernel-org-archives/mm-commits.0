Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CA6390C84
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 21:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772660277; cv=none; b=XNBavNnC/oBVGrE76qN6RVOkSMrAnH5ZW5upz2NDZ8MU2ZbGaAf5zZHvZFOfN2uJEWl/n1UG2tE1hMkMhGUIwVdf+3RShymOnzODffNKVH5H5gLIlGIP9hnkHAN8RA5eAtJs99chwUKmY2QGL2i8K+7bvfO2E0sz2WBErhmrQw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772660277; c=relaxed/simple;
	bh=6HfOHXKXvD2i3GQREhSk1bLKllB9KBGUsz8PkRETS18=;
	h=Date:To:From:Subject:Message-Id; b=hnJkL8sOtuVHnGeQfIvnKG7g2OLmNxqALZQUL9lrQWtR7WtSPN3KU1s2mFk4q1Mlony5X7yRWUevowyRxZPXeksaQH8mm+VnbYmXBtP30B6S9obVeO+LhksJy/vZhJbG852tZh+W+PBLA4GgcEQZ+cxO/jCtHI1xD+FxlULczzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IE+wcyfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IE+wcyfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7A4C4CEF7;
	Wed,  4 Mar 2026 21:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772660277;
	bh=6HfOHXKXvD2i3GQREhSk1bLKllB9KBGUsz8PkRETS18=;
	h=Date:To:From:Subject:From;
	b=IE+wcyfOITG5xzQ24QsNH1Uh7hlSXFbqL8sS3KJDwO7wQtrSCWdGIJrnIOr76n5M/
	 GmHLvqf089x8suTqacWJDozE6DnQQ5d1A/nWoFOXVnJnqT9dLgXi6f+cHhbef0bT2z
	 pCBeCzscwb6jInfYdDYsipIkwa8Jh+eZVUHJS8KI=
Date: Wed, 04 Mar 2026 13:37:56 -0800
To: mm-commits@vger.kernel.org,kbingham@kernel.org,johannes.berg@intel.com,jan.kiszka@siemens.com,iii@linux.ibm.com,benjamin.berg@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-gdb-symbols-handle-module-path-parameters.patch added to mm-nonmm-unstable branch
Message-Id: <20260304213757.1E7A4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/gdb/symbols: handle module path parameters
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-gdb-symbols-handle-module-path-parameters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-gdb-symbols-handle-module-path-parameters.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Benjamin Berg <benjamin.berg@intel.com>
Subject: scripts/gdb/symbols: handle module path parameters
Date: Wed, 4 Mar 2026 12:06:43 +0100

commit 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available
to GDB") added support to make BPF debug information available to GDB. 
However, the argument handling loop was slightly broken, causing it to
fail if further modules were passed.  Fix it to append these passed
modules to the instance variable after expansion.

Link: https://lkml.kernel.org/r/20260304110642.2020614-2-benjamin@sipsolutions.net
Fixes: 581ee79a2547 ("scripts/gdb/symbols: make BPF debug info available to GDB")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/symbols.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/gdb/linux/symbols.py~scripts-gdb-symbols-handle-module-path-parameters
+++ a/scripts/gdb/linux/symbols.py
@@ -298,7 +298,7 @@ are loaded as well."""
             if p == "-bpf":
                 monitor_bpf = True
             else:
-                p.append(os.path.abspath(os.path.expanduser(p)))
+                self.module_paths.append(os.path.abspath(os.path.expanduser(p)))
         self.module_paths.append(os.getcwd())
 
         if self.breakpoint is not None:
_

Patches currently in -mm which might be from benjamin.berg@intel.com are

scripts-gdb-symbols-handle-module-path-parameters.patch

