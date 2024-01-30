Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A1D38DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597075; cv=none; b=bE9ddcHg6BrlYlwkMOqBKQ9tB/90rTwlID2uyZFhQzPgBdJYDoo0i0TQvVadZ+v4E1XKQHe9gW96wGX4QQlKSes4t8AjfPLjVovojc23/ZqfqgGHEHiDddxsEtqMWJbHc4EoUcmzq61glpOSREJltMz7PMZg7C+zPPBmmjzMf1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597075; c=relaxed/simple;
	bh=ka5EI5TuXTpbFKojzzSF/Ux8h/PSg/s6u7A+gXf7/1E=;
	h=Date:To:From:Subject:Message-Id; b=t7kW+sP3RRR0DCwYijY9Z5OGwnonOoz2R8nL0zGHqdRbwg8U8k9Qr7aHRWfrUS2DewfOVUwdfoLvIucFe83ck8yJL9JdIsLawB/fknDvW+xDGiQqfUksC+11Jr53j1DQe5ldTFAtPZlqthQjVfVi4GKyXd6a1lu1u6T+jFU7+ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PI8CHtxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PI8CHtxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677F0C433C7;
	Tue, 30 Jan 2024 06:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597075;
	bh=ka5EI5TuXTpbFKojzzSF/Ux8h/PSg/s6u7A+gXf7/1E=;
	h=Date:To:From:Subject:From;
	b=PI8CHtxdIujG7W796YoGtKvjFMvecwgtnCU0y8IZllnbyiGXVSlhQ674/95NhcD9O
	 9KenWb6oMr3MJKCwH6B3k04P1dVVPVuUIsmeJ5mMzNAtWafyohBwl7Ifvcv09SIugB
	 DMfAqbfOirHf1gWQtVrfbm+3YMK4bQ6F0HDSubA0=
Date: Mon, 29 Jan 2024 22:44:22 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch added to mm-unstable branch
Message-Id: <20240130064433.677F0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: use sysfs interface for tracepoints example
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: use sysfs interface for tracepoints example
Date: Mon, 29 Jan 2024 17:35:40 -0800

Patch series "mm/damon: make DAMON debugfs interface deprecation
unignorable".

DAMON debugfs interface is deprecated in February 2023, by commit
5445fcbc4cda ("Docs/admin-guide/mm/damon/usage: add DAMON debugfs
interface deprecation notice").  Make the fact unable to be easily ignored
by removing an example usage from the document (patch 1), renaming the
config (patch 2), adding a deprecation notice file to the debugfs
directory (patches 3-5), and renaming the debugfs file that essnetial to
be used for real use of DAMON (patches 6-9).


This patch (of 9):

DAMON tracepoints example on the DAMON usage document is using DAMON
debugfs interface, which is deprecated.  Use its alternative, DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20240130013549.89538-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240130013549.89538-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -579,11 +579,11 @@ monitoring results recording.
 While the monitoring is turned on, you could record the tracepoint events and
 show results using tracepoint supporting tools like ``perf``.  For example::
 
-    # echo on > monitor_on
+    # echo on > kdamonds/0/state
     # perf record -e damon:damon_aggregated &
     # sleep 5
     # kill 9 $(pidof perf)
-    # echo off > monitor_on
+    # echo off > kdamonds/0/state
     # perf script
     kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
     [...]
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch

