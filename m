Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742EC275AFC
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754958711; cv=none; b=Uh25w+L+egVipdTnJmUucA/hvEd4fWgh24e3oNYTlecadL3gA4WDCrq2SlLjV6qBN2ddTIz2B4+1VUWpcmBlaBbSJ/1G3edpsQPtCZMhVEnkx+yAs0HHzrMbeR0dWhnx+uAvOEwVG2a24ZlPsvpvyoHpFDH76H86cQgrO0mhGjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754958711; c=relaxed/simple;
	bh=wPPmvTieOZ5qrw7x/iGY70Iwc5uQmXKlnIBmWcDQUcM=;
	h=Date:To:From:Subject:Message-Id; b=WrKO0f6kSDhraFi2e+7luCuc5STMWySENWQv1/WsVluzVBgFkXm+za5rzM8T3mrD8/zq0OsSnEGPFMQX87Wc+cvEC7D9nWrKtrye1NdXzrvw5B6uPpbrbgTDG3HVCPd5xxHryIoDGvbE9xpQLsa98bxbi/oFZPuXW5RE5LLt9TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IV9V0vKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IV9V0vKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ABAC4CEED;
	Tue, 12 Aug 2025 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754958710;
	bh=wPPmvTieOZ5qrw7x/iGY70Iwc5uQmXKlnIBmWcDQUcM=;
	h=Date:To:From:Subject:From;
	b=IV9V0vKe5g0NlSYIIfghDc4cYd6eEfjjFxwqi2yvI+PVEWYlJ60vWpLkGhDwdaEaO
	 jQba6ZkOAN/TWQJVovMHwbFCW1h9pi/v25XMb8+W8Rjafdso/JHUyoOp8sBT8AZ/bW
	 6G5I+NKXwdP+GJZuaJsW/TMT+1rUhL3tQnG3nHzY=
Date: Mon, 11 Aug 2025 17:31:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,xuanzhuo@linux.alibaba.com,viro@zeniv.linux.org.uk,shaggy@kernel.org,senozhatsky@chromium.org,rakie.kim@sk.com,osalvador@suse.de,npiggin@gmail.com,muchun.song@linux.dev,mst@redhat.com,mpe@ellerman.id.au,minchan@kernel.org,matthew.brost@intel.com,maddy@linux.ibm.com,joshua.hahnjy@gmail.com,josef@toxicpanda.com,jerrin.shaji-george@broadcom.com,jasowang@redhat.com,jack@suse.cz,gregkh@linuxfoundation.org,gourry@gourry.net,eperezma@redhat.com,dsterba@suse.com,dave.kleikamp@oracle.com,clm@fb.com,christophe.leroy@csgroup.eu,byungchul@sk.com,brauner@kernel.org,bcrl@kvack.org,arnd@arndb.de,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-remove-migratepage_unmap.patch added to mm-new branch
Message-Id: <20250812003150.C8ABAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: remove MIGRATEPAGE_UNMAP
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-remove-migratepage_unmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-remove-migratepage_unmap.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/migrate: remove MIGRATEPAGE_UNMAP
Date: Mon, 11 Aug 2025 16:39:47 +0200

migrate_folio_unmap() is the only user of MIGRATEPAGE_UNMAP.  We want to
remove MIGRATEPAGE_* completely.

It's rather weird to have a generic MIGRATEPAGE_UNMAP, documented to be
returned from address-space callbacks, when it's only used for an internal
helper.

Let's start by having only a single "success" return value for
migrate_folio_unmap() -- 0 -- by moving the "folio was already freed"
check into the single caller.

There is a remaining comment for PG_isolated, which we renamed to
PG_movable_ops_isolated recently and forgot to update.

While we might still run into that case with zsmalloc, it's something we
want to get rid of soon.  So let's just focus that optimization on real
folios only for now by excluding movable_ops pages.  Note that concurrent
freeing can happen at any time and this "already freed" check is not
relevant for correctness.

Link: https://lkml.kernel.org/r/20250811143949.1117439-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Eugenio Pé rez <eperezma@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mathew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    1 
 mm/migrate.c            |   40 +++++++++++++++++++-------------------
 2 files changed, 20 insertions(+), 21 deletions(-)

--- a/include/linux/migrate.h~mm-migrate-remove-migratepage_unmap
+++ a/include/linux/migrate.h
@@ -18,7 +18,6 @@ struct migration_target_control;
  * - zero on page migration success;
  */
 #define MIGRATEPAGE_SUCCESS		0
-#define MIGRATEPAGE_UNMAP		1
 
 /**
  * struct movable_operations - Driver page migration
--- a/mm/migrate.c~mm-migrate-remove-migratepage_unmap
+++ a/mm/migrate.c
@@ -1176,16 +1176,6 @@ static int migrate_folio_unmap(new_folio
 	bool locked = false;
 	bool dst_locked = false;
 
-	if (folio_ref_count(src) == 1) {
-		/* Folio was freed from under us. So we are done. */
-		folio_clear_active(src);
-		folio_clear_unevictable(src);
-		/* free_pages_prepare() will clear PG_isolated. */
-		list_del(&src->lru);
-		migrate_folio_done(src, reason);
-		return MIGRATEPAGE_SUCCESS;
-	}
-
 	dst = get_new_folio(src, private);
 	if (!dst)
 		return -ENOMEM;
@@ -1275,7 +1265,7 @@ static int migrate_folio_unmap(new_folio
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
 		__migrate_folio_record(dst, old_page_state, anon_vma);
-		return MIGRATEPAGE_UNMAP;
+		return 0;
 	}
 
 	/*
@@ -1305,7 +1295,7 @@ static int migrate_folio_unmap(new_folio
 
 	if (!folio_mapped(src)) {
 		__migrate_folio_record(dst, old_page_state, anon_vma);
-		return MIGRATEPAGE_UNMAP;
+		return 0;
 	}
 
 out:
@@ -1848,14 +1838,28 @@ static int migrate_pages_batch(struct li
 				continue;
 			}
 
+			/*
+			 * If we are holding the last folio reference, the folio
+			 * was freed from under us, so just drop our reference.
+			 */
+			if (likely(!page_has_movable_ops(&folio->page)) &&
+			    folio_ref_count(folio) == 1) {
+				folio_clear_active(folio);
+				folio_clear_unevictable(folio);
+				list_del(&folio->lru);
+				migrate_folio_done(folio, reason);
+				stats->nr_succeeded += nr_pages;
+				stats->nr_thp_succeeded += is_thp;
+				continue;
+			}
+
 			rc = migrate_folio_unmap(get_new_folio, put_new_folio,
 					private, folio, &dst, mode, reason,
 					ret_folios);
 			/*
 			 * The rules are:
-			 *	Success: folio will be freed
-			 *	Unmap: folio will be put on unmap_folios list,
-			 *	       dst folio put on dst_folios list
+			 *	0: folio will be put on unmap_folios list,
+			 *	   dst folio put on dst_folios list
 			 *	-EAGAIN: stay on the from list
 			 *	-ENOMEM: stay on the from list
 			 *	Other errno: put on ret_folios list
@@ -1905,11 +1909,7 @@ static int migrate_pages_batch(struct li
 				thp_retry += is_thp;
 				nr_retry_pages += nr_pages;
 				break;
-			case MIGRATEPAGE_SUCCESS:
-				stats->nr_succeeded += nr_pages;
-				stats->nr_thp_succeeded += is_thp;
-				break;
-			case MIGRATEPAGE_UNMAP:
+			case 0:
 				list_move_tail(&folio->lru, &unmap_folios);
 				list_add_tail(&dst->lru, &dst_folios);
 				break;
_

Patches currently in -mm which might be from david@redhat.com are

mm-migrate-remove-migratepage_unmap.patch
treewide-remove-migratepage_success.patch

