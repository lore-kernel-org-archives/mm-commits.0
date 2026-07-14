Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4EA43A7E7
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057195; cv=none; b=Xg6p4MeUlhurf9L77ZWs5KpvIrq7Z63VL/1ZTw52zGnqPzyh2j60KQGjNwtb/OHVtTG1TUn18DmTCu0GDkXay3eFdBxyc/qLQAQ6uUEK2g0m7SQZTTN3KrnXNuBHZexWizEiEmof1NkkClJw8WsiDWH7zJLldI0U8cvbQG/Hv4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057195; c=relaxed/simple;
	bh=Pw2LMSdoWpGr3T4UPdxV/fCYvIOEXvoyn/Rtop7x8Jo=;
	h=Date:To:From:Subject:Message-Id; b=HW8lLUS6sLyS1enzLcN5tb4zYactpW6IVMkcfzzbcyrsdui7/U0jY17b/uzUzX8qnKkKkgu26JA5sMxA+E1p3wSiOuNFD+htBgYCFNAZyg725iUeCLhue7yp3h0ipgeuoD6a5vZsHXSieo+y7fcrJg9krdSnZNCnKsP00Bl95kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vh81EuGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vh81EuGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66591F00ACF;
	Tue, 14 Jul 2026 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057187;
	bh=51JHTjOLNVt9mPiYTfXj1zKF1NQT2ofaGyf9Er+3QXg=;
	h=Date:To:From:Subject;
	b=vh81EuGCnFJJFL2FcCOJ/dLPTP4c63vTe0EF5ba5VOiuHfQFNU8Q/lsAcMGKyM+Np
	 PNDxorQUwgG/PN+Vwq+VCQlIOGbrS//4ls607qzrh/fQPjRbV7pZD8N27b3d1X6k3K
	 ywmOvQ98IMWRMytheaLHLQ2LitT4GfA5eaacHA2w=
Date: Tue, 14 Jul 2026 12:26:27 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-fix-typos.patch added to mm-unstable branch
Message-Id: <20260714192627.A66591F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: fix typos
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-fix-typos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-fix-typos.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: fix typos
Date: Tue, 14 Jul 2026 07:01:14 -0700

Fix two typos in the DAMON sysfs ABI document:

  - "WDate:" -> "Date:" on the nr_regions/min entry
  - "manimum" -> "minimum" in the nr_accesses/min description

Link: https://lore.kernel.org/20260714140117.94147-3-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-fix-typos
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -144,7 +144,7 @@ Description:	Writing a value to this fil
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/nr_regions/min
 
-WDate:		Mar 2022
+Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum number of
 		monitoring regions of the DAMON context as the value.  Reading
@@ -287,7 +287,7 @@ Description:	Writing to and reading from
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/min
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-Description:	Writing to and reading from this file sets and gets the manimum
+Description:	Writing to and reading from this file sets and gets the minimum
 		'nr_accesses' of the scheme's target regions.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/access_pattern/nr_accesses/max
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch
docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch
docs-abi-damon-fix-typos.patch
docs-abi-damon-document-update_tuned_intervals-state-command.patch
docs-abi-damon-document-tried_regions-probe-hits.patch

