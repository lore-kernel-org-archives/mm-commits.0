Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11BD8468
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 03:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935771; cv=none; b=dwT5pM8WgeAtJ3iT5s2BRSRifYzEideOacFGispHcQv47NLwQqxaDON4V6uJhQs79MjkH7s6dBDhjwAvn1JUIIQGQGo69nfu8oMKxxog2dWMZh+tcC+PlNiuC9r/Q20pR8eQNcNTW3D8ZeGmlmVTk5Nj6eso8U69tu+xLHHECgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935771; c=relaxed/simple;
	bh=9to6X0I2qtyxnO+IV8ElBhJgg4G4FcsxMq+ZpDDILPs=;
	h=Date:To:From:Subject:Message-Id; b=st9LbB2HDVoZ1FruMtn+3AtZKe+XBzAoThnPZLDw/2bCnCO8+ES/P1jFUj4RAMXVDslDAzd4UBxbLOULFdsZiZzoeoowbsNFfpDrmKxfFd+OXIle8CKaE4lomyISZHQR/nNBG/6L95WLSxa/RRRISQzKUNsP8qoLkeufK94WDqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LHSqYOiy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LHSqYOiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845E4C4CECF;
	Sat, 30 Nov 2024 03:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935770;
	bh=9to6X0I2qtyxnO+IV8ElBhJgg4G4FcsxMq+ZpDDILPs=;
	h=Date:To:From:Subject:From;
	b=LHSqYOiy4YCcBNsglDtWQcgd+l12gW5zbGKKNOGjRQp0XdQuSscnddqL97jO5Sdsv
	 XRTE1/pfpPnLJ7LYG2l++tzti8IWv6IjpFBjizmPRoG92IdXrseyujg91YdQnHzPjA
	 nlTFHfjEgqc8wHQhmQ81h/juA+Gtqx6IZuYjgMsM=
Date: Fri, 29 Nov 2024 19:02:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,kirill.shutemov@linux.intel.com,hdanton@sina.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20241130030250.845E4C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/filemap: don't call folio_test_locked() without a reference in next_uptodate_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/filemap: don't call folio_test_locked() without a reference in next_uptodate_folio()
Date: Fri, 29 Nov 2024 13:53:03 +0100

The folio can get freed + buddy-merged + reallocated in the meantime,
resulting in us calling folio_test_locked() possibly on a tail page.

This makes const_folio_flags VM_BUG_ON_PGFLAGS() when stumbling over the
tail page.

Could this result in other issues?  Doesn't look like it.  False positives
and false negatives don't really matter, because this folio would get
skipped either way when detecting that they have been reallocated in the
meantime.

Fix it by performing the folio_test_locked() checked after grabbing a
reference.  If this ever becomes a real problem, we could add a special
helper that racily checks if the bit is set even on tail pages ...  but
let's hope that's not required so we can just handle it cleaner: work on
the folio after we hold a reference.

Do we really need the folio_test_locked() check if we are going to trylock
briefly after?  Well, we can at least avoid a xas_reload().

It's a bit unclear which exact change introduced that issue.  Likely, ever
since we made PG_locked obey to the PF_NO_TAIL policy it could have been
triggered in some way.

Link: https://lkml.kernel.org/r/20241129125303.4033164-1-david@redhat.com
Fixes: 48c935ad88f5 ("page-flags: define PG_locked behavior on compound pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+9f9a7f73fb079b2387a6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/674184c9.050a0220.1cc393.0001.GAE@google.com/
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio
+++ a/mm/filemap.c
@@ -3501,10 +3501,10 @@ static struct folio *next_uptodate_folio
 			continue;
 		if (xa_is_value(folio))
 			continue;
-		if (folio_test_locked(folio))
-			continue;
 		if (!folio_try_get(folio))
 			continue;
+		if (folio_test_locked(folio))
+			goto skip;
 		/* Has the page moved or been split? */
 		if (unlikely(folio != xas_reload(xas)))
 			goto skip;
_

Patches currently in -mm which might be from david@redhat.com are

mm-mempolicy-fix-migrate_to_node-assuming-there-is-at-least-one-vma-in-a-mm.patch
mm-filemap-dont-call-folio_test_locked-without-a-reference-in-next_uptodate_folio.patch
docs-tmpfs-update-the-large-folios-policy-for-tmpfs-and-shmem.patch

