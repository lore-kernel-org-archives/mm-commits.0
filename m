Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CD0217F31
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 21:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394005; cv=none; b=CuUEjkeG0s9mG52VOfDoyHgq3+6hMGLfpa39sXFaosg+0Kp5WBkpJXmuNHbriT5VlR/pm/kZWnmFO0J58dn3ZBhoYuhYluVGJig5DeERchVcYTPERRgn8e1V9Gw1jaYrj9DZ5DxFl/t6ct53lTZbBtWWO2CWGxBMl/C9pWM+90w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394005; c=relaxed/simple;
	bh=Uay3nh8UJ+lGC/xSasfp8vGIT7Ys2U2z6Qhzi3DjdlQ=;
	h=Date:To:From:Subject:Message-Id; b=EQ7Z+zUfLDgCfHoEIvDDM7Pdryx8M43drrhTUu4KYWYvFxUxAyaGP+qqvYb2LZYwM4nJ0K4fkue6QbAJT7a24GJd1RTJydQkyl6NE5Wt+yBX4saXub0XhhjRnnt9rc3hIV2tzeuJbauNlA6RG20X+z9P3cDa3NlkF2Uy0ESMS7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kdCC0n0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kdCC0n0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD4BC4CEED;
	Thu, 24 Jul 2025 21:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753394005;
	bh=Uay3nh8UJ+lGC/xSasfp8vGIT7Ys2U2z6Qhzi3DjdlQ=;
	h=Date:To:From:Subject:From;
	b=kdCC0n0Q6MQzTn27EtiMd8Pnuwf1IRdMYFwSJ4GaxJWD8k1JLO4dCsq5nMXqMP8Rw
	 G7Fm4Yw74KyuxwlG5t64q7MPcp0UlmkGezSI75Aii7bJcNsAgG4GGU1srbeF7da+Ky
	 C5mlZOimcxLH4J20Mk5QGnkeXyupOvKJE6HlendY=
Date: Thu, 24 Jul 2025 14:53:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-anon_vma-lifetime-debug-check.patch added to mm-new branch
Message-Id: <20250724215325.7CD4BC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: add anon_vma lifetime debug check
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-add-anon_vma-lifetime-debug-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-anon_vma-lifetime-debug-check.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Jann Horn <jannh@google.com>
Subject: mm/rmap: add anon_vma lifetime debug check
Date: Thu, 24 Jul 2025 21:13:50 +0200

If an anon page is mapped into userspace, its anon_vma must be alive,
otherwise rmap walks can hit UAF.

There have been syzkaller reports a few months ago[1][2] of UAF in rmap
walks that seems to indicate that there can be pages with elevated
mapcount whose anon_vma has already been freed, but I think we never
figured out what the cause is; and syzkaller only hit these UAFs when
memory pressure randomly caused reclaim to rmap-walk the affected pages,
so it of course didn't manage to create a reproducer.

Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages to
hopefully catch such issues more reliably.

Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
unlike the checks above, this one would otherwise be hard to write such
that it completely compiles away in non-debug builds by itself, without
looking extremely ugly.

Link: https://lkml.kernel.org/r/20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com
Link: https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com [1]
Link: https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com [2]
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/rmap.h~mm-rmap-add-anon_vma-lifetime-debug-check
+++ a/include/linux/rmap.h
@@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_c
 	default:
 		VM_WARN_ON_ONCE(true);
 	}
+
+	/*
+	 * Anon folios must have an associated live anon_vma as long as they're
+	 * mapped into userspace.
+	 * Part of the purpose of the atomic_read() is to make KASAN check that
+	 * the anon_vma is still alive.
+	 */
+	if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
+		unsigned long mapping = (unsigned long)folio->mapping;
+		struct anon_vma *anon_vma = (void *)(mapping - PAGE_MAPPING_ANON);
+
+		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from jannh@google.com are

kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch

