Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB794432FF
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 19:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057197; cv=none; b=uS/OlD8lAPuLI8qGr71ThOO4ZjOw0ir9Vt6RlgMlThxs8dH735yhJHnjZWBnRMxEdRT4UpBwjou0Kiyss13NBiKWNJg2Y+wNtNztictvLhWjvAJ/1JK3S2jspX1ehHl2n4pvSrEI283i3NAyE452B8OQeFEG8lGDHmfpgAzrWbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057197; c=relaxed/simple;
	bh=+bKGRGNNwbjo9EhgvuZJMt0Ydq4QhGI+XxOyapt29bM=;
	h=Date:To:From:Subject:Message-Id; b=TGGmR4dlRcqCvqMFk7uNZL2K91mlP3OWVbw59lARxKH9a6sSOdRxBO7zMAaNeMZi08bb4DIMQXspnT45FnD0zcS8vBJ1ef0LM+c2ee3tp0Jp12FsG8Q90Z/u8a59JPnSw1JPPYeiKzs3i+sabgd5EPEHn9wbbN1QIUJjcCytzIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bQTY+w9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQTY+w9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998661F00A3D;
	Tue, 14 Jul 2026 19:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784057191;
	bh=rkpY9Y6Xk8o+4hIe7nfTwXhyTbIjUav694QztjlQusM=;
	h=Date:To:From:Subject;
	b=bQTY+w9e2cxEPpX97LDpP+1hYWwfVN3myGU7Tu7d1UOvnEV3lfUsVKbxldQ66CMMx
	 x7qQ4jh80zxAPBjD+nW0ivO/qIwcPPl8JF6sdPk8dBsb7L6QaTrxu3ewrzlus+LnJW
	 k0UdGbYbuL/QV6be5Nav3p1qYri2B/VuA74KjS0Y=
Date: Tue, 14 Jul 2026 12:26:31 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-tried_regions-probe-hits.patch added to mm-unstable branch
Message-Id: <20260714192631.998661F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document tried_regions probe hits
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-tried_regions-probe-hits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-tried_regions-probe-hits.patch

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
Subject: Docs/ABI/damon: document tried_regions probe hits
Date: Tue, 14 Jul 2026 07:01:16 -0700

The 'tried_regions/<R>/probes/<P>/hits' file, added in commit 5b0de1bc3325
("mm/damon/sysfs-schemes: implement probe/hits file"), is described in
usage.rst but missing from the canonical ABI document.

Document the 'probes/' directory and the 'probes/<P>/hits' file.

Link: https://lore.kernel.org/20260714140117.94147-5-sj@kernel.org
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

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-tried_regions-probe-hits
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -650,3 +650,15 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the size of the memory in the region
 		that passed DAMON operations layer-handled filters of the
 		scheme in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Directory for DAMON data-attribute monitoring probes of the
+		region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/<P>/hits
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the number of data-attribute
+		monitoring probe-hit positive samples of the region.
_

Patches currently in -mm which might be from husong@kylinos.cn are

mm-damon-tests-core-kunit-test-damon_nr_accesses_mvsum.patch
docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch
docs-abi-damon-fix-typos.patch
docs-abi-damon-document-update_tuned_intervals-state-command.patch
docs-abi-damon-document-tried_regions-probe-hits.patch

