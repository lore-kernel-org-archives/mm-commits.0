Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6F938A9DF
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898352; cv=none; b=IdEM7fJPX40mWSQ2UKpXzaqSis9+zNsqLMOzZtDqWFgUnQXrxNm+j8ecIOdJihH6t/rTPgy7c2TsBgLH2aH+suxIP9eaf/Qzw6OEAhIxRqjXvSFl3N9MglhEkCSUnavbKXZa2B81TTEU5lhl6f0cN+UHvgrRG19r0CdZtctGvhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898352; c=relaxed/simple;
	bh=jlUeBHlRahXH9vNQMZSaDDjGkv/fSj85TIZe1KUHFko=;
	h=Date:To:From:Subject:Message-Id; b=L+dJW6LXVxt94VOA/T70BNADg1XhI9bXMSoO+aOzQSsLJOz3RncxOa2WVDaU6mextWopizgC+BjVzTbXNqsLugQqcxfC0OMPCXELOdOeVEVwvS5nQWCPZenWDPIzTnBUKbSUi8zLNFVOAJU64ePSWSaqsG8P7VJyHFbQsJVfF4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EjYq8Tj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EjYq8Tj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BDAC4CEF1;
	Sat, 31 Jan 2026 22:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898351;
	bh=jlUeBHlRahXH9vNQMZSaDDjGkv/fSj85TIZe1KUHFko=;
	h=Date:To:From:Subject:From;
	b=EjYq8Tj4WkWF3tcdnNpT3qQRXaZXghN31v0uhcKKk2uh5czsS/V97NJJ66tfyo7o+
	 5i9Z6QdSWHVcVuJRmmRaJ8w1cUDC6jzPuANoCE1ZB8VOc2Pt2MGh1lqHE/6l+0pv4E
	 5wuNZJPvNj74WK/zeihBeflElylpjEI7fSVm5uLU=
Date: Sat, 31 Jan 2026 14:25:51 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch removed from -mm tree
Message-Id: <20260131222551.95BDAC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update stats update process for refresh_ms
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update stats update process for refresh_ms
Date: Sun, 18 Jan 2026 10:02:57 -0800

DAMOS stats on sysfs was only manually updated.  Recent addition of
'refresh_ms' knob enabled periodic and automated updates of the stats. 
The document for stats update process is not updated for the change,
however.  Update.

Link: https://lkml.kernel.org/r/20260118180305.70023-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -549,10 +549,13 @@ online analysis or tuning of the schemes
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
 ``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
-``max_nr_snapshots``), respectively.  The files are not updated in real time,
-so you should ask DAMON sysfs interface to update the content of the files for
-the stats by writing a special keyword, ``update_schemes_stats`` to the
-relevant ``kdamonds/<N>/state`` file.
+``max_nr_snapshots``), respectively.
+
+The files are not updated in real time by default.  Users should ask DAMON
+sysfs interface to periodically update those using ``refresh_ms``, or do a one
+time update by writing a special keyword, ``update_schemes_stats`` to the
+relevant ``kdamonds/<N>/state`` file.  Refer to :ref:`kdamond directory
+<sysfs_kdamond>` for more details.
 
 .. _sysfs_schemes_tried_regions:
 
_

Patches currently in -mm which might be from sj@kernel.org are


