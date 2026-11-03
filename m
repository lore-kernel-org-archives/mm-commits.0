Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672138;
	b=YNQfXrC6nunb+r5w8ShoH7xGR4wPuBAkl5J4e2/LAJoN3nYHQvOk/J0HgzUdve+2uYeZ
	 /fOc8mLq6rWlmlKKedJZxB+0hAzFY9+fz52dfz0OlOOwLlITeX4UUKjm0Gc6ZMqviVl2U
	 F64COXKeGeHFpWSlEJybKkhuPlalg7CwLt5/GZfbH9VGLdvXqeX2/QpMYrDUrR5gdZh4H
	 AgXQXgY0poaMQXwFXi4j+gam2eQ8VnnozRJzsaAWDktU39JhwL65XeoR+rMw+kDR1CtHM
	 l69GyuGeBfbDs3yY6ffIW7V53vVp6d0/eLvQwoVM0VpnpRp4X15L5m/skEJaoaztUXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672138;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=B/z1lwWxA0RiwoCiTJ44ffWE0gFTZnlCs7lzt0VbmmM=;
	b=sXQiDn/ytHcbS9cc5YfkKqCZYbL37y962qZ6yp+d1/dl4MziSANjXBC8wA6wq3aQBNvn
	 Caj5gW5bMnT+WEC/d2IQoScRLorZXtU/2CzHI1u63VxL86MhIU5COOPzXLimH2mYC7tH4
	 7htpN9ZDeNYDp1hm10KKntiaWvaFkOFqRbeYpHJcc+pz86/kdtJ22PGEZ0gUceWH0Fhu0
	 7iMiVOFwd45nvppV7zfuendUU67o7epCqPeu60iUUYSpLrYYcH5CL6t6MGuaOoUjVK6sm
	 lkBtqtnNjyuZ2MTsk5Hr/PAj8Gq3h1voRQD2SGe8n2B9fLfStq0LZ5wAPiyn4ddlMEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="o7/PzE9y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F5606A324;
	Tue,  3 Nov 2026 02:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o7/PzE9y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4071F000C1;
	Tue,  3 Nov 2026 02:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672138;
	bh=B/z1lwWxA0RiwoCiTJ44ffWE0gFTZnlCs7lzt0VbmmM=;
	h=Date:To:From:Subject;
	b=o7/PzE9y+ZSieywWfmSDbFxUPIqxIr2U4EQwwVe85p7XaD5wcAyxyCeF7J4t94shG
	 Sn6BA5h0gzt8C4iPhzYwTP2btR/9wgTMi8Ijgkz185H7mgLzcb1dnNPhkRPd1RNFyb
	 h2xBkceeZdNzSeUQT/7a4A8p8P5llbdHZsHfKMac=
Date: Mon, 02 Nov 2026 18:15:37 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch removed from -mm tree
Message-Id: <20261103021538.2F4071F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
Date: Sun, 25 Oct 2026 09:48:04 -0700

Patch series "mm/damon: fix three race bugs in sysfs and core", v1.

There are three race condition bugs in DAMON sysfs interface and the
core layer.  User impacts are not critical but better to fix sooner than
later.

Patch 1 fixes a toctou bug in DAMON sysfs interface that can mess up
DAMOS auto-tuning.  Patches 2 and 3 move static variables that can be
wrongly shared with multiple kdamonds and therefore make DAMON
monitoring results be a little more indeterministic.


This patch (of 3):

damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->metric
twice, once to set damos_quota_goal->metric to the value, and once again
to set the metric-dependent damos_quota_goal unions based on the value.

target_metrics_score() can update damos_sysfs_quota_goal->metric between
the two reads.  This time-of-check to time-of-use (toctou) race can make
the union fields incorrectly set.  The incorrect damos_quota_goal will
be passed to the core layer and make DAMOS incorrectly behave.

Users could reproduce the race by writing a new value to the
target_metric sysfs file while DAMON is starting, or online parameters
update is ongoing.  The issue will only rarely happen in the real use
cases.  It requires sysfs write permission.  The race window is short.
Sane users wouldn't do such writes while DAMON enablement and/or online
parameters update is ongoing.

The user impact is not very critical.  The race is not easy to
unintentionally trigger.  No leak or crash happens.  Nonetheless, DAMOS
could be unexpectedly more or less aggressive and does not achieve the
auto-tune goal.  Because of the nature of races, investigating will be
difficult.  Users can control the impact from unexpected aggressiveness
using additional quotas and resolve the issue in runtime by
re-installing the quota goal, though.

Avoid the race by protecting damos_sysfs_quota_goal->metric write in
target_metric_store() with damon_sysfs_lock.  Because
damon_sysfs_add_quota_score() is called while holding the same lock, the
race is removed.

The issue was discovered as a part of a bug report [1] from Sashiko,
which is partially outdated.  In more detail, the Sashiko report [1] was
mainly for an outdated bug [2].  But it was also mentioning the issue of
this patch as a similar class bug.

Link: https://lore.kernel.org/20261025164808.152048-1-sj@kernel.org
Link: https://lore.kernel.org/20261025164808.152048-2-sj@kernel.org
Link: https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b [1]
Link: https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org [2]
Fixes: 85fcf0ffc460 ("mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.16.x
---

 mm/damon/sysfs-schemes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-hold-damon_sysfs_lock-in-target_metric_store
+++ a/mm/damon/sysfs-schemes.c
@@ -1310,7 +1310,10 @@ static ssize_t target_metric_store(struc
 
 		metric_name = &damos_sysfs_qgoal_metric_names[i];
 		if (sysfs_streq(buf, metric_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			goal->metric = metric_name->metric;
+			mutex_unlock(&damon_sysfs_lock);
 			return count;
 		}
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-sysfs_memcg_path_leak-define-ksft_skip.patch
mm-damon-core-copy-only-installed-probe-in-damon_split_region_at.patch

