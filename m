Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8510912AAE2
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559129; cv=none; b=R0dNGLiPmRelqjuuMwlUpwgNPvMr5nEyx3GDAtD1kmi9dVIX//ZXaFeMVmyWbvNurdKHV8ZB7ZCzdYQJ/yfJZ1tUdaJfrpzXvDtz9luKRLLTO7IB7VXha50mWyQ7MvVUlG43GQqVp8AFSJtFO7wy8ktImszOMWQu29tcigZK/yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559129; c=relaxed/simple;
	bh=KfJ7fkpIY1l5TBSPRE+bldwIhpv1kn76z2HbWruZL68=;
	h=Date:To:From:Subject:Message-Id; b=H4HXIfd1MKm9xGRsw9igZJJtmm+nNljxvgClC6FbG1jb/Vd8L+dfF63prGQzCZN2gR+BcyaEvLjpJ8HlLw8dOucZTX1GBx6y5D4vGowj2VMzua0B6UKG4jCwtV9PoAwy/3Hbvi4WfwmgWOpp0GBDEIklfTf/teN3PKav6W/cQPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uvGxYJ1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uvGxYJ1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF187C43390;
	Wed, 21 Feb 2024 23:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559129;
	bh=KfJ7fkpIY1l5TBSPRE+bldwIhpv1kn76z2HbWruZL68=;
	h=Date:To:From:Subject:From;
	b=uvGxYJ1LU+9gBypCiOmzHq5ZtwyxVP9lrZKqmVOj+8DcBcUvZurBblZCLcvXzwD03
	 R6JKxKkHzmXpNuUoalFXii+UnGgR3r9+W/T50M1Rn0EiAJlocdzV3tqVHdn4ZILHov
	 fKdiJxV5E/kHcUFfKC7ACVlPriTXP1Jd3eT5xG0w=
Date: Wed, 21 Feb 2024 15:45:28 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch removed from -mm tree
Message-Id: <20240221234528.EF187C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_xarray-fix-soft-lockup-for-advanced-api-tests-fix
has been removed from the -mm tree.  Its filename was
     test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch

This patch was dropped because it was folded into test_xarray-add-tests-for-advanced-multi-index-use.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: test_xarray-fix-soft-lockup-for-advanced-api-tests-fix
Date: Mon Feb 19 06:23:18 PM PST 2024

s/i/loops/, make non-static

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix-fix
+++ a/lib/test_xarray.c
@@ -728,7 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
-	static unsigned int i = 0;
+	unsigned int loops = 0;
 
 	rcu_read_lock();
 repeat:
@@ -746,7 +746,7 @@ repeat:
 	 * APIs won't be stupid, proper page cache APIs loop over the proper
 	 * order so when using a larger order we skip shared entries.
 	 */
-	if (++i % XA_CHECK_SCHED == 0)
+	if (++loops % XA_CHECK_SCHED == 0)
 		schedule();
 
 	return p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

test_xarray-add-tests-for-advanced-multi-index-use.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix-fix.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

