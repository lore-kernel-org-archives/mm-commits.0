Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AB36AAD
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627559; cv=none; b=QpSU5etIykjjblpcEsIY+rllbKY+lGV0ruD49exApi+XTYYVUbp6rC/hKPA5QQpnb2n1O9JHU+7p6uA9BkEKLP0l93KDx8Qx6AzuR1p3vfou2oMfo7sedbDJkpe6AjvDf3g/9pKO2HATS1xpIJoc+nb/zVh/RsZceVM1yF5LyNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627559; c=relaxed/simple;
	bh=16U34zic3z1Ighmkn0NWdP+mRHK5IqnfFtly+d4QdVE=;
	h=Date:To:From:Subject:Message-Id; b=rtSUMon/0uG80qhla93ZZI725IFiWwxQIhZ4+TGHbaGizMScL1Y+5lauIH4KJSEkWLqUaAGSfUAUM0If088SvO7kSLM+4naY+Yj8/TyNSRl3YAyH0ZuJeOf2x0llqEFHaP8N5qCulyySmnPSh124L2xgOMIwFXcBlUv6ooAK70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2LIdty2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2LIdty2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9208C32781;
	Sat, 29 Jun 2024 02:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719627558;
	bh=16U34zic3z1Ighmkn0NWdP+mRHK5IqnfFtly+d4QdVE=;
	h=Date:To:From:Subject:From;
	b=2LIdty2bnDvw+P4iqsEu7Q6WbZ8alzRN4r7+4IetkFHdAKzTANqiEKvBXRcn8vxzT
	 a/hhxAcIMgpUK3jlBPFNPyKCKT0+MLMwxwzv16wKqsoQbXRjw84iKbLAW+AweMU6fk
	 dMNlvxF/1/sUYFwD7d1pKKwpqW/cd6ZZDgOqGit0=
Date: Fri, 28 Jun 2024 19:19:18 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-pass-meminit_context-to-__free_pages_core-fix-3.patch removed from -mm tree
Message-Id: <20240629021918.B9208C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-pass-meminit_context-to-__free_pages_core-fix-3
has been removed from the -mm tree.  Its filename was
     mm-pass-meminit_context-to-__free_pages_core-fix-3.patch

This patch was dropped because it was folded into mm-pass-meminit_context-to-__free_pages_core.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-pass-meminit_context-to-__free_pages_core-fix-3
Date: Wed, 12 Jun 2024 20:31:07 +0200

add the parameter name also in the declaration

Link: https://lkml.kernel.org/r/ca575956-f0dd-4fb9-a307-6b7621681ed9@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/internal.h~mm-pass-meminit_context-to-__free_pages_core-fix-3
+++ a/mm/internal.h
@@ -605,7 +605,7 @@ extern void __putback_isolated_page(stru
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
 extern void __free_pages_core(struct page *page, unsigned int order,
-		enum meminit_context);
+		enum meminit_context context);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
_

Patches currently in -mm which might be from david@redhat.com are

mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl-fix.patch

