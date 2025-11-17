Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2DC21A447
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343255; cv=none; b=BNkdzkVE1wwqNV7frJL6p7o9bCr42VHfgy7UtJhMrg+X72BoomzAc2N86kP31GEcSn3tGh/XEbLdA4qrRdb8T6R6/Vo6p2MEni8UOFDBOFH8k6/n8tk6YpBa3q9FQcCh3wZTAN2lhhPMEU8SehLhKBBcKF9Vdz/GvbJnRxVL/Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343255; c=relaxed/simple;
	bh=WQ8Asy39zDcA73JJwWhrq+5N4Ci1znKwpdwS4RBFa9E=;
	h=Date:To:From:Subject:Message-Id; b=hHKvkk1bJ5NrH1BnFVuEo/GlrKEVcpvWduZMz8e6JXF9HFrhjujPWu6gr9inc0KLO21Kji72Wxz/YLl6W4kGLkuPR7Rcx6UrbuQrpwQiHUwcLbUrMar9Qon1+hCgbsw6u38XUIhi6N9+E9mpuKAuw0UwBsJiRR5JgcQst4d7kBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLYCHCQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLYCHCQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1798C16AAE;
	Mon, 17 Nov 2025 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343255;
	bh=WQ8Asy39zDcA73JJwWhrq+5N4Ci1znKwpdwS4RBFa9E=;
	h=Date:To:From:Subject:From;
	b=DLYCHCQ7pueGJUd8Q5cbCOmniZLaYUDsGnt0CIhV7h/bkd6Ksg/MA4/h6Uxw7U/8F
	 Dfp+4mEwGiVkhlw3GCQnMM/lTf9QNwmHf2m9Y49kyVK2zed8EM5YuyEy1wjrF0HFJ4
	 ESlJnQWbEjdtzlB3U76D5ZiAf6oJGknod4K38RFc=
Date: Sun, 16 Nov 2025 17:34:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-implement-obsolete_target-file.patch removed from -mm tree
Message-Id: <20251117013415.B1798C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: implement obsolete_target file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-implement-obsolete_target-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement obsolete_target file
Date: Wed, 22 Oct 2025 18:25:27 -0700

There is no good way to remove DAMON targets in the middle of the existing
targets list.  It restricts efficient and flexible DAMON use cases. 
Improve the usability by implementing a new DAMON sysfs interface file,
namely obsolete_target, under each target directory.  It is connected to
the obsolete field of parameters commit-source targets, so allows removing
arbitrary targets in the middle of existing targets list.

Note that the sysfs files are not automatically updated.  For example,
let's suppose there are three targets in the running context, and a user
removes the third target using this feature.  If the user writes 'commit'
to the kdamond 'state' file again, DAMON sysfs interface will again try to
remove the third target.  But because there is no matching target in the
running context, the commit will fail.  It is the user's responsibility to
understand resulting DAMON internal targets list change, and construct
sysfs files (using nr_targets and other sysfs files) to correctly
represent it.

Also note that this is arguably an improvement rather than a fix of broken
things.

Link: https://lkml.kernel.org/r/20251023012535.69625-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Bijan Tabatabai <bijan311@gmail.com>
Closes: https://github.com/damonitor/damo/issues/36
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-obsolete_target-file
+++ a/mm/damon/sysfs.c
@@ -212,6 +212,7 @@ struct damon_sysfs_target {
 	struct kobject kobj;
 	struct damon_sysfs_regions *regions;
 	int pid;
+	bool obsolete;
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -263,6 +264,29 @@ static ssize_t pid_target_store(struct k
 	return count;
 }
 
+static ssize_t obsolete_target_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+
+	return sysfs_emit(buf, "%c\n", target->obsolete ? 'Y' : 'N');
+}
+
+static ssize_t obsolete_target_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	bool obsolete;
+	int err = kstrtobool(buf, &obsolete);
+
+	if (err)
+		return err;
+	target->obsolete = obsolete;
+	return count;
+}
+
 static void damon_sysfs_target_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_target, kobj));
@@ -271,8 +295,12 @@ static void damon_sysfs_target_release(s
 static struct kobj_attribute damon_sysfs_target_pid_attr =
 		__ATTR_RW_MODE(pid_target, 0600);
 
+static struct kobj_attribute damon_sysfs_target_obsolete_attr =
+		__ATTR_RW_MODE(obsolete_target, 0600);
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
+	&damon_sysfs_target_obsolete_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1377,6 +1405,7 @@ static int damon_sysfs_add_target(struct
 			/* caller will destroy targets */
 			return -EINVAL;
 	}
+	t->obsolete = sys_target->obsolete;
 	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

