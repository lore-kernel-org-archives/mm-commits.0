Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6384E3208
	for <mm-commits@vger.kernel.org>; Sat, 14 Dec 2024 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734136452; cv=none; b=g4vU1JxiBBcuha7HFhZl22UWzcL2g/kISWf95KkmOC7lWTPiHbEf69CZoqCYD0WLwNatFTNybTkXY1b7XVuhijmCXDasdGe2g4OyJs2kcok7y4K51w4cOqkUuJF7rCynjYc7ueEhLOtcR9vIimSdr7sioywKNeb7WvyYmXicuQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734136452; c=relaxed/simple;
	bh=fHi2+KSFR6wDIKxAgiB1W1wMXR/tsmeQr0RlieCGKEs=;
	h=Date:To:From:Subject:Message-Id; b=TAiWxkaXLIQ0m5dIHUzSv1Phr+zewYsBpijnTL0B7HOt4AO0YurTbv3hvUoE70ePKM4D7aARil8c1Y34b4j1cQ/JayPmOYqXjNQmgj9mdSyDHsUVG2yGmszmd2nuhhJ7L90siZGc/3ncnRlOmcvbKO76OvFrjrxvw3wHQoBiJvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gMUVigMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gMUVigMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3514C4CED0;
	Sat, 14 Dec 2024 00:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734136451;
	bh=fHi2+KSFR6wDIKxAgiB1W1wMXR/tsmeQr0RlieCGKEs=;
	h=Date:To:From:Subject:From;
	b=gMUVigMnvSoL5AU2GedSgtZV7w/Cd+h+o1uqtzLzLiUtErn8tH2Xk7+44lwSlY0Mx
	 c6yIlcOd7VMJpvvI9S+JMPARwH4D4OOvWdG6WFssE70kqpQjj28fQY08+vuQIHYNkm
	 aWaqa5k5B0K4H3hsYvHgzprh1aLQgi4wqmmcvbws=
Date: Fri, 13 Dec 2024 16:34:11 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,mszeredi@redhat.com,josef@toxicpanda.com,jefflexu@linux.alibaba.com,bernd.schubert@fastmail.fm,joannelkoong@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch added to mm-unstable branch
Message-Id: <20241214003411.D3514C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: skip migrating folios under writeback with AS_WRITEBACK_INDETERMINATE mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch

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
From: Joanne Koong <joannelkoong@gmail.com>
Subject: mm/migrate: skip migrating folios under writeback with AS_WRITEBACK_INDETERMINATE mappings
Date: Fri, 22 Nov 2024 15:23:58 -0800

For migrations called in MIGRATE_SYNC mode, skip migrating the folio if it
is under writeback and has the AS_WRITEBACK_INDETERMINATE flag set on its
mapping.  If the AS_WRITEBACK_INDETERMINATE flag is set on the mapping,
the writeback may take an indeterminate amount of time to complete, and
waits may get stuck.

Link: https://lkml.kernel.org/r/20241122232359.429647-5-joannelkoong@gmail.com
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings
+++ a/mm/migrate.c
@@ -1254,7 +1254,10 @@ static int migrate_folio_unmap(new_folio
 		 */
 		switch (mode) {
 		case MIGRATE_SYNC:
-			break;
+			if (!src->mapping ||
+			    !mapping_writeback_indeterminate(src->mapping))
+				break;
+			fallthrough;
 		default:
 			rc = -EBUSY;
 			goto out;
_

Patches currently in -mm which might be from joannelkoong@gmail.com are

mm-add-as_writeback_indeterminate-mapping-flag.patch
mm-skip-reclaiming-folios-in-legacy-memcg-writeback-indeterminate-contexts.patch
fs-writeback-in-wait_sb_inodes-skip-wait-for-as_writeback_indeterminate-mappings.patch
mm-migrate-skip-migrating-folios-under-writeback-with-as_writeback_indeterminate-mappings.patch
fuse-remove-tmp-folio-for-writebacks-and-internal-rb-tree.patch

