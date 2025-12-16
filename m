Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6880B33E34C
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911506; cv=none; b=kjEUO4/KD2eUYDPGxSZa/4eJ1x0DtdspESpcuiDzn0951Qxgje6SWGthP0Hj5AZtuDpoP5yxLUne0LRP2ZTRP73Zupim1nVINocbCj2EpyW+JEAoIBWujAYJjyXBDM8NhDQW6BePEYjJaj1a9KYe/Fkf8gcIh3NXB8CojsWQUV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911506; c=relaxed/simple;
	bh=/Qaa8dOb1VQlg4wvaKp6+3s1lv++iGeqOwY7pYs94Og=;
	h=Date:To:From:Subject:Message-Id; b=bytWEfsaica79MhxrdTkWLiKLzWq3QeKzHHx7KEioVHwk9h6sJqNOfnHzg0nUlAtywDPdAERHggtZyWS4QzyWyJmQMP2ZTvSOG9GyuSrl3ea+u10C0Gbq4e2okse33IskjpPiLTaM02nQoVnyLdRUWj7tteunQ76B/QFX8Eqv/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NQtscjbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NQtscjbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00C4C4CEF1;
	Tue, 16 Dec 2025 18:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911506;
	bh=/Qaa8dOb1VQlg4wvaKp6+3s1lv++iGeqOwY7pYs94Og=;
	h=Date:To:From:Subject:From;
	b=NQtscjboarqSoeKVIKi5Ejc+B8VNv8OQAj5SZIhaTlZDrrhJj7TAvmpYBQqyE4k4A
	 bCfdWOo/rHxfZYzxgS7gExbY+KdlZ0pibmrdq1jDeWkkMfXtuDPrxyxXrbfNzfNfTt
	 5pU+5ceSOh3wucISAgfE1AgLlnwJLF/9iqWGlsvE=
Date: Tue, 16 Dec 2025 10:58:25 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-max_nr_snapshots.patch added to mm-new branch
Message-Id: <20251216185825.F00C4C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: update for max_nr_snapshots
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-max_nr_snapshots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-max_nr_snapshots.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:24 -0800

Update DAMON ABI document for the newly added DAMON sysfs interface file,
max_nr_snapshots.

Link: https://lkml.kernel.org/r/20251216080128.42991-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-max_nr_snapshots
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -522,6 +522,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the total number of DAMON snapshots
 		that the scheme has tried to be applied.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/max_nr_snapshots
+Date:		Dec 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number to this file sets the upper limit of
+		nr_snapshots that deactivates the scheme when the limit is
+		reached or exceeded.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/total_bytes
 Date:		Jul 2023
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch

