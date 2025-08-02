Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB51E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160864; cv=none; b=BWkbR3QiAXFWZ0pQDDTxwmwQXg3QU8qXD5Exr4tQw9ohWTwCwSznoKzTwyn6Qqo29YiHQISXXzy+ZEbbnUk1nSnIJ2vpzoiO6JXWg+ilU9NghEIWYC8Wq7462c6wfHoG7dt5KXBgkK8mQ/h0rzAMqGsO4LUap3OmqIZenFRa32g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160864; c=relaxed/simple;
	bh=Ftkv2ucrMMcMVlaqfQ6xZat1x1RkhcgUjwQbw80cWRU=;
	h=Date:To:From:Subject:Message-Id; b=K2N/WpYCVl3DVS+mEtJswux/C5OXeI8dlJaey0gtsjobfcQQIvcCl8eigpXaS5ZYz9owXiatV7BGajuuyjPoxPNEtJcNgolBuFij3VUFPyH/wLvIMgN3WiaGGW1IrJ0bUnLLBsNfBES+k4S3YMG0Fj/PJwQy5uqpp1trBW07eGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0HjKEJvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0HjKEJvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA4CC4CEEF;
	Sat,  2 Aug 2025 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160863;
	bh=Ftkv2ucrMMcMVlaqfQ6xZat1x1RkhcgUjwQbw80cWRU=;
	h=Date:To:From:Subject:From;
	b=0HjKEJvFiaP++7TxibCiocCDXrOVtpibb0vTuiwJIa3eB8Tb4PA2XR5FkG4Fn6d97
	 w289alWm0mP+RqFVmvucV6jf2iCZRJSJTmykfcwhmGgtej/6zZaLoPseTgksIYE1LL
	 LqXiRauMynccX0rvzwPLU1/ji1E2K3ks2BlXT0pA=
Date: Sat, 02 Aug 2025 11:54:23 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-add-anon_vma-lifetime-debug-check.patch removed from -mm tree
Message-Id: <20250802185423.CBA4CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: add anon_vma lifetime debug check
has been removed from the -mm tree.  Its filename was
     mm-rmap-add-anon_vma-lifetime-debug-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Harry Yoo <harry.yoo@oracle.com>
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

kasan-test-fix-protection-against-compiler-elision.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

