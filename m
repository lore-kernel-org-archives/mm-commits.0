Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE33043A80B
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057197; cv=none; b=tO1ZiNeqyZeXus/VaZHjjSTvtr259M4I/o6XxVGF2i7D3lF5NiTLSRWOuZ5ZAkrE3m0xcPV2EARfKVVDuTHj6GqQr31f4TXOQRaervrsjCvvpZGYugIxvm4aMB5oa2ud+bD2Z4TgHegtTvAcILy+HwUp0EZCKfLVKfuxhTDPIs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057197; c=relaxed/simple;
	bh=51AZtuuerK/CbOIwxIZ4Ib7v8Sq6yFCc16yAX+4PHhg=;
	h=Date:To:From:Subject:Message-Id; b=kQ3TLfcGfe44APSmH0eZN77XA3riGGxoMszs/k8ioJ1HrooJptBJ108OKqrmRMtUvA9g/FPOlwZRRgmtEaj7VQZDDnKEvpu/rf3n0GiH7ujDkBzU7chUSyNeyGScuHm1ffkvGbazp+adbpxUaqTxBT5OyUajfOXyBe/ZPCuWT4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O7XCJZam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O7XCJZam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8D01F00A3A;
	Tue, 14 Jul 2026 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057189;
	bh=BIJ+7ooV0UGmIEOASV+I/doyiZw96ah89/5t9ojU0YQ=;
	h=Date:To:From:Subject;
	b=O7XCJZamNGh5WA/9sE+CQpoS+3sm7CatGVeF0otI8FavXLyVBxqwBLq5hvg7QcO9g
	 BIyO2vfpSsK5vdQT8GCAl5WJ0vnSO9EUmYhgd4wO5s0eN8OV1SKT4jwBCWDN3ODCAJ
	 9gKcvjcy/24jJWh1MeRMWe8RoH+KLnCD1MZ4/pGQ=
Date: Tue, 14 Jul 2026 12:26:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-update_tuned_intervals-state-command.patch added to mm-unstable branch
Message-Id: <20260714192629.9A8D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document update_tuned_intervals state command
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-update_tuned_intervals-state-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-update_tuned_intervals-state-command.patch

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
Subject: Docs/ABI/damon: document update_tuned_intervals state command
Date: Tue, 14 Jul 2026 07:01:15 -0700

The 'update_tuned_intervals' command of the 'state' file, added in commit
1077605396b4 ("mm/damon/sysfs: implement a command to update auto-tuned
monitoring intervals"), is described in usage.rst but missing from the
canonical ABI document.  Add it.

Link: https://lore.kernel.org/20260714140117.94147-4-sj@kernel.org
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

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-update_tuned_intervals-state-command
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -36,7 +36,10 @@ Description:	Writing 'on' or 'off' to th
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond.  Writing
+		'update_tuned_intervals' to the file updates 'sample_us' and
+		'aggr_us' files under 'monitoring_attrs/intervals' with the
+		auto-tuned sampling and aggregation intervals.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch
docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch
docs-abi-damon-fix-typos.patch
docs-abi-damon-document-update_tuned_intervals-state-command.patch
docs-abi-damon-document-tried_regions-probe-hits.patch

