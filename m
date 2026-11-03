Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668688;
	b=OP+suZ8DSL6ERXjwPaeiB7MxpGXaXEioKE/vyMFYC+EkjVNBPdzynZhXyrcBfml0YNFp
	 yBzDr8sjGEsZiTjd3nz6F83y7nbmMMWb36H3c2ehj5At/cxdNU6opmRwvasyq9D5fRnaN
	 oG/8idD6y2fEsjTdVzD7IdHmeYcMJUQFloP4vcQDKc5LoBd2U/L+jqaPHhlEHv9y1qb/M
	 rlvcYg7DT0a6WzKWPt2h6qi0vUn0caBr8PH5W//uWHXR+EQkMiMQ7UNx9dlpsulGArap8
	 DPB0g1arnec6z0Mnk0dRoU76kw2iro8ku8JfoVrFENIvUTLd3TkiMjTH0QISEOjhXEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668688;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=F6nLFMMs4W2LO83sAhqfEvn9e8mHkyblXoSsJBaHfBA=;
	b=Oy+4TYuu8FKVf+NjrNWju8FT54j4YLdD00taYmoH/Ey01a+cDVnnq34Marhzo5WzbySP
	 t5/FXGVrxNZGv20bH1aZ2ECnQN8Ns3HT4bHeaEXvztL8p+xQNqET5C/pK3tRnT3N3jBy2
	 nYk6l4hqIdtWNFia6XwPkZYaV6Mgf/eEFKp9B9ZZdMJGL7pRrmY7tlnpyR5IlOgoWozFZ
	 rsEdRIhxWXkgklgvZiWDGrndINUdZ6zztPKtRH9Xsg6pmFlc1ULSARWjdS2EsgWVnR1Ea
	 L0BSP2mgW4X0NDrvOYzrey4FUIEl1qFnbadWPx36vCwbV521NlQ4xg1bbsDUhFtfLSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fgKJS7Ao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06955606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fgKJS7Ao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D181F000C1;
	Tue,  3 Nov 2026 01:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793668687;
	bh=F6nLFMMs4W2LO83sAhqfEvn9e8mHkyblXoSsJBaHfBA=;
	h=Date:To:From:Subject;
	b=fgKJS7Ao0n5bjWNNqXMtYRXNya4X5vG1BzNGAxyiA5BwjiTMGwt+4ABHhqRhglmpR
	 6qncbn1e1k5pWxI11rrmAW36e7WAeeKAbcQ7JxTj19HuHghj5ZTriX2gAg5Wn7P+0V
	 C7dQ3dF3kKp8+rsqP6Yc9BTUkhN5GeI2oT+dk/Ro=
Date: Mon, 02 Nov 2026 17:18:07 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,sj@kernel.org,
	rdunlap@infradead.org,manuelebnerli@mailbox.org,corbet@lwn.net,
	jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-fix-grammar.patch added to mm-new branch
Message-Id: <20261103011807.92D181F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: fix grammar
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-start-fix-grammar.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-start-fix-grammar.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Aveline Noir <jm5905938@gmail.com>
Subject: Docs/admin-guide/mm/damon/start: fix grammar
Date: Mon, 02 Nov 2026 16:59:31 -0800

Patch series "Docs: damon: fix grammar and typos", v2.

I was reading the DAMON docs and kept running into small grammar
mistakes and typos, so here is a series that tries to clean them up.
There is one patch per document, and nothing beyond grammar was
changed :)

Some fixes pushed lines over 80 columns, so those paragraphs are
rewrapped.  Patch 4 picks up what I think was left in lru_sort.rst
after Manuel's recent fix.


This patch (of 8):

Fix a few grammar slips in the getting-started guide, like "make DAMON
monitors" and a region "that has not accessed".

"The line of the commands" used to be "The first two lines".  With only
one masim line left, I make it "The first line".

Link: https://lore.kernel.org/20261103005940.91432-1-sj@kernel.org
Link: https://lore.kernel.org/20261103005940.91432-2-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-fix-grammar
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -63,7 +63,7 @@ the execution. ::
 
 The first command of the above example downloads and builds an artificial
 memory access generator program called ``masim``.  The second command asks DAMO
-to start the program via the given command and make DAMON monitors the newly
+to start the program via the given command and make DAMON monitor the newly
 started process.  The third command retrieves the current snapshot of the
 monitored access pattern of the process from DAMON and shows the pattern in a
 human readable format.
@@ -71,16 +71,16 @@ human readable format.
 The first line of the output shows the relative access temperature (hotness) of
 the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the column on the row and the number on the column represents the
+position of the column on the row and the number on the column represent the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
 
 Each line of the output from the third line shows which virtual address range
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the eleventh region of
-~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
-the fourth command stops DAMON.
+accessed for how long (``age XX``).  For example, the eleventh region of
+~9.5 MiB size is being most frequently accessed for the last 3.7 seconds.
+Finally, the fourth command stops DAMON.
 
 Note that DAMON can monitor not only virtual address spaces but multiple types
 of address spaces including the physical address space.
@@ -95,7 +95,7 @@ monitoring results to a file. ::
     $ ./masim ./configs/zigzag.cfg &
     $ sudo damo record -o damon.data $(pidof masim)
 
-The line of the commands run the artificial memory access
+The first line of the commands runs the artificial memory access
 generator program again.  The generator will repeatedly
 access two 100 MiB sized memory regions one by one.  You can substitute this
 with your real workload.  The last line asks ``damo`` to record the access
@@ -170,8 +170,8 @@ set size has chronologically changed.::
 Data Access Pattern Aware Memory Management
 ===========================================
 
-Below command makes every memory region of size >=4K that has not accessed for
->=60 seconds in your workload to be swapped out. ::
+Below command makes every memory region of size >=4K that has not been accessed
+for >=60 seconds in your workload to be swapped out. ::
 
     $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
                       --damos_age 60s max --damos_action pageout \
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-core-reset-watermark-wait-state-on-each-iteration.patch
mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch

