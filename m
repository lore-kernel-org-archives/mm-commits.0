Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42724180040
	for <mm-commits@vger.kernel.org>; Tue,  9 Jul 2024 20:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555533; cv=none; b=JM8Kv3uxija992QIQKrDHAqG8UuMVM1X94BrOrdsfVDyUBiL2uk1wh0/i3Pq6GRGrMG7/A+kCQxm7CCBILztKdWEAy7QSCQqDh8JjCROd/rIUr0kIqM6OFSy9Eiu6BjautUQ75DNsj/282r2k+b5DxEAYhuw67xjciTde8fp+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555533; c=relaxed/simple;
	bh=xrcTP2MYiHlnG/5C7dw83PUw97CHGkMakBZAWP62JnI=;
	h=Date:To:From:Subject:Message-Id; b=fffTstnBCkdciaRE/6XTO//eH56pcOL/+4F7mjFnOyKy0TOqcsOjpLefMKZPz6EJjgIudSO0zLMO7TKGHSbgEVH1BTT1foeGcaMjwz+HwyDGJixM2fsHDIId8sMy9hntkYE5EjVLjl/t9FQfMDDkgyE5I9c2E9AhZTOBww9rhSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KKKVKaVc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KKKVKaVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E34C3277B;
	Tue,  9 Jul 2024 20:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720555531;
	bh=xrcTP2MYiHlnG/5C7dw83PUw97CHGkMakBZAWP62JnI=;
	h=Date:To:From:Subject:From;
	b=KKKVKaVcu4Ktp9b340/ap0sdydIL0apA2GVyrzgvFZE8x6YPdA/f9SLnTpki64WN8
	 TegH/YhhVNX4TBBgwtrAhiYlbUh/kRgQLAOtwiWSegu7d9ZuSa3qPIt9U8T3kYT6vd
	 TggYipsH6m0pbtTWCEh9452CetdV3hQJuQIVjsfs=
Date: Tue, 09 Jul 2024 13:05:31 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,pasha.tatashin@soleen.com,keescook@chromium.org,hannes@cmpxchg.org,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-alignment-memcg_data-define-condition.patch removed from -mm tree
Message-Id: <20240709200531.A9E34C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memcg: alignment memcg_data define condition
has been removed from the -mm tree.  Its filename was
     mm-memcg-alignment-memcg_data-define-condition.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Alex Shi (Tencent)" <alexs@kernel.org>
Subject: mm/memcg: alignment memcg_data define condition
Date: Mon, 8 Jul 2024 14:32:36 +0800

commit 21c690a349ba ("mm: introduce slabobj_ext to support slab object
extensions") changed the folio/page->memcg_data define condition from
MEMCG to SLAB_OBJ_EXT.  The code works well, since config SLAB_OBJ_EXT is
fold into MEMCG in init/Kconfig.

But many related functions that deal with memcg_data still defined under
MEMCG instead of SLAB_OBJ_EXT, and FOLIO_MATCH with memcg_data are defined
under MEMCG too.  That looks weird and incorrect with memcg_data raw
meaning.

So let's put memcg_data under MEMCG config to alignment the definition
with FOLIO_MATCH and its usage in functions.

Link: https://lkml.kernel.org/r/20240708063236.1096395-1-alexs@kernel.org
Signed-off-by: Alex Shi (Tencent) <alexs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~mm-memcg-alignment-memcg_data-define-condition
+++ a/include/linux/mm_types.h
@@ -180,7 +180,7 @@ struct page {
 	/* Usage count. *DO NOT USE DIRECTLY*. See page_ref.h */
 	atomic_t _refcount;
 
-#ifdef CONFIG_SLAB_OBJ_EXT
+#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 #endif
 
@@ -343,7 +343,7 @@ struct folio {
 			};
 			atomic_t _mapcount;
 			atomic_t _refcount;
-#ifdef CONFIG_SLAB_OBJ_EXT
+#ifdef CONFIG_MEMCG
 			unsigned long memcg_data;
 #endif
 #if defined(WANT_PAGE_VIRTUAL)
_

Patches currently in -mm which might be from alexs@kernel.org are


