Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454923;
	b=jITaeUF1irV4HTIET/k7L5xmZC45qoyXboo4MwMA8SXC1z8sLeKmT/zxsUtb3saYBVVa
	 JtnF58tWSEWMCIl4NZmDIq4HZxdF9Z8C8MgfhtwGQomt2KlEV34Y6iiYnn43DFG5omewx
	 lKYnUOx1qzJAAk5IbnPUTRzUx6JGdqC68BR36u9dF3dzy8NcPV18EPfdPGUgm/3Jz7S+R
	 QUyFGjqDIO46q5D7dA+4cK8qH4ZjKj6e1zRBAt2jFugWpEhAivXvWX0odIEs2b5k3hsG7
	 Vygn3bUoq4/xeudjJ0Bgs7oj6kCtkCEF5zLflyH4aC1BUGxpYwvmdXZllJ0JgKTC3og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454923;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=mfuItOLagBcEETEGaoFjlTh8TTnArXbmLULyXuk3SwY=;
	b=X+uQWA2OMB44+1eyw1sGUyYReHRdRjoEoYsCq2LG5o9lHFU0J5r0MFcWZmoFr8ta8Bob
	 ZntOX9zkPNgUFy+gJDnD90PKdisFQQZgo6BvRK4w78R/kkYRxfQRBVO+fQbTIiNVkFxxK
	 +9ThzcItHUjvsXxUFtL52me+WywsywwvyfM/7YQwcAapZAecuk3WRq5UECX5XGe0hBTrA
	 RVCp8b7rfSTMZDOeEKujpIDAoN7tq6b8LkHes4TV5GSXyUAAZpneoqYWXV7Gx8vUA253V
	 EF54dfwPCd/fNhclMND11aDKhr8y4n3yKm0PwveyCh82bRofdm74Q1bxmZESxB1uymg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pt0xke92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0C7606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Pt0xke92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E81C1F000C0;
	Mon, 23 Nov 2026 17:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795454922;
	bh=mfuItOLagBcEETEGaoFjlTh8TTnArXbmLULyXuk3SwY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Pt0xke92nJi9og0Ia//lTVw+hpr7EP6SSeDlrNlDWwFeWgm0irmzefSeZEaRrzGPQ
	 GJyLEEL5bVa0etlrJ/sUc2wRa228P32+zO8yAdf6Hc58I1ryo/ZKYrw70DJmYVbStz
	 t2dBZmTDByScnL5MJhe2qlqwQZCdvW6fmzvcb+h0=
Date: Mon, 23 Nov 2026 09:28:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,mattathias.pinchover@uber.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123151309.82675-3-sj@kernel.org>
References: <20261123151309.82675-3-sj@kernel.org>
Subject: + mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch added to mm-new branch
Message-Id: <20261123172842.1E81C1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Subject: mm/damon/sysfs-schemes: add sz_ops_filter_passed_last file
Date: Mon, 23 Nov 2026 07:13:03 -0800

Introduce a new DAMON sysfs interface file for exposing the newly added
DAMOS stat, sz_ops_filter_passed_last.  The file has the same
name as the stat and is placed under the DAMOS stats directory.  Like
other stats files, it is updated when the stats are refreshed via
refresh_ms or the update_schemes_stats command.

Link: https://patch.msgid.link/20261123151309.82675-3-sj@kernel.org
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>

 mm/damon/sysfs-schemes.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file
+++ a/mm/damon/sysfs-schemes.c
@@ -370,6 +370,7 @@ struct damon_sysfs_stats {
 	unsigned long nr_applied;
 	unsigned long sz_applied;
 	unsigned long sz_ops_filter_passed;
+	unsigned long sz_ops_filter_passed_last;
 	unsigned long qt_exceeds;
 	unsigned long nr_snapshots;
 	unsigned long max_nr_snapshots;
@@ -425,6 +426,15 @@ static ssize_t sz_ops_filter_passed_show
 	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed);
 }
 
+static ssize_t sz_ops_filter_passed_last_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_stats *stats = container_of(kobj,
+			struct damon_sysfs_stats, kobj);
+
+	return sysfs_emit(buf, "%lu\n", stats->sz_ops_filter_passed_last);
+}
+
 static ssize_t qt_exceeds_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -485,6 +495,9 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_attr =
 		__ATTR_RO_MODE(sz_ops_filter_passed, 0400);
 
+static struct kobj_attribute damon_sysfs_stats_sz_ops_filter_passed_last_attr =
+		__ATTR_RO_MODE(sz_ops_filter_passed_last, 0400);
+
 static struct kobj_attribute damon_sysfs_stats_qt_exceeds_attr =
 		__ATTR_RO_MODE(qt_exceeds, 0400);
 
@@ -500,6 +513,7 @@ static struct attribute *damon_sysfs_sta
 	&damon_sysfs_stats_nr_applied_attr.attr,
 	&damon_sysfs_stats_sz_applied_attr.attr,
 	&damon_sysfs_stats_sz_ops_filter_passed_attr.attr,
+	&damon_sysfs_stats_sz_ops_filter_passed_last_attr.attr,
 	&damon_sysfs_stats_qt_exceeds_attr.attr,
 	&damon_sysfs_stats_nr_snapshots_attr.attr,
 	&damon_sysfs_stats_max_nr_snapshots_attr.attr,
@@ -3130,6 +3144,8 @@ void damon_sysfs_schemes_update_stats(
 		sysfs_stats->sz_applied = scheme->stat.sz_applied;
 		sysfs_stats->sz_ops_filter_passed =
 			scheme->stat.sz_ops_filter_passed;
+		sysfs_stats->sz_ops_filter_passed_last =
+			scheme->stat.sz_ops_filter_passed_last;
 		sysfs_stats->qt_exceeds = scheme->stat.qt_exceeds;
 		sysfs_stats->nr_snapshots = scheme->stat.nr_snapshots;
 	}
_

Patches currently in -mm which might be from mattathias.pinchover@uber.com are

mm-damon-core-introduce-sz_ops_filter_passed_last-stat.patch
mm-damon-sysfs-schemes-add-sz_ops_filter_passed_last-file.patch
mm-damon-tests-core-kunit-test-sz_ops_filter_passed_last.patch
docs-mm-damon-design-update-for-sz_ops_filter_passed_last.patch
docs-admin-guide-mm-damon-usage-update-for-sz_ops_filter_passed_last.patch
docs-abi-damon-update-for-sz_ops_filter_passed_last.patch

