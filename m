Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B3A67C44;
	Thu,  8 Feb 2024 05:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369691; cv=none; b=HizoOroGgk6MWCHhWMkej13esiUdKE+j56pIwE84pvvPaI08wgJQiK6aHwivG6KDNlsx33Al1UE0+0DeFv3Zcta8OTkUaf61UNOBh/koo9tJP18+CyWuxhNcPlXMgoUtLoyxjr0oh2j4Xa5nNxPZKyzyXe6m44GAu6/QvPLfv1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369691; c=relaxed/simple;
	bh=XfR4l1vEvKpGWTr+XZR4CMNCGa6XQZCOwRZyjX4KgVY=;
	h=Date:To:From:Subject:Message-Id; b=KjLMM6jtJRLax7iRtCd0numu2LQaFwH7P/PI8195L7aAVoAR3+5eh9gx8He/CrV2sMxtCVZwooib20pydan6dNZ2Wvtu+CvvVDOGDHJDBvObx4VKAlSCQiaUWPSWVcv0awmuc6Rpsi/hEzVzDaChT9HHHanF9LZLMKGZR2ADY3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qjDNZAk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qjDNZAk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BA6C43394;
	Thu,  8 Feb 2024 05:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369691;
	bh=XfR4l1vEvKpGWTr+XZR4CMNCGa6XQZCOwRZyjX4KgVY=;
	h=Date:To:From:Subject:From;
	b=qjDNZAk64NAIE8/J6b1C/MVFgDg5UI84G74hfL4VqHnBmRuIwzP429EH6uV3PIgYE
	 RQttts0bqEhbQWumsXiUn+q3lTYr2gLhrdsqnCwQfKjfRaUi5S6FNX2zVIxbY+d11C
	 FQkhZUW6LMM8zPYE3jpTQ8yq7MnK5XTfE6Q+k8Cw=
Date: Wed, 07 Feb 2024 21:21:30 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch removed from -mm tree
Message-Id: <20240208052130.E0BA6C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: fix wrong DAMOS tried regions update timeout setup
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: fix wrong DAMOS tried regions update timeout setup
Date: Fri, 2 Feb 2024 11:19:56 -0800

DAMON sysfs interface's update_schemes_tried_regions command has a timeout
of two apply intervals of the DAMOS scheme.  Having zero value DAMOS
scheme apply interval means it will use the aggregation interval as the
value.  However, the timeout setup logic is mistakenly using the sampling
interval insted of the aggregartion interval for the case.  This could
cause earlier-than-expected timeout of the command.  Fix it.

Link: https://lkml.kernel.org/r/20240202191956.88791-1-sj@kernel.org
Fixes: 7d6fa31a2fd7 ("mm/damon/sysfs-schemes: add timeout for update_schemes_tried_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-fix-wrong-damos-tried-regions-update-timeout-setup
+++ a/mm/damon/sysfs-schemes.c
@@ -2194,7 +2194,7 @@ static void damos_tried_regions_init_upd
 		sysfs_regions->upd_timeout_jiffies = jiffies +
 			2 * usecs_to_jiffies(scheme->apply_interval_us ?
 					scheme->apply_interval_us :
-					ctx->attrs.sample_interval);
+					ctx->attrs.aggr_interval);
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch

