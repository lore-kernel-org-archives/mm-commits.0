Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BCF1C5D60
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274531; cv=none; b=QAVJ+5yQRXOlSVjimKjilIJrh+eTNpArY5/S0suVhaHPAhqX2FcW25fRkjNanc0QldwFEJxFGpGCmkRrqhNObLYhbECLOuSBGOOnTw9jwCLBqhD2QFHC8Fg28D7eGCi7gInHB9rilzj8X8Ge0pruCrh9EgASqAAB+4qV6mwLyrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274531; c=relaxed/simple;
	bh=ZSBFFpYa09n5qitVDeWJBqwFGcC56UOSMtSE1qcTF/g=;
	h=Date:To:From:Subject:Message-Id; b=jdSHdF3+edDJbX2I9FxV3ApM3XQNq6P22R9BkRBnZgUkdKsgHT9IIPpG4gGJT36h3eiLbdo0fszX9rlJC2SgqXCN8Q10hsySe449C82AhuMMdpHrRajJ8n/ZsprG7UqBuHyjI1Z+Bcgfr9E+bAElQzPE+DBF54utjsenL49xu0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EiptZxFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EiptZxFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A0FC4CEDD;
	Tue, 18 Mar 2025 05:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274530;
	bh=ZSBFFpYa09n5qitVDeWJBqwFGcC56UOSMtSE1qcTF/g=;
	h=Date:To:From:Subject:From;
	b=EiptZxFXnWGxjmcjZV1iSh0VOTgme/gBGY7oQdfmr9uTfPY6BjPHE53es3p3gu5LA
	 ioh140jxpjjYZ3bAiat8W3lWve1S2Fu3xtCmtSiG8TdM1vGGSQxco3EBfyHmNDsg9B
	 nj0DHA5JpgcruDEWVOTW62QdPTRFjj999U9i2y8w=
Date: Mon, 17 Mar 2025 22:08:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,tj@kernel.org,tglx@linutronix.de,muchun.song@linux.dev,mkoutny@suse.com,mingo@redhat.com,luto@kernel.org,lorenzo.stoakes@oracle.com,lizefan.x@bytedance.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jannh@google.com,ioworker0@gmail.com,hannes@cmpxchg.org,dave.hansen@linux.intel.com,corbet@lwn.net,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-hugetlb-specific-things-in-folio-to-page.patch removed from -mm tree
Message-Id: <20250318050850.B3A0FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move hugetlb specific things in folio to page[3]
has been removed from the -mm tree.  Its filename was
     mm-move-hugetlb-specific-things-in-folio-to-page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: move hugetlb specific things in folio to page[3]
Date: Mon, 3 Mar 2025 17:29:57 +0100

Let's just move the hugetlb specific stuff to a separate page, and stop
letting it overlay other fields for now.

This frees up some space in page[2], which we will use on 32bit to free up
some space in page[1].  While we could move these things to page[3]
instead, it's cleaner to just move the hugetlb specific things out of the
way and pack the core-folio stuff as tight as possible.  ...  and we can
minimize the work required in dump_folio.

We can now avoid re-initializing &folio->_deferred_list in hugetlb code.

Hopefully dynamically allocating "strut folio" in the future will further
clean this up.

Link: https://lkml.kernel.org/r/20250303163014.1128035-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andy Lutomirks^H^Hski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michal Koutn <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: tejun heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |   27 +++++++++++++++++----------
 mm/hugetlb.c             |    1 -
 mm/page_alloc.c          |    5 +++++
 3 files changed, 22 insertions(+), 11 deletions(-)

--- a/include/linux/mm_types.h~mm-move-hugetlb-specific-things-in-folio-to-page
+++ a/include/linux/mm_types.h
@@ -407,20 +407,23 @@ struct folio {
 			unsigned long _flags_2;
 			unsigned long _head_2;
 	/* public: */
-			void *_hugetlb_subpool;
-			void *_hugetlb_cgroup;
-			void *_hugetlb_cgroup_rsvd;
-			void *_hugetlb_hwpoison;
+			struct list_head _deferred_list;
 	/* private: the union with struct page is transitional */
 		};
+		struct page __page_2;
+	};
+	union {
 		struct {
-			unsigned long _flags_2a;
-			unsigned long _head_2a;
+			unsigned long _flags_3;
+			unsigned long _head_3;
 	/* public: */
-			struct list_head _deferred_list;
+			void *_hugetlb_subpool;
+			void *_hugetlb_cgroup;
+			void *_hugetlb_cgroup_rsvd;
+			void *_hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
-		struct page __page_2;
+		struct page __page_3;
 	};
 };
 
@@ -457,8 +460,12 @@ FOLIO_MATCH(_refcount, _refcount_1);
 			offsetof(struct page, pg) + 2 * sizeof(struct page))
 FOLIO_MATCH(flags, _flags_2);
 FOLIO_MATCH(compound_head, _head_2);
-FOLIO_MATCH(flags, _flags_2a);
-FOLIO_MATCH(compound_head, _head_2a);
+#undef FOLIO_MATCH
+#define FOLIO_MATCH(pg, fl)						\
+	static_assert(offsetof(struct folio, fl) ==			\
+			offsetof(struct page, pg) + 3 * sizeof(struct page))
+FOLIO_MATCH(flags, _flags_3);
+FOLIO_MATCH(compound_head, _head_3);
 #undef FOLIO_MATCH
 
 /**
--- a/mm/hugetlb.c~mm-move-hugetlb-specific-things-in-folio-to-page
+++ a/mm/hugetlb.c
@@ -1649,7 +1649,6 @@ static void __update_and_free_hugetlb_fo
 
 	folio_ref_unfreeze(folio, 1);
 
-	INIT_LIST_HEAD(&folio->_deferred_list);
 	hugetlb_free_folio(folio);
 }
 
--- a/mm/page_alloc.c~mm-move-hugetlb-specific-things-in-folio-to-page
+++ a/mm/page_alloc.c
@@ -971,6 +971,11 @@ static int free_tail_page_prepare(struct
 			goto out;
 		}
 		break;
+	case 3:
+		/* the third tail page: hugetlb specifics overlap ->mappings */
+		if (IS_ENABLED(CONFIG_HUGETLB_PAGE))
+			break;
+		fallthrough;
 	default:
 		if (page->mapping != TAIL_MAPPING) {
 			bad_page(page, "corrupted mapping in tail page");
_

Patches currently in -mm which might be from david@redhat.com are


