Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333F93B79F
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958116; cv=none; b=RBFwFZ0q9R4e28ZQO5lHQA/y1jTWiwdMZe785+Jb/x5zkfPZTsomiFs7nq61ZUiv3weeDywXqchOlT5kGGW0JNe96yIutvyH+mV8SnQ1h1sk3tZ8l9RGFRNG/8AqB/uYceRWWvpqwt0zR4hCa++Z2z1IsF+ugEMpIHJV3WtpiAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958116; c=relaxed/simple;
	bh=J7gRVIQezlWANa4SfsfaNahuLFU98WQQ8Db42iTKG64=;
	h=Date:To:From:Subject:Message-Id; b=coqBnzmzhx2p1AQGCJbIZPBW7EwzDTKVbFdUW9c5//+MJ2iYUP0x5WW3SqKSniWqQDGHh2WKWeEA7VtLI048ubGl/SztroOZKHCJVD8cVrhGE8Wj1g7zgWKxNSJzXVtCMI1WCAULyV3/4nXZrXJKLyFO/6JAGI6SoOFY/YWhdiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=umF6r6Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="umF6r6Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45EC113CC;
	Mon,  6 May 2024 01:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958116;
	bh=J7gRVIQezlWANa4SfsfaNahuLFU98WQQ8Db42iTKG64=;
	h=Date:To:From:Subject:From;
	b=umF6r6IdYkCc0QnzFGuHITe3GQjo02/ZtnrlY84pFtlyNDg3FAoUXvf7KnY4VtFGI
	 sC/VbAkutzjWn7mgt5xzChImW/RiJf77iE5eaIAuPzgYPGn3ALFBPuhLEW7I0q5qvX
	 9iStKFJnvyaTMNAhE0ZR5hAlFosx8FbFyFAO3qqs=
Date: Sun, 05 May 2024 18:15:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,song@kernel.org,peterz@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-watchdog_perfc-tidy-up-kerneldoc.patch removed from -mm tree
Message-Id: <20240506011515.DD45EC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel/watchdog_perf.c: tidy up kerneldoc
has been removed from the -mm tree.  Its filename was
     kernel-watchdog_perfc-tidy-up-kerneldoc.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/watchdog_perf.c: tidy up kerneldoc
Date: Sat May  4 04:41:07 PM PDT 2024

It is unconventional to have a blank line between name-of-function and
description-of-args.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog_perf.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/watchdog_perf.c~kernel-watchdog_perfc-tidy-up-kerneldoc
+++ a/kernel/watchdog_perf.c
@@ -148,7 +148,6 @@ static int hardlockup_detector_event_cre
 
 /**
  * watchdog_hardlockup_enable - Enable the local event
- *
  * @cpu: The CPU to enable hard lockup on.
  */
 void watchdog_hardlockup_enable(unsigned int cpu)
@@ -167,7 +166,6 @@ void watchdog_hardlockup_enable(unsigned
 
 /**
  * watchdog_hardlockup_disable - Disable the local event
- *
  * @cpu: The CPU to enable hard lockup on.
  */
 void watchdog_hardlockup_disable(unsigned int cpu)
@@ -277,7 +275,6 @@ int __init watchdog_hardlockup_probe(voi
 
 /**
  * hardlockup_config_perf_event - Overwrite config of wd_hw_attr.
- *
  * @str: number which identifies the raw perf event to use
  */
 void __init hardlockup_config_perf_event(const char *str)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

