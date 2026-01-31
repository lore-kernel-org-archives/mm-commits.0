Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8870638A73C
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898332; cv=none; b=XIe+lBHLikESENSGDaNpRlOk7bHWTqBI+h1ujmEbJ/JoTdRQ7s2v0f0CmC8vcqDqrisiJgNBFDKWOcVsnSDNTR9NeUxXdG5lqBBRH7mceQR0J2CVtF3lWztTc+EwxmMDeyI9Ucf383JfpVHO5UaAyzIuWVzAft3VlVZF2yDA11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898332; c=relaxed/simple;
	bh=JMB9AEQu6Ag8jPSycqH7x2pAiwsSr4SqbWunQ6KZKMs=;
	h=Date:To:From:Subject:Message-Id; b=mNbZWRf1zs82b729C+z/uLMcQGW9h0s27B2ZO7uVN8ZDsPz/hS7N2pOHXbKeIw/6A6DpqEVHfmI43JVIltTtV00IPOp/U4JOwK3R+fEu9E2qwoFdGum2VcHeEYP7E3d7pYOS3sDLnJm90GA9EXC1GPrtkyg60vRyH8xwelCfSQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UGu30Ori; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UGu30Ori"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07193C4CEF1;
	Sat, 31 Jan 2026 22:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898332;
	bh=JMB9AEQu6Ag8jPSycqH7x2pAiwsSr4SqbWunQ6KZKMs=;
	h=Date:To:From:Subject:From;
	b=UGu30OriFuiia/X5jr8o9FKlGmqVnAY1NyoTx117xkQWQHEWUrJ1ArgaPmpyaf+OI
	 Q0EUAQKNteWeq6BN67p1YT6QKikrDpvMnnwOeePBqID/rZ0Sxb3ROBRt8DHk8TbSal
	 gKas37x8mPBOBRg8Lx/JZ+HrWpk6e9FZMUIm4HEs=
Date: Sat, 31 Jan 2026 14:25:31 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch removed from -mm tree
Message-Id: <20260131222532.07193C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/wss_estimation: deduplicate failed samples output
has been removed from the -mm tree.  Its filename was
     selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/wss_estimation: deduplicate failed samples output
Date: Fri, 16 Jan 2026 18:07:28 -0800

When the test fails, it shows whole sampled working set size measurements.
The purpose is showing the distribution of the measured values, to let
the tester know if it was just intermittent failure.  Multiple same values
on the output are therefore unnecessary.  It was not a big deal since the
test was failing only once in the past.  But the test can now fail
multiple times with increased working set size, until it passes or the
working set size reaches a limit.  Hence the noisy output can be quite
long and annoying.  Print only the deduplicated distribution information.

Link: https://lkml.kernel.org/r/20260117020731.226785-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-wss_estimation-deduplicate-failed-samples-output
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -53,7 +53,11 @@ def pass_wss_estimation(sz_region):
             print('the error rate is not acceptable (> %f)' %
                     acceptable_error_rate)
             print('samples are as below')
-            print('\n'.join(['%d' % wss for wss in wss_collected]))
+            for idx, wss in enumerate(wss_collected):
+                if idx < len(wss_collected) - 1 and \
+                        wss_collected[idx + 1] == wss:
+                    continue
+                print('%d/%d: %d' % (idx, len(wss_collected), wss))
             return False
     return True
 
_

Patches currently in -mm which might be from sj@kernel.org are


