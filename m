Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6F548167D
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788283081; cv=none; b=c5ekwfbzwIShz+Up/Wq9myZ5mX5pO5Dr7XnH7EEK2diajS1DmTWd7DGshm8AjtXdYMX0U7xPsybA7gRzvQLgVMytcbIEe3Jeac6TcLQxHdGyEuWOBDOFzYbyZrclRalvaqB3goD+WaJFKMbemBwDjBITnJYH99THY0Y/BdfxJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788283081; c=relaxed/simple;
	bh=Oju33Wm/dO+40/eqwXpvqlDMLjU/MfGXt0QKWwt4N1g=;
	h=Date:To:From:Subject:Message-Id; b=KkjZh60LwnPtFVDSMrqoaVoTZV7pc8DCGe7tLeRLOzF4FlA1JGh7BACXqMYd9+k6W8IoJJtteXPbkT6s1L/Qz2bhqG251/k+JMdX4FBkX9GsmXDNpnow0ZvF6imZGs97Dhq6w3NH+enNScNinZYMLeLCV1xBGP/6Mwrd5ljL7Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HifcblNy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HifcblNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF33E1F000E9;
	Tue,  1 Sep 2026 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788283079;
	bh=WS8ZVszNdfaOJKJ3KFzrMNHA23lM32Uv7Cl6hgV+EeQ=;
	h=Date:To:From:Subject;
	b=HifcblNynT9fET2YWoqrfGkw0jInz25iRXuhiBGRHihn0wGFc5A3t9Pzz9sDb4vdw
	 oWXTzMdYj8JCEqpCSarnVsEeUWW9Ee8Q5vx9TGNsl6JpYvQBIIil/YLHqlhHc9dcBG
	 vFDYu959/WRmdw3E119nsm4YT84F2dmn7+GEXKnU=
Date: Tue, 01 Sep 2026 10:17:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-prep_action-file.patch added to mm-new branch
Message-Id: <20260901171759.BF33E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement prep_action file
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-prep_action-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-prep_action-file.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: implement prep_action file
Date: Tue, 1 Sep 2026 06:24:59 -0700

Add a file named prep_action under the prep directory.  It represents the
corresponding probe preparation action.

Link: https://lore.kernel.org/20260901132506.99243-13-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   57 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-prep_action-file
+++ a/mm/damon/sysfs.c
@@ -755,6 +755,7 @@ static const struct kobj_type damon_sysf
 
 struct damon_sysfs_prep {
 	struct kobject kobj;
+	enum damon_prep_action action;
 };
 
 static struct damon_sysfs_prep *damon_sysfs_prep_alloc(void)
@@ -764,9 +765,61 @@ static struct damon_sysfs_prep *damon_sy
 	prep = kzalloc_obj(struct damon_sysfs_prep);
 	if (!prep)
 		return prep;
+	prep->action = DAMON_PREP_SET_PGIDLE;
 	return prep;
 }
 
+struct damon_sysfs_prep_action_name {
+	const enum damon_prep_action action;
+	const char *name;
+};
+
+static const struct damon_sysfs_prep_action_name
+damon_sysfs_prep_action_names[] = {
+	{
+		.action = DAMON_PREP_SET_PGIDLE,
+		.name = "set_pgidle",
+	},
+};
+
+static ssize_t prep_action_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (action_name->action == prep->action)
+			return sysfs_emit(buf, "%s\n", action_name->name);
+	}
+	return -EINVAL;
+}
+
+static ssize_t prep_action_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_prep *prep = container_of(kobj,
+			struct damon_sysfs_prep, kobj);
+	ssize_t ret = -EINVAL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(damon_sysfs_prep_action_names); i++) {
+		const struct damon_sysfs_prep_action_name *action_name;
+
+		action_name = &damon_sysfs_prep_action_names[i];
+		if (sysfs_streq(buf, action_name->name)) {
+			prep->action = action_name->action;
+			ret = count;
+			break;
+		}
+	}
+	return ret;
+}
+
 static void damon_sysfs_prep_release(struct kobject *kobj)
 {
 	struct damon_sysfs_prep *prep = container_of(kobj,
@@ -775,7 +828,11 @@ static void damon_sysfs_prep_release(str
 	kfree(prep);
 }
 
+static struct kobj_attribute damon_sysfs_prep_prep_action_attr =
+		__ATTR_RW_MODE(prep_action, 0600);
+
 static struct attribute *damon_sysfs_prep_attrs[] = {
+	&damon_sysfs_prep_prep_action_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_prep);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch

