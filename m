Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A9144315
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291661; cv=none; b=nOYZm6Kf5BLl45DQ6tnrlqu1KAqagcZHq84lG3Vx9ntjF+YwDXhzMuFxIyZP5fWkORaOqIU1k6MTwiVwk7o/M7V0JIj0/9S7/3iuOuWfS4LLkBu4lpWt7mDs8Ci4vr9TT2VEnUXK7PoRgWIeunecP+mSa450aWXlPjRuPRPBJ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291661; c=relaxed/simple;
	bh=AIGt3fb/zlaxWeljeFFwm8ECw4jS/HjfSIqTuOfRERQ=;
	h=Date:To:From:Subject:Message-Id; b=bqaUDrUQz12gD69PJqw+olqOr3c00HZ5hc91OFE7rgsF96Oivl+6xUOtBplxHMWcePQokiYD+Z/BtLsdOeE7mNtev2oP1XWmOEBrb95wYQgdomnVbnLR3IPV2hS4Lv0VutewC5iI4HvuBEMToCU2WQC0R+UOrZULbdyDcL9nPx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/vhdKgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/vhdKgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B0C32782;
	Tue, 25 Jun 2024 05:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291660;
	bh=AIGt3fb/zlaxWeljeFFwm8ECw4jS/HjfSIqTuOfRERQ=;
	h=Date:To:From:Subject:From;
	b=x/vhdKgn400lKK0Lm9KsMfjR+RcG/kxwC2RXxlIZnkkJCO65Rj+FoyqUxc0Gfp11c
	 OUr9MRcZ1/yuGurskXLP8RlIDkO8GFtd1L1OiFBgiRGJ0gais9yFSxZVf+rdmAx7an
	 6+Zx62xyIA8ORCoQN8/ENG/Qczyr4Xidmn8+j6jk=
Date: Mon, 24 Jun 2024 22:01:00 -0700
To: mm-commits@vger.kernel.org,richard.weiyang@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-highmem-make-nr_free_highpages-return-unsigned-long.patch removed from -mm tree
Message-Id: <20240625050100.BB0B0C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/highmem: make nr_free_highpages() return "unsigned long"
has been removed from the -mm tree.  Its filename was
     mm-highmem-make-nr_free_highpages-return-unsigned-long.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/highmem: make nr_free_highpages() return "unsigned long"
Date: Fri, 7 Jun 2024 10:37:11 +0200

It looks rather weird that totalhigh_pages() returns an "unsigned long"
but nr_free_highpages() returns an "unsigned int".

Let's return an "unsigned long" from nr_free_highpages() to be consistent.

While at it, use a plain "0" instead of a "0UL" in the !CONFIG_HIGHMEM
totalhigh_pages() implementation, to make these look alike as well.

Link: https://lkml.kernel.org/r/20240607083711.62833-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |    8 ++++----
 include/linux/highmem.h          |    2 +-
 mm/highmem.c                     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/include/linux/highmem.h
@@ -179,7 +179,7 @@ static inline void *kmap_local_folio(str
 static inline void *kmap_atomic(struct page *page);
 
 /* Highmem related interfaces for management code */
-static inline unsigned int nr_free_highpages(void);
+static inline unsigned long nr_free_highpages(void);
 static inline unsigned long totalhigh_pages(void);
 
 #ifndef ARCH_HAS_FLUSH_ANON_PAGE
--- a/include/linux/highmem-internal.h~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/include/linux/highmem-internal.h
@@ -131,10 +131,10 @@ static inline void __kunmap_atomic(const
 		preempt_enable();
 }
 
-unsigned int __nr_free_highpages(void);
+unsigned long __nr_free_highpages(void);
 unsigned long __totalhigh_pages(void);
 
-static inline unsigned int nr_free_highpages(void)
+static inline unsigned long nr_free_highpages(void)
 {
 	return __nr_free_highpages();
 }
@@ -234,8 +234,8 @@ static inline void __kunmap_atomic(const
 		preempt_enable();
 }
 
-static inline unsigned int nr_free_highpages(void) { return 0; }
-static inline unsigned long totalhigh_pages(void) { return 0UL; }
+static inline unsigned long nr_free_highpages(void) { return 0; }
+static inline unsigned long totalhigh_pages(void) { return 0; }
 
 static inline bool is_kmap_addr(const void *x)
 {
--- a/mm/highmem.c~mm-highmem-make-nr_free_highpages-return-unsigned-long
+++ a/mm/highmem.c
@@ -111,10 +111,10 @@ static inline wait_queue_head_t *get_pkm
 }
 #endif
 
-unsigned int __nr_free_highpages(void)
+unsigned long __nr_free_highpages(void)
 {
+	unsigned long pages = 0;
 	struct zone *zone;
-	unsigned int pages = 0;
 
 	for_each_populated_zone(zone) {
 		if (is_highmem(zone))
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

