Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE65A12E75
	for <mm-commits@vger.kernel.org>; Mon,  8 Jul 2024 21:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720474976; cv=none; b=UV8q7XOG9zhJlvs9IJzgj4v1ojhNw49Yw9BOzBN7fZZQW5fPO/IyQeM4x8+4HX1Cln7lHE5LqAL+BDw3/1IW6ESz9lZqdauS0RlYILl3ZaLgfawUe/5qvJmQMSzSMk8daA20cjGBolg6F8zGowIApeWWaaTeTocv/7gPSFMKCtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720474976; c=relaxed/simple;
	bh=o3PRBcX0ME+hIqPwhoXEWbIbDEWmS9zJNHkf9ep5Xq8=;
	h=Date:To:From:Subject:Message-Id; b=m6fIIVvFEy7ja+/7VrZy0N4D6n0Y4pOkEFgdcwfgkvvRdaNUdGp9vBHd2d1XUDYdqUSE7HKTEgQbe2m1ksG0496Cs54wwhFIsHmDTWCaTx3veXWhFVhjbHE0QIry39cSOFNYrYmp6fKkKAtqfAAixm+HiM5sb52aptdm7ixCgnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yZdPAbCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yZdPAbCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F454C116B1;
	Mon,  8 Jul 2024 21:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720474975;
	bh=o3PRBcX0ME+hIqPwhoXEWbIbDEWmS9zJNHkf9ep5Xq8=;
	h=Date:To:From:Subject:From;
	b=yZdPAbCkD+GwL7HqoXdr1bCTI5TR8sBsuOo7wGKrFsad9tMUw1oHJYDfqIp3Butc+
	 CmQq0Ft6glIpMrIfsP/M8ZXYSx3Z92UjowhZmCXSDJyYzQB5x5btFRbQ1tXtihc5No
	 ZPVYc8GH8ZTcSKXEbw+PO4jFePEhBlytgz9lK4qI=
Date: Mon, 08 Jul 2024 14:42:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,pasha.tatashin@soleen.com,keescook@chromium.org,hannes@cmpxchg.org,alexs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-alignment-memcg_data-define-condition.patch added to mm-unstable branch
Message-Id: <20240708214255.9F454C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcg: alignment memcg_data define condition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-alignment-memcg_data-define-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-alignment-memcg_data-define-condition.patch

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

mm-memcg-alignment-memcg_data-define-condition.patch

