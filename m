Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D861E5B82
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753485611; cv=none; b=poJf0ejis65D1afovpHYDQuF9lDJtE7eDwfyfsqiFb8JTBDZCcwzLVhJbEU85OTlRaWJ3EeId5E/vA0KDfzLrB+sbm+IoIJq7TyzDWUN0J1vpDfm8QDv4vs3J5qpuH2mm2kcv7MLG/KMV+xnQjRVovGAaUXgbCX5ruIFwAbxVk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753485611; c=relaxed/simple;
	bh=J7Yg4CPxY8xZdShJwQVCDeOgfXN2FLSeGH372i9Xrsw=;
	h=Date:To:From:Subject:Message-Id; b=BkNKnEGMztQmDTnEf6KR4RfPFoxUEepCh76ANTzO4e/UR0lvAC9aHVGt8jnj+WbnYSq0F253eq5wWvjCwRuwIQj8n50d/My6hWNGW0Z4RKRZOWysBnii7/4oF37DeJWVpXRxirgU+fs2il9jp+wHPK2MOuTHsND/jm5BJuk7IaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wRNbwIPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wRNbwIPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BA3C4CEE7;
	Fri, 25 Jul 2025 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753485610;
	bh=J7Yg4CPxY8xZdShJwQVCDeOgfXN2FLSeGH372i9Xrsw=;
	h=Date:To:From:Subject:From;
	b=wRNbwIPyPyDOrW9/4zDlkjOa7ZjlVL8y+33e0Pi3BIIvJqp5yUvkFV9sNUDYqYM/g
	 HMhDKZZSE1V9OfOvAXj+RcSFtcviblFDOJoO6nNiHTyxU6+gnCAC71WpvlRfxHwO+2
	 qs0nv7ggwXdAYTwY9xMQkojY0awcp/dndrDQERaM=
Date: Fri, 25 Jul 2025 16:20:10 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-anon_vma-lifetime-debug-check.patch added to mm-new branch
Message-Id: <20250725232010.D2BA3C4CEE7@smtp.kernel.org>
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
Date: Fri, 25 Jul 2025 14:16:24 +0200

If an anon folio is mapped into userspace, its anon_vma must be alive,
otherwise rmap walks can hit UAF.

There have been syzkaller reports a few months ago[1][2] of UAF in rmap
walks that seems to indicate that there can be pages with elevated
mapcount whose anon_vma has already been freed, but I think we never
figured out what the cause is; and syzkaller only hit these UAFs when
memory pressure randomly caused reclaim to rmap-walk the affected pages,
so it of course didn't manage to create a reproducer.

Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
to hopefully catch such issues more reliably.

[1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
[2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com

Link: https://lkml.kernel.org/r/20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/rmap.h~mm-rmap-add-anon_vma-lifetime-debug-check
+++ a/include/linux/rmap.h
@@ -449,6 +449,28 @@ static inline void __folio_rmap_sanity_c
 	default:
 		VM_WARN_ON_ONCE(true);
 	}
+
+	/*
+	 * Anon folios must have an associated live anon_vma as long as they're
+	 * mapped into userspace.
+	 * Note that the atomic_read() mainly does two things:
+	 *
+	 * 1. In KASAN builds with CONFIG_SLUB_RCU_DEBUG, it causes KASAN to
+	 *    check that the associated anon_vma has not yet been freed (subject
+	 *    to KASAN's usual limitations). This check will pass if the
+	 *    anon_vma's refcount has already dropped to 0 but an RCU grace
+	 *    period hasn't passed since then.
+	 * 2. If the anon_vma has not yet been freed, it checks that the
+	 *    anon_vma still has a nonzero refcount (as opposed to being in the
+	 *    middle of an RCU delay for getting freed).
+	 */
+	if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
+		unsigned long mapping = (unsigned long)folio->mapping;
+		struct anon_vma *anon_vma;
+
+		anon_vma = (void *)(mapping - FOLIO_MAPPING_ANON);
+		VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from jannh@google.com are

kasan-skip-quarantine-if-object-is-still-accessible-under-rcu.patch
mm-rmap-add-anon_vma-lifetime-debug-check.patch

