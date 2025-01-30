Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD5D139B
	for <mm-commits@vger.kernel.org>; Thu, 30 Jan 2025 23:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738280444; cv=none; b=Q39Zvkp0kzPXji/ntfTE1Djpd1tF90tMkLEcGYe9OoUklVbvRCdbdXfgtfreK2cLd6VXYWZXTUa/rSVqodpHxdQAVHC9KWMp0AmtzCffaz59KTbIwbtpM48y9ul7OSy6ENpg6LARvaMNn6b3fVVktnbkdWzVyJzDfcy1ItPBHIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738280444; c=relaxed/simple;
	bh=h2F+wa9F7SoOHjHZInNBF5ic1/JZCK05xV4CSWLRwNM=;
	h=Date:To:From:Subject:Message-Id; b=ZKTFP5hBuSOvky+FYUFmlNOtsvaxQXp36tCEVHfw48M/GFVXxbRHpmxyHasLpXu5QhnzDr0rGVZ8lRmaUx61h4gl7mCeGnwdF/7Aei9NtGLAdlyuCuiVlyBrtJA6eVr4l8w0fj61kBYzVygwjzXx6G7n7CmFMuJ+VmzuRnUWWLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vzlLdVj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vzlLdVj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2AFC4CED2;
	Thu, 30 Jan 2025 23:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738280443;
	bh=h2F+wa9F7SoOHjHZInNBF5ic1/JZCK05xV4CSWLRwNM=;
	h=Date:To:From:Subject:From;
	b=vzlLdVj5gKRXeSb++WDWp4UYH8kzh9QyYSv3dqr2v+aHHrJKo6nUfO5jYxHKu579u
	 jSncpmLRXSVXvPKFuhjTE+h2bJ/S6XNk70RZQsal2HfOYXVpy5iowQzeXtv5WtD422
	 gzsiqyNChBYbwqXGXevS4Ni92TKdcSehThL4r9Qg=
Date: Thu, 30 Jan 2025 15:40:42 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,willy@infradead.org,vbabka@suse.cz,tursulin@ursulin.net,rostedt@goodmis.org,rodrigo.vivi@intel.com,ran.xiaokai@zte.com.cn,osalvador@suse.de,nphamcs@gmail.com,miklos@szeredi.hu,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,josef@toxicpanda.com,joonas.lahtinen@linux.intel.com,jason@zx2c4.com,jani.nikula@linux.intel.com,hannes@cmpxchg.org,gehao@kylinos.cn,david@redhat.com,dan.carpenter@linaro.org,christophe.leroy@csgroup.eu,chengming.zhou@linux.dev,brauner@kernel.org,axboe@kernel.dk,andi.shyti@linux.intel.com,airlied@gmail.com,kirill.shutemov@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch added to mm-unstable branch
Message-Id: <20250130234043.2F2AFC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: transfer PG_dropbehind to the new folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch

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
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/migrate: transfer PG_dropbehind to the new folio
Date: Thu, 30 Jan 2025 12:00:39 +0200

Patch series "Get rid of PG_reclaim and rename PG_dropbehind", v3.

Use PG_dropbehind instead of PG_reclaim and remove PG_reclaim.

After removing PG_relcaim, PG_readahead is exclusive user of the page
flag bit.

Once PG_reclaim is gone, we can rename PG_dropbehind to PG_reclaim.


This patch (of 11):

Do not lose the flag on page migration.

Ideally, these folios should be freed instead of migration.  But it
requires to find right spot do this and proper testing.

Transfer the flag for now.

Link: https://lkml.kernel.org/r/20250130100050.1868208-1-kirill.shutemov@linux.intel.com
Link: https://lkml.kernel.org/r/20250130100050.1868208-2-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: gehao <gehao@kylinos.cn>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mattew Wilcox <willy@infradead.org> [English fixes]
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/migrate.c~mm-migrate-transfer-pg_dropbehind-to-the-new-folio
+++ a/mm/migrate.c
@@ -682,6 +682,10 @@ void folio_migrate_flags(struct folio *n
 	if (folio_test_dirty(folio))
 		folio_set_dirty(newfolio);
 
+	/* TODO: free the folio on migration? */
+	if (folio_test_dropbehind(folio))
+		folio_set_dropbehind(newfolio);
+
 	if (folio_test_young(folio))
 		folio_set_young(newfolio);
 	if (folio_test_idle(folio))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-migrate-transfer-pg_dropbehind-to-the-new-folio.patch
drm-i915-gem-convert-__shmem_writeback-to-folios.patch
drm-i915-gem-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-zswap-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-truncate-use-folio_set_dropbehind-instead-of-deactivate_file_folio.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim.patch
mm-vmscan-use-pg_dropbehind-instead-of-pg_reclaim-in-shrink_folio_list.patch
mm-mglru-check-pg_dropbehind-instead-of-pg_reclaim-in-lru_gen_folio_seq.patch
mm-remove-pg_reclaim.patch
mm-vmscan-do-not-demote-pg_dropbehind-folios.patch
mm-rename-pg_dropbehind-to-pg_reclaim.patch

