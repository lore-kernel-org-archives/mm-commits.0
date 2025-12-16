Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C5A2DAFA2
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 18:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765911504; cv=none; b=FVfRgQ4Ga4eEE+Vy699wiFE9XluW0qxQpOFYhoiWIOU2YEzgj+ow21afYPhQTrjz1icRtM07YHsyI+ZGpeWFVr8v1RY+dKBkaUq6qf73afxytQlC5El5T2TxwXnSV8fi/roJzVEMVzIQig1NFJfl9NGlrCW79lk31f95k9PNKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765911504; c=relaxed/simple;
	bh=1onTOCIUbLF+Pk2ZkKPB0e9R7H/7zlI3zb0SgnRwwC8=;
	h=Date:To:From:Subject:Message-Id; b=Jp1Lli8PlllY/QcaBLbIyATJoCSgKVk043mQcymUfZu/Kl7Z8V/0Eh+vsrezSfZHaHNP2NUDEeAJ8QnJ+YhuWpt1yZ6DDQbhF1NAf7OMI4NU/6aS9x5Jny2CX5+SrSzgoZE2a3hSY23AXqZUGw24QPKVkLW23oCc5VM7lAs0nEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yPad3nsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yPad3nsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1872C4CEF1;
	Tue, 16 Dec 2025 18:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765911504;
	bh=1onTOCIUbLF+Pk2ZkKPB0e9R7H/7zlI3zb0SgnRwwC8=;
	h=Date:To:From:Subject:From;
	b=yPad3nsIaJEaAlGzUbbBlZMLliHq1ZrxIEsmf7n6LyEom9u0AEJhFk2EgpqxiJpqN
	 K5ddVUIX5vyQ2oG506Lo4RoZb4mroQ3mC82kdnClX357rt65Apd2jXKNF7D4a1L52n
	 gCbylA2pq4R6Sq0TWSaksmIalygSpA1XZTySr5pg=
Date: Tue, 16 Dec 2025 10:58:23 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch added to mm-new branch
Message-Id: <20251216185823.F1872C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for max_nr_snapshots
Date: Tue, 16 Dec 2025 00:01:23 -0800

Update DAMON usage document for the newly added DAMON sysfs interface
file, max_nr_snapshots.

Link: https://lkml.kernel.org/r/20251216080128.42991-11-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -87,7 +87,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ ...
@@ -543,10 +543,11 @@ online analysis or tuning of the schemes
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds`` and ``nr_snapshots``), respectively.
-The files are not updated in real time, so you should ask DAMON sysfs interface
-to update the content of the files for the stats by writing a special keyword,
-``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
+``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
+``max_nr_snapshots``), respectively.  The files are not updated in real time,
+so you should ask DAMON sysfs interface to update the content of the files for
+the stats by writing a special keyword, ``update_schemes_stats`` to the
+relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
 
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

