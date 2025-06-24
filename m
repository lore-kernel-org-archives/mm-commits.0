Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E722475F2
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 21:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799456; cv=none; b=EjyUeaS5vyAxcO+R9ohShSMJOIQQKp5EWdwTigM2JYyE5VMYJsQIOoMhSlFaiqdmcmzlVIilC7yqv+r0YFyaKzKN0STRpX6WaXGttgtbaLRUO6RCioQ1LGOrw6w1VI1Qo68G8s+5i8U1LRtlb8CejxlOAqeYMsemx6Kk9HrS+0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799456; c=relaxed/simple;
	bh=dIMlhzcsV5PLbeTmpWyxLTuYpLNw0fJAKy+sEIHy0Gw=;
	h=Date:To:From:Subject:Message-Id; b=oUvuTV9KXf7FJhPYzuYn+8nqYKJoKNGaFHe1zMq197iwpJ9X3PWvHN1A/YVHZivzlmFOU4FBNsZ8ytJAinN8aZSW4747RA5RffePsoKIaiXi9liWcUiCy6LrQWCFWg1LBzUE36tsGzhHL/uD1BiY3jDYWs/nMttG/o120msyXJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cFZ0Q9o9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cFZ0Q9o9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D44EC4CEEF;
	Tue, 24 Jun 2025 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750799456;
	bh=dIMlhzcsV5PLbeTmpWyxLTuYpLNw0fJAKy+sEIHy0Gw=;
	h=Date:To:From:Subject:From;
	b=cFZ0Q9o9OuhdlgNs3sC7pqAz/x5rh7H58IJ/J1Ihn+/lqzEcTm5d/zqfW9SdMcsn3
	 7wjiqGQxWsROxFwyl6Yh6l+WAdNTQ+99mOzTtJx/SqDsuY2oHO52P7sdAFm3Eso3hx
	 4jPh1V9TFrRPymW/OFs9M2NKChP3P2jdvHWmpKmg=
Date: Tue, 24 Jun 2025 14:10:55 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,dave@stgolabs.net,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-make-memoryreclaim-interface-generic-fix.patch added to mm-new branch
Message-Id: <20250624211056.3D44EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-make-memoryreclaim-interface-generic-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-make-memoryreclaim-interface-generic-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-make-memoryreclaim-interface-generic-fix
Date: Tue Jun 24 02:08:06 PM PDT 2025

fix CONFIG_NUMA=n build

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506250208.ZOcoZLb6-lkp@intel.com/
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/internal.h~mm-memcg-make-memoryreclaim-interface-generic-fix
+++ a/mm/internal.h
@@ -517,8 +517,16 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+#ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
+#else
+static inline int user_proactive_reclaim(char *buf,
+			   struct mem_cgroup *memcg, pg_data_t *pgdat)
+{
+	return 0;
+}
+#endif
 
 /*
  * in mm/rmap.c:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-oom-killer-maintainer-structure-fix.patch
mm-add-oom-killer-maintainer-structure-fix-checkpatch-fixes.patch
mmslub-use-node-notifier-instead-of-memory-notifier-fix.patch
filemap-add-__filemap_get_folio_mpol-fix.patch
mm-memcg-make-memoryreclaim-interface-generic-fix.patch
maintainers-add-lib-raid6-to-software-raid.patch

