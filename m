Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420E79C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739412; cv=none; b=p3uM7z9o5BTXOMjiOxcqu9eIlFoDxYPyONoTZciZcdGogLn1qKiJyLwHCg7bYZiUPz2yPH2g2qy2EIhfNrxzy6jq+BpRNJAyf2pebot7mFNrJW7YeobyBLAzkrGzJNU6DwqcqZDFlmygXIx3S0+88f1VLOzQUyM9ctvgzY1TPpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739412; c=relaxed/simple;
	bh=RDr5U/N7gCP7hKEVdJMtz+24yChkz7oTdA+H6sx/PW8=;
	h=Date:To:From:Subject:Message-Id; b=VJEY5ax6AF3HkFhZjIh5PqfRsSa/pfCfSafQXCv/10PPaIk+weeMh+TlO6InYzDHI3ZZrwj2nNTYBfhP9KOXADIakKSo2FYyq2yDHohah64KgEkkE06ksuN2bVKRzALO5bmIF49e7AfmFAs2o+gVQA3i57i7WMtqHgpl6+hSxKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EsW8tfHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EsW8tfHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA74C433F1;
	Sat, 24 Feb 2024 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739412;
	bh=RDr5U/N7gCP7hKEVdJMtz+24yChkz7oTdA+H6sx/PW8=;
	h=Date:To:From:Subject:From;
	b=EsW8tfHjWYlBQYzK759b9O6SWnqWIlvS2u4naK93MeWn0frKqAilsNy02jenUI0zB
	 koTIPKPEnR3gs7SHFAa3g68I1IwMspqbYzdMhiPyDC8uVjC25FDt4lG7WHg8TOlkR0
	 kv9q2h5GYF8wxJPop9T3NVG5nMlc7zoTBTDwzREM=
Date: Fri, 23 Feb 2024 17:50:12 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch removed from -mm tree
Message-Id: <20240224015012.AAA74C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: implement quota effective_bytes file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement quota effective_bytes file
Date: Mon, 19 Feb 2024 11:44:13 -0800

DAMON sysfs interface allows users to set two types of quotas, namely time
quota and size quota.  DAMOS converts time quota to a size quota and use
smaller one among the resulting two size quotas.  The resulting effective
size quota can be helpful for debugging and analysis, but not exposed to
the user.  The recently added feedback-driven quota auto-tuning is making
it even more mysterious.

Implement a DAMON sysfs interface read-only empty file, namely
'effective_bytes', under the quota goal DAMON sysfs directory.  It will be
extended to expose the effective quota to the end user.

Link: https://lkml.kernel.org/r/20240219194431.159606-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-quota-effective_bytes-file
+++ a/mm/damon/sysfs-schemes.c
@@ -1139,6 +1139,7 @@ struct damon_sysfs_quotas {
 	unsigned long ms;
 	unsigned long sz;
 	unsigned long reset_interval_ms;
+	unsigned long effective_sz;	/* Effective size quota in bytes */
 };
 
 static struct damon_sysfs_quotas *damon_sysfs_quotas_alloc(void)
@@ -1252,6 +1253,15 @@ static ssize_t reset_interval_ms_store(s
 	return count;
 }
 
+static ssize_t effective_bytes_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_quotas *quotas = container_of(kobj,
+			struct damon_sysfs_quotas, kobj);
+
+	return sysfs_emit(buf, "%lu\n", quotas->effective_sz);
+}
+
 static void damon_sysfs_quotas_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_quotas, kobj));
@@ -1266,10 +1276,14 @@ static struct kobj_attribute damon_sysfs
 static struct kobj_attribute damon_sysfs_quotas_reset_interval_ms_attr =
 		__ATTR_RW_MODE(reset_interval_ms, 0600);
 
+static struct kobj_attribute damon_sysfs_quotas_effective_bytes_attr =
+		__ATTR_RO_MODE(effective_bytes, 0400);
+
 static struct attribute *damon_sysfs_quotas_attrs[] = {
 	&damon_sysfs_quotas_ms_attr.attr,
 	&damon_sysfs_quotas_sz_attr.attr,
 	&damon_sysfs_quotas_reset_interval_ms_attr.attr,
+	&damon_sysfs_quotas_effective_bytes_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_quotas);
_

Patches currently in -mm which might be from sj@kernel.org are


