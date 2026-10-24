Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832322;
	b=aQ9sazC1tl2ZHKiQkHjpXwQBu7QSadAimbhSCfTLeJufv3LWklcBO6t7Gnb8dJW3e4vh
	 uVYeymG8qkb2N4FIDxMXCwvGySpFc86hDoIwq1I9NMoriOtAYc7CSYB39ckr8a6/BIO/v
	 yo6d5G/4EiJt3T00Lvt2kuU/AH3kNa5fG2Vjt+E75eRSPu/F5bTjVH6lBVosxJV1kxbq9
	 WCyZCs10SNZAnLHnbZsQbYSBjbnAHdJHefeQqQSuGlryFPBEQdeL3YHnKkHLffzRlAoNx
	 eVpNG3pNlYH/V8G/OENmYYYGMJKKIn99bOJ8ucegp3uobuP2SgEVT51yb+U8Wt/NZPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832322;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=iZPT5YDe95kSU9HyotMHfZvcMpM+N4+wwXfa43ExJNM=;
	b=MEm+3F3REuF1gNFzrmsoyxyYk3GbEAuGT1RLfqOxr8hbwvtznk3kYuziUOiiq7Uk2FJQ
	 5J4Itc4oJresoZA5EK+e5y+22q0BZlRP3c74PmIl7q47EIPoh0T13Af8axNS2yiaLFwq5
	 nBZkQhK9vvXl2W6BaRl9j6n6knKdytxjWX3x8uJ2+mQsfvTOmKqBHGe8HReER96DuZcBb
	 G2TnWKeG4+wo8CfD6/r4/kyyTmDY3p1TXnq5N/UaG1rj0KSxJbTjHWs874ySmzLYDU/nS
	 YU8imP0GHriVBKLu9YGpI0stLzQ5fzNu/MSltCSPQcYdtfQ45C2EGIeFstsF1JvDjaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="REroHx9/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED64606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=REroHx9/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98401F01828;
	Sat, 24 Oct 2026 08:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832321;
	bh=iZPT5YDe95kSU9HyotMHfZvcMpM+N4+wwXfa43ExJNM=;
	h=Date:To:From:Subject;
	b=REroHx9/f2kaciRzNOD2B6W6dvLpLn+N4rKaTyMOj4HjrEjFbQc7JZlnuv+4AGW+6
	 i45tDzBPjERg2YLrC54gbjB3L2/DT38go7+CWSwvOnmALJDId0015McgbTc+ofgOPY
	 OU7YExtZg9DCjzYWgXwYuP3rzBsR3qKDFxaa6Thw=
Date: Sat, 24 Oct 2026 01:58:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,skhan@linuxfoundation.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch removed from -mm tree
Message-Id: <20261024085841.A98401F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for quota goal complement file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Tue, 29 Sep 2026 01:01:10 -0700

Update DAMON usage document for the newly added quota goal metric
complement sysfs file.

Link: https://lore.kernel.org/20260929080113.41708-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -98,7 +98,8 @@ comma (",").
     │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
+    │ │ │ │ │ │ │ │ │ 0/target_metric,complement,target_value,
+    │ │ │ │ │ │ │ │ │  current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
@@ -492,12 +493,12 @@ number (``N``) to the file creates the n
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
-get the five parameters for the quota auto-tuning goals that specified on the
-:ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Because the kernel does not update
-``current_value``, reading it only makes sense when ``target_metric`` is
+Each goal directory contains six files, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
+Users can set and get the six parameters for the quota auto-tuning goals that
+specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
+writing to and reading from each of the files.  Because the kernel does not
+update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
_

Patches currently in -mm which might be from sj@kernel.org are


