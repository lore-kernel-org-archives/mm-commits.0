Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C154E15D5B9
	for <mm-commits@vger.kernel.org>; Wed, 29 May 2024 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717009568; cv=none; b=qCyW4PDwm2XMynTIjcRL+ISvcraW205k6rCz07MF8DgbZPKbz9grJ/aFFHGZz/3uTXyNWMsTVGJMZxmXZCV4M0irnxGV7eHBGH+9xnhljPoBuB6jNyDmBAzXblra4znVXf8gVB4nAxjDmhHpFDxBTK4/dTccCtDoCjG09SYdyuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717009568; c=relaxed/simple;
	bh=3vZE1xlKQvenrIOMEMIT+4JnnpXgfXfrdRTAnQUrU84=;
	h=Date:To:From:Subject:Message-Id; b=YPvTbrWzhAmcKFmrfZBKxhmBeDs3YqT3niGPpiKZur4yz3Zduu8OMLwvruQCRTgSaFdZc4wCUxj2tmRo+ieFum2nv5v9Tq7KpVpQTCBf4O9V1nYh+spn9IbsN4kg8CxAmWyMZ5w3n6ryJPALZLRBNDJWQDj4OIOr2yiYzEXlle4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C4vssxLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C4vssxLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB9C113CC;
	Wed, 29 May 2024 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717009568;
	bh=3vZE1xlKQvenrIOMEMIT+4JnnpXgfXfrdRTAnQUrU84=;
	h=Date:To:From:Subject:From;
	b=C4vssxLlttNfQm/91EZ3danJ1TV4QiJw7EfGl2soBSSFKIjB0I0oFb5s4twiMzU1Z
	 Cc7AnO2wKk16iBXLsG6GUXfYfdUPN5rz4x9O8+53ptK/kYgseRpc9N3poIf7+PDe3Q
	 enaRQw2EY2fMdFjWHQH5JLr7rEyDEWIeHA9rcGlQ=
Date: Wed, 29 May 2024 12:06:07 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,senozhatsky@chromium.org,rppt@kernel.org,minchan@kernel.org,42.hyeyoo@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-reinitialize-folio-_mapcount-directly.patch added to mm-unstable branch
Message-Id: <20240529190608.94BB9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: reinitialize folio->_mapcount directly
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-reinitialize-folio-_mapcount-directly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-reinitialize-folio-_mapcount-directly.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/filemap: reinitialize folio->_mapcount directly
Date: Wed, 29 May 2024 13:19:03 +0200

Let's get rid of the page_mapcount_reset() call and simply reinitialize
folio->_mapcount directly.

Link: https://lkml.kernel.org/r/20240529111904.2069608-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-reinitialize-folio-_mapcount-directly
+++ a/mm/filemap.c
@@ -177,7 +177,7 @@ static void filemap_unaccount_folio(stru
 				 * and we'd rather not leak it: if we're wrong,
 				 * another bad page check should catch it later.
 				 */
-				page_mapcount_reset(&folio->page);
+				atomic_set(&folio->_mapcount, -1);
 				folio_ref_sub(folio, mapcount);
 			}
 		}
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch

