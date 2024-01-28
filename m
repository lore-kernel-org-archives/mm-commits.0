Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F3C184E
	for <mm-commits@vger.kernel.org>; Sun, 28 Jan 2024 03:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706411781; cv=none; b=sRCBWqrk30LBN/dPLJIKAdg6/KfxBiGa+Y/8nIFByx4ptdPAF+gXqR3H86gDlvZC64ctwr2GezCTH0xlJ5BltduHregwpvcxg3pF686ieTkz/49mJNnv4sBe7NQbQXgEL3gL/GLTqVtKAZgcdw8es7mGyXDWmgALDXk8ijDL30k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706411781; c=relaxed/simple;
	bh=f95wFftJQXcDVGpat9Yq6rrFrjl6SAPIDiUfu2V2dxQ=;
	h=Date:To:From:Subject:Message-Id; b=kHlrkufjnW1rCkXrHLcyUK42p+0Ok6lcLtp6w6IKkVKHTVO/weAsAuPBfAZ0N2dCnK2xCtakUysbFraEZUytDiHckLD1ND2WgNRAVUbnwQoZZBrpYdxN5hVYsrAMGorx7H68cheg7Vx+KtZ/JFRp0Hj1EyB4+Y2ArKq924qXjg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdhY333u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdhY333u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A400C433C7;
	Sun, 28 Jan 2024 03:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706411780;
	bh=f95wFftJQXcDVGpat9Yq6rrFrjl6SAPIDiUfu2V2dxQ=;
	h=Date:To:From:Subject:From;
	b=NdhY333u3R8Zq6JYVhBhLGsLK9ZK6JHrzXjs0Pz9tTuhtyVOfGRj54+OEKLAytBsK
	 ZRjXl5DwgfgeOtYQpJqiiIGHB/zXnE997QbRbu1+zMBNjR5OohIOXHCt4gAk0rdGA9
	 FYSx/1axIzqTTQNqdVXAllsnkoNhgTAXLteqJeZk=
Date: Sat, 27 Jan 2024 19:16:17 -0800
To: mm-commits@vger.kernel.org,vishal.l.verma@intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch added to mm-unstable branch
Message-Id: <20240128031620.1A400C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
Date: Sat Jan 27 07:13:46 PM PST 2024

fix build

In file included from ./include/linux/mmzone.h:1425,
                 from ./include/linux/gfp.h:7,
                 from ./include/linux/slab.h:16,
                 from ./include/linux/crypto.h:17,
                 from arch/x86/kernel/asm-offsets.c:9:
./include/linux/memory_hotplug.h:282:13: warning: 'mhp_supports_memmap_on_memory' defined but not used [-Wunused-function]
  282 | static bool mhp_supports_memmap_on_memory(void)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix
+++ a/include/linux/memory_hotplug.h
@@ -279,7 +279,7 @@ static inline bool movable_node_is_enabl
 	return false;
 }
 
-static bool mhp_supports_memmap_on_memory(void)
+static inline bool mhp_supports_memmap_on_memory(void)
 {
 	return false;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

