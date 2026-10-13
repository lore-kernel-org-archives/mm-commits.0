Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD13480DFC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865933; cv=none; b=MZ3bgLo4+3HaoGM5YVwQoQF6tcrqKrBAw229TjWfT7TpVmJVPsJ6+evx4PikQ3OGHH1D4kOp1lPoSrxznpLAo9QKWZzrC2DkAV2OdwCjbE2GfOhNoDGWTdlRTEU//g+xC49+p0xbX/90WHl/Q6JG/gxdcmhnimNc1oNPLRFoTjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865933; c=relaxed/simple;
	bh=s9tBbQNUrP/1dBhH/pfxhr4FBCdz1ymMV1AUGBhTQB0=;
	h=Date:To:From:Subject:Message-Id; b=lpzB2AkrutESp7JQnH+slJNIXImg9MjD0jtJZtG3mrfYTKYYtM0wGfzLZ92Hejl6+AsTA3TGDifSgOjmkWlrtoi6PD7geZKMRjyL74d1v2Nd3q6pSL/iTjrHenrhMYZAGhEfKxmmjkw6wSEsXM5TKyFJ6MCHcq7AJAg+vFZLV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HubJ5gk4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HubJ5gk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E01F00893;
	Tue, 13 Oct 2026 04:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865932;
	bh=Z+zeV40tqlZ9TTetZiFWGtEQDGcxVT1VcDxtqMBG3QE=;
	h=Date:To:From:Subject;
	b=HubJ5gk49kkxV06mF1MRFPku6MdssJ8jAm1/Ul2cz3yCvfHyu+vz+rybB+f3h/LGi
	 4022usT9gihW/9HnghfPNMvjqmQkAgTKcwyRHTkKgTgsR1VH/O5VGxxXhXCROXG9OM
	 d+mo3DJtnQHUCtIC++CUFuQHcqM/Sd0tVwDRlzMg=
Date: Mon, 12 Oct 2026 21:32:12 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-support-hugepage_size-probe-filter.patch removed from -mm tree
Message-Id: <20261013043212.623E01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: support hugepage_size probe filter
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-support-hugepage_size-probe-filter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: support hugepage_size probe filter
Date: Tue, 15 Sep 2026 07:33:54 -0700

Extend DAMON sysfs interface to support hugepage_size probe filter. 
Allows hugepage_size user string input to the filter type file.  Pass the
size range argument that users set via min/max files under the probe
filter directory to the DAMON core.

Link: https://lore.kernel.org/20260915143359.91472-6-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/damon/sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-support-hugepage_size-probe-filter
+++ a/mm/damon/sysfs.c
@@ -1007,6 +1007,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
 		.name = "pgidle_set",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
+		.name = "hugepage_size",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2273,6 +2277,9 @@ static int damon_sysfs_set_filters(struc
 				damon_destroy_filter(filter);
 				return err;
 			}
+		} else if (filter->type == DAMON_FILTER_TYPE_HUGEPAGE_SIZE) {
+			filter->range_min = sys_filter->range_min;
+			filter->range_max = sys_filter->range_max;
 		}
 		damon_add_filter(probe, filter);
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

