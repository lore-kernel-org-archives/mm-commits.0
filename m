Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832318;
	b=nDgDhegOTt/CuNpnJHIL36lvGanlIzfkQUJ5SvyPrGUFJVldhCnWeyWHpXb0VQSf435f
	 1JIx4oACewwX76d9SrDb58/hAD3RJUPBsozoCeuWJ2YYzhiNgC4eihXj+6EzWvjzyPPNa
	 Xz3RTjYqa4evDeMmHkDnVl3nXMzs0nE7qfAd2IOOe7RvPTGn8/iQiP977K75dv11CPO0A
	 s3SGiryseNbAWhOsy5rgCgJfksib39OiITHF6Y8Mm/Fpm3YrOkgVPzjTJVCIXa3yCFxY0
	 pxpVHOWJKZkagJ6KchXycx+2fvQc/MRjygQ5I6SD202CMDOiSQ6B/zUFzUkZTpAAN/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832318;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=PFkg/HOCCRmN1k3frkD59b5mg5kirOM4hd3nw/uekn4=;
	b=Z+9YyohZwknqXQVbilh6QRuS7jpomRBtmlZ4qZWaqLYw4I9Gip2//lMvaE27zmsCF8/u
	 siP+ip6eO6Wa9uP/LTbQQX4Hj79kjAKZN0w+hRLDDPSliFAGM74TawNR5pu1cgljWM7Wf
	 THs4Cyge0P+GSwUEN+vt3/FremHTlgBOPAbDSDilRlzTF+Lskql5NrX+Zxu4AYqOamgaW
	 mM9HHUKHFeei3TOKg7a+mlwIn9YxPvJ6E/t/VNFY8y6e5zTLd3TvOWbZFhz0wqryRLVso
	 vcbvhxAVUPPFa9e8GSeNjbOHo/qFpn2UTdxFl1E1tkfz/ZQLKWfP23W/7VzaJlJlS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RfPh8cgg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9043606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=RfPh8cgg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D91F01825;
	Sat, 24 Oct 2026 08:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832317;
	bh=PFkg/HOCCRmN1k3frkD59b5mg5kirOM4hd3nw/uekn4=;
	h=Date:To:From:Subject;
	b=RfPh8cggnIC2sdgOhaAThoNtND4Tws/y0w/M5CQAzXO4whqLDGHJ5bXF9E85aOkp8
	 PQDebPkNcRieTSUsEqz6VaUf4Dyv6SefN/4jcQJ3ErsuRze4/LtjR1FDzDwMNByV/3
	 DiYIMJhVSpBj2M99+R/wapnXpgkuki3viZ7EMMhM=
Date: Sat, 24 Oct 2026 01:58:37 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch removed from -mm tree
Message-Id: <20261024085837.7D2D91F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: support quota goal complement flag
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: support quota goal complement flag
Date: Tue, 29 Sep 2026 01:01:06 -0700

Add a new sysfs file, complement, under the quota goal directory.  It
works for setting and getting the quota goal metric complement flag
value.

Link: https://lore.kernel.org/20260929080113.41708-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-quota-goal-complement-flag
+++ a/mm/damon/sysfs-schemes.c
@@ -1220,6 +1220,7 @@ static const struct kobj_type damon_sysf
 struct damos_sysfs_quota_goal {
 	struct kobject kobj;
 	enum damos_quota_goal_metric metric;
+	bool complement;
 	unsigned long target_value;
 	unsigned long current_value;
 	int nid;
@@ -1316,6 +1317,30 @@ static ssize_t target_metric_store(struc
 	return -EINVAL;
 }
 
+static ssize_t complement_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%c\n", goal->complement ? 'Y' : 'N');
+}
+
+static ssize_t complement_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	bool complement;
+	int err = kstrtobool(buf, &complement);
+
+	if (err)
+		return err;
+
+	goal->complement = complement;
+	return count;
+}
+
 static ssize_t target_value_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -1424,6 +1449,9 @@ static void damos_sysfs_quota_goal_relea
 static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
 		__ATTR_RW_MODE(target_metric, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_complement_attr =
+		__ATTR_RW_MODE(complement, 0600);
+
 static struct kobj_attribute damos_sysfs_quota_goal_target_value_attr =
 		__ATTR_RW_MODE(target_value, 0600);
 
@@ -1438,6 +1466,7 @@ static struct kobj_attribute damos_sysfs
 
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
+	&damos_sysfs_quota_goal_complement_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	&damos_sysfs_quota_goal_nid_attr.attr,
@@ -2869,7 +2898,8 @@ static int damos_sysfs_add_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->metric, false,
+		goal = damos_new_quota_goal(sysfs_goal->metric,
+				sysfs_goal->complement,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
_

Patches currently in -mm which might be from sj@kernel.org are


