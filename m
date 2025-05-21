Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF71722D4C8
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846645; cv=none; b=ZthEgN3XrAZnUD9sRgGWfKLcvky9gI3R0l/YydFilL872iFwNgqKiqonfqfXOhJnmSCD7oGR9WYJx4tVNpqsddUyRQ4JJa5kR/UQMa1T8b/Aj/X6E9k3awM/jy54AXTtp6V8cSPtTKakIIaAlpFipc/l4zcL6ZKw9yW8RU4pQSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846645; c=relaxed/simple;
	bh=QndCW3lWOCWh/6bqGx+wr65HEHdrmybbmH+5DsxppnM=;
	h=Date:To:From:Subject:Message-Id; b=OD6e3vSI9qSREe6NVuZjk8BPkwyGLYBqBz9fbpkGKCxaANBB+Cp1BUftwfb/f21zSPZsGfQse+1Zc/Eb2zmpnOiTY5zckA75KSAH/5A3AeFZXlWN6cJSGyoOhEMDtN7GaYmSvZgnalLTlmnZkd9oInd+RMNVXJlCUCCyvpOZiU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYLctJcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYLctJcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A10C4CEE4;
	Wed, 21 May 2025 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846645;
	bh=QndCW3lWOCWh/6bqGx+wr65HEHdrmybbmH+5DsxppnM=;
	h=Date:To:From:Subject:From;
	b=IYLctJcNj0MRRahOjdC9skg0h7lHG6hcoIu+rwosK/L6DAKk+0mLqR7SZHR5PZw+3
	 HWYuo0LAbYlA7yQ+Mmy44iWtN8qsvKHbNKUwnwT6w5ZvSWNEF5tBMMMJQVdj33F/Qp
	 Avi8vr69b14W/1CV26AwWQPjmcNkTr5S8JqbvfcI=
Date: Wed, 21 May 2025 09:57:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,oliver.sang@intel.com,mhocko@suse.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,david@redhat.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch removed from -mm tree
Message-Id: <20250521165725.97A10C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove WARN_ON_ONCE() in file_has_valid_mmap_hooks()
has been removed from the -mm tree.  Its filename was
     mm-remove-warn_on_once-in-file_has_valid_mmap_hooks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


