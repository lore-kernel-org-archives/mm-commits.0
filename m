Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92163391825;
	Fri,  7 Aug 2026 02:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068033; cv=none; b=UlpE1atPf5exnY+Hg7l4P+aXHSmKrRvgDsfny9n2JEpgU2qfpeLWPgr2nFNIyJPrnyqgDTrqf9HoC1A5+X5WHXDj9cIu3VtBWgrRaAD+W3Zw+sxNctxEMiRNkoPH4BiijBGjlcuCjJjLIy4BNX4A/CrWuUS7rzJI3pKAjVmciWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068033; c=relaxed/simple;
	bh=c3m3dzQuOWWiSr49P2Wp31nYjjCk2k68v3fhgyGq+RA=;
	h=Date:To:From:Subject:Message-Id; b=pCsImAU95vAA5rMWi0EarffTltmhbDPF0FLxAePl/l+do/9tyvGpEllIh/Vq/VWAHLX5eYNGAzhanBrkb1hYC/STh7aQOTmgIIHbhWgYae4znQRepufCD9C+x/KVykydxW4laGPCiBGq99nPIFp7gR0i+BYWQVf8tT2ODbBJaFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nAcCh4r2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nAcCh4r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0ED1F000E9;
	Fri,  7 Aug 2026 02:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068023;
	bh=RERGy/9P7ZetbLoJBFu9Z9nxlg0Gr0GZpUMO7Dy19RE=;
	h=Date:To:From:Subject;
	b=nAcCh4r2t/eNvKQXJv/BuGpFoQ919tekZrCIUmKquG7bmkM4whl9Apw8KmrNZmHt1
	 llKCO+WPv18hBWJ5eYKwwztAuKb9nOBn/F4z8jT3ekhsXrTrFmMN9LHf66CZ3fNyoJ
	 fLAt5LxO4Z1TtMBRli1x5OP70Tfr+rN7LA+D3kYQ=
Date: Thu, 06 Aug 2026 19:00:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch removed from -mm tree
Message-Id: <20260807020023.AB0ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: fix typo in intervals_goal sysfs path
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: fix typo in intervals_goal sysfs path
Date: Tue, 14 Jul 2026 07:01:13 -0700

Patch series "Docs/ABI/damon: sysfs ABI document fixes and additions", v2.

This series fixes typos and fills in missing entries in the DAMON sysfs
ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).

Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in four
What: entries; the documented path points to a non-existent directory, so
it is Cc'ed to stable.

Patch 2 fixes two further typos ("WDate:", "manimum").

Patches 3 and 4 add ABI entries that exist in the kernel and are already
described in usage.rst but are missing from the canonical ABI document:
the 'update_tuned_intervals' state command (patch 3) and the
'tried_regions/<R>/probes/<P>/hits' file (patch 4).


This patch (of 4):

The ABI document spells the DAMON sysfs directory as "intrvals_goal"
(missing 'e') in four What: entries, but the kernel creates it as
"intervals_goal" (mm/damon/sysfs.c).  Following the documented path
therefore yields a non-existent directory.

Link: https://lore.kernel.org/20260714140117.94147-1-sj@kernel.org
Link: https://lore.kernel.org/20260714140117.94147-2-sj@kernel.org
Fixes: e2b23dc62369 ("Docs/ABI/damon: document intervals auto-tuning ABI")
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-fix-typo-in-intervals_goal-sysfs-path
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -112,7 +112,7 @@ Description:	Writing a value to this fil
 		DAMON context in microseconds as the value.  Reading this file
 		returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/access_bp
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/access_bp
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the monitoring intervals
@@ -120,7 +120,7 @@ Description:	Writing a value to this fil
 		the given time interval (aggrs in same directory), in bp
 		(1/10,000).  Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/aggrs
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/aggrs
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the time interval to achieve
@@ -128,14 +128,14 @@ Description:	Writing a value to this fil
 		access events ratio (access_bp in same directory) within.
 		Reading this file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/min_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/min_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the minimum value of
 		auto-tuned sampling interval in microseconds.  Reading this
 		file returns the value.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intrvals_goal/max_sample_us
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/intervals_goal/max_sample_us
 Date:		Feb 2025
 Contact:	SJ Park <sj@kernel.org>
 Description:	Writing a value to this file sets the maximum value of
_

Patches currently in -mm which might be from husong@kylinos.cn are


