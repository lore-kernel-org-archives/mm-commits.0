Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795891903;
	b=d7k4qAbsHbYbIblG8FfrME04R+1iFzygRdAxbwtlumAtqTXsfaeLXIodPPVyISZM3aMz
	 VOAXtvnxydTUS4Rvm5O01DhTB3F+jRP6lekhAAHXS/8EGFZmeMqNbw508hh1l1aYZ4Q7K
	 MujuDNks2mwQy7z671d21bogJnYqxIfUmer3H6DyajCaoHW1azkFTEeGNVaAI1N717VkV
	 X88fd35NTdoQSvicjT5agisnapS+JqAJkweIniVrNxrt/vmlIXmQ5ELLUTnb4XPG14k9g
	 1XDJQv2rMMgyy/sMDZ86ErEppdLQ7jPjeReOl65KqLX20bCil5t3vnVWEbE5TcpZ2Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795891903;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=6UY2zCyUDsZwRke+bDmcggDJpwK/lUOLuN8MR/gBOFQ=;
	b=4pwCs3VrOYmSA14rBcEt7/khB+s7l4ySXAeLLgUzL/0N3NRVhRo1yQxQNrC4qCU/JSQE
	 4HEeGpccJda8HBIfG4crFdXw46KCLLIiCGxv/xl2lGeABo9vXgMyo+acDIyAftuY78VG4
	 lf/8DNekYktHeEHpOfZrAcrJZALggEJOJdN1rdjVTvdhigkAyhuj8zD0dkK/LL9PkfXty
	 Eg5ZqCMGzQnt0aKLCnyECIk1Fi9BcaY52me/2fD/Y+ldLT8XvoVd5xc02FPH4olHLglXf
	 8z+IyvX8zR7LVUuRCLqNZsSTbOm574yOSXyMaygM2zE721m7lEUQg37Ph3NdA7tFYUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YlxVYd1g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BE8606A31C;
	Sat, 28 Nov 2026 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YlxVYd1g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B0A11F00897;
	Sat, 28 Nov 2026 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795891903;
	bh=6UY2zCyUDsZwRke+bDmcggDJpwK/lUOLuN8MR/gBOFQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=YlxVYd1gffJ95aw6Kxk1aHNOjzvJ+O8vrD1oI4IE/W9Qgm0morQQe2VkSZTRSNttZ
	 kv4BVSAwbMIG9cVADe7HMDKiI+z35vsqnZE17CGXDwkdBUUeFTUfWzBakqEU6u7Xu2
	 V/zt4e8j8RoDHYBwV1r7JxqsEuZ6kIkf8UsdO/sc=
Date: Sat, 28 Nov 2026 10:51:42 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,linruifeng4@huawei.com,
	sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261128184311.161492-1-sj@kernel.org>
References: <20261128184311.161492-1-sj@kernel.org>
Subject: + mm-damon-core-let-kdamond-freezable.patch added to mm-hotfixes-unstable branch
Message-Id: <20261128185143.2B0A11F00897@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: make kdamond freezable
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-let-kdamond-freezable.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-let-kdamond-freezable.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: make kdamond freezable
Date: Sat, 28 Nov 2026 10:43:10 -0800

DAMON's worker threads, kdamonds, are not freezable.  If DAMOS is set, it
could migrate or reclaim pages while the hibernation image is being
copied.  It could corrupt the resulting image.  As a result the system
could run with the corrupted memory after resuming from hibernation.

Users could work around by stopping or pausing the kdamond before the
hibernation imaging is started.  But it is easy to forget.  Just make it
freezable.

The user impact is quite bad.  Nonetheless, the problem is only found by
the theory.  No real issue from such memory corruption is found and
reported so far.

This change was originally suggested [1] by Lin Ruifeng.

Link: https://patch.msgid.link/20261128184311.161492-1-sj@kernel.org
Fixes: af122dd8f3c0 ("mm/damon/dbgfs: support DAMON-based Operation Schemes")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Lin Ruifeng <linruifeng4@huawei.com>
Link: https://lore.kernel.org/20260408080652.1745410-1-linruifeng4@huawei.com [1]
Cc: <stable@vger.kernel.org> # 5.16.x

 mm/damon/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-let-kdamond-freezable
+++ a/mm/damon/core.c
@@ -7,6 +7,7 @@
 
 #include <linux/damon.h>
 #include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/memcontrol.h>
 #include <linux/mm.h>
@@ -3845,7 +3846,7 @@ static bool kdamond_need_stop(struct dam
 {
 	struct damon_target *t;
 
-	if (kthread_should_stop())
+	if (kthread_freezable_should_stop(NULL))
 		return true;
 
 	if (!ctx->ops.target_valid)
@@ -4056,6 +4057,7 @@ static int kdamond_fn(void *data)
 
 	sz_limit = damon_apply_min_nr_regions(ctx);
 
+	set_freezable();
 	while (!kdamond_need_stop(ctx)) {
 		/*
 		 * ctx->attrs and ctx->next_{aggregation,ops_update}_sis could
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-let-kdamond-freezable.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch
mm-damon-core-add-damos_filter_type_age_ms.patch
mm-damon-sysfs-schemes-support-damos_filter_type_age_ms.patch
docs-mm-damon-design-update-for-age_ms-damos-core-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-age_ms-damos-core-filter.patch
mm-damon-api-define-damon_filter_type_active.patch
mm-damon-ops-common-implement-damon_filter_type_active-operation.patch
mm-damon-sysfs-support-lru-activeness-based-damon-filter-setup.patch
docs-mm-damon-design-update-for-damon_filter_type_active.patch
maintainers-change-damon-scm-tree-to-mm-damongit.patch
docs-mm-damon-maintainer-profile-use-damongit-for-patch-baselines.patch
docs-mm-damon-maintainer-profile-drop-scm-trees-section.patch
docs-mm-damon-maintainer-profile-update-key-cycle-dates-for-damongit.patch
mm-damon-api-introduce-struct-damon_report.patch
mm-damon-core-implement-data-attribute-report-queue.patch
mm-damon-core-introduce-damon_submit_report.patch
mm-damon-sysfs-add-admin-reports-directory.patch
mm-damon-sysfs-add-reports-producers-directory.patch
mm-damon-sysfs-add-producers-nr_producers-file.patch
mm-damon-sysfs-implement-report-producer-directory.patch
mm-damon-sysfs-implement-report-producer-type-and-state-files.patch
docs-mm-damon-design-update-for-report-system.patch
docs-admin-guide-mm-damon-usage-update-for-report-producer-sysfs.patch
docs-abi-damon-update-for-report-producer-sysfs-files.patch
mm-damon-core-introduce-damon_filter_type_report_made.patch
mm-damon-core-introduce-damon_report_exist.patch
mm-damon-paddr-support-report_made-type-probe-filter.patch
mm-damon-sysfs-add-filter_report_type-file-under-probe-filter-directory.patch
mm-damon-sysfs-support-report_made-type-probe-filter-setup.patch
docs-mm-damon-design-update-for-report_made-probe-filter-type.patch
docs-admin-guide-mm-damon-usage-update-for-report_made-probe-filter.patch
docs-abi-damon-update-for-report_made-probe-filter.patch
mm-damon-api-introduce-user_report-report-type.patch
mm-damon-sysfs-add-user_report-support-for-report-type-input.patch
mm-damon-sysfs-implement-report-producer-addr_startend-files.patch
mm-damon-sysfs-implement-submit-command-for-report-producer.patch
selftests-damon-sysfssh-add-basic-tests-for-admin-reports.patch
docs-mm-damon-design-update-for-user-report-support.patch
docs-admin-guide-mm-damon-usage-update-for-user_report-report-support.patch
docs-abi-damon-update-for-user_report-report-support.patch

