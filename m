Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394FF29673F
	for <mm-commits@vger.kernel.org>; Wed, 14 May 2025 21:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747257762; cv=none; b=oe7VFFmBiVtfPqXxNaMuNvZ2F4CJVtAviVUNAQu3TG+9zyQ1CGrKAdq2VLNGZ4vta0ltYL+e+/5JpT7f+A+rVgGZWbeuWdDtGH2hfmon19WZfR+7MWdjSONOZav7rwkvXrOJeQzfN66iTDVelBlpLAi+4ct+oZd0YifxptN0lxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747257762; c=relaxed/simple;
	bh=jdAWrdiSi0v6y88UAlFoD5AraTwGtO0A44A5QDnEaXI=;
	h=Date:To:From:Subject:Message-Id; b=E+gPKQZHL2tGMC1EG52bbRRoTN79zRScYLJLa19Giz5y0dafS9uQJuVH0b9aVLKYfc5b3ZpGs24ymp07InLKEQ0xGWDHgaAYGJqDafbIq3QirWwywV3yWVczhGaYMgfC/X9lBrteqYiBk4/CQgLykIBiJiU0THvDRU2Bf+pJn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KmxQo8Di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KmxQo8Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8344AC4CEE3;
	Wed, 14 May 2025 21:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747257761;
	bh=jdAWrdiSi0v6y88UAlFoD5AraTwGtO0A44A5QDnEaXI=;
	h=Date:To:From:Subject:From;
	b=KmxQo8DiVGD5Mc9PGucDQI5iM45ev4MGbey/2XroyrZHmEov4uAbTmlv8HkPKOwV/
	 RCqy8wQftVXcZw/skMT05jZs3AW2vEimsUDIpbggq7f3kqfycX/Xlki1tS0bYqPOtt
	 YnZLaJ7vvcciHPTkKlghgOegIKodeQrsoiFRzZPs=
Date: Wed, 14 May 2025 14:22:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,oliver.sang@intel.com,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch added to mm-unstable branch
Message-Id: <20250514212241.8344AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove WARN_ON_ONCE() in file_has_valid_mmap_hooks()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: remove WARN_ON_ONCE() in file_has_valid_mmap_hooks()
Date: Wed, 14 May 2025 09:40:24 +0100

Having encountered a trinity report in linux-next (Linked in the 'Closes'
tag) it appears that there are legitimate situations where a file-backed
mapping can be acquired but no file->f_op->mmap or
file->f_op->mmap_prepare is set, at which point do_mmap() should simply
error out with -ENODEV.

Since previously we did not warn in this scenario and it appears we rely
upon this, restore this situation, while retaining a WARN_ON_ONCE() for
the case where both are set, which is absolutely incorrect and must be
addressed and thus always requires a warning.

If further work is required to chase down precisely what is causing this,
then we can later restore this, but it makes no sense to hold up this
series to do so, as this is existing and apparently expected behaviour.

Link: https://lkml.kernel.org/r/20250514084024.29148-1-lorenzo.stoakes@oracle.com
Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202505141434.96ce5e5d-lkp@intel.com
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fs.h~mm-remove-warn_on_once-in-file_has_valid_mmap_hooks
+++ a/include/linux/fs.h
@@ -2248,7 +2248,7 @@ static inline bool file_has_valid_mmap_h
 	/* Hooks are mutually exclusive. */
 	if (WARN_ON_ONCE(has_mmap && has_mmap_prepare))
 		return false;
-	if (WARN_ON_ONCE(!has_mmap && !has_mmap_prepare))
+	if (!has_mmap && !has_mmap_prepare)
 		return false;
 
 	return true;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-update-page-allocator-section.patch
maintainers-add-mm-reclaim-section.patch
maintainers-add-kernel-forkc-to-relevant-sections.patch
mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch

