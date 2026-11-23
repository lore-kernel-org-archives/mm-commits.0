Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456105;
	b=IRGcIXIh7HpEgd4YOmmLsCxVbqGV3iZsowzvulvW8s/rkCT/yjsY6o+BgnBhwLjUCe2f
	 OugrNMcIQvo4eQCgnFq+6dh3iI0qwZ7SXTsdV3w2LavRVlj67le9XN/PLYfyadWkBZQMa
	 GIMfnJfD5Rh+itXX2hkvyrwnJD4vDHt/Rf3aAktaOxqB9SBXdTgsLKGdaRZkcl2ZVKjog
	 nhg+mmbbtlsSsTChDpWjxIuyc7x2yWVEyDeJm42OIE5VaKpUyriU0WzS82hLr6mJ3U7E5
	 WN3HodI1baZIFpWorS8Su/FeKgWjv+WwI1DtBuVaQIcHGtxOPkFhuow7mF3XOSGlm3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456105;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=PfvI/Ha4XLTEm2qt9fqOBcUIC9/JenMBQwrwWJkF5vo=;
	b=qMg7RTd1NKH2WqE/Wyh6PAz+5A1peedCw9UEXFCLDMla5+AAR23ZX1UYbswXAvbOQOL2
	 t9b0c7Qk77J+XjnW4+MHZRB4mHSdbNY4ANcgEJxSbtDuZ80ffJxTN9uhlWVLjqdUmkt5x
	 FMvcC2TaMHwoj1vKb8Ytoy/C+nhs0ZNbY5N9QygGpQQghAdtFpHPLM7vrHekWNqEmEh+E
	 ajc5RVkOXic/gYDLX9ys6ZTWCIBNpepcgYE2uceMwVzFFP6f8143RWVjCRHamaOyW2qLg
	 MPyyfNo70eDsOpFiIuOnErIgl4kBi2Y02679/qCnAc29wjO3SdCD1FujAJ7x483Hqxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="v/NThj/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAA7606A31A;
	Mon, 23 Nov 2026 17:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v/NThj/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CE01F000C0;
	Mon, 23 Nov 2026 17:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795456104;
	bh=PfvI/Ha4XLTEm2qt9fqOBcUIC9/JenMBQwrwWJkF5vo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=v/NThj/TitftNtrPusPd4SHJ/UAhDd2tmYeK6XWts6onYuDJDpL9IrXHvG618pQnm
	 QIXD4AI+387U8UTzc9eLVYHlJ8S7V5ArHG5oQFdzIxYRJXzCm4xoplZgUM/YHf46I2
	 R5JtCaqIMkAWXd80xqfVxp7Gm4f3b9vI5mzrmC5M=
Date: Mon, 23 Nov 2026 09:48:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	devnexen@gmail.com,evanfengff@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150049.81317-3-sj@kernel.org>
References: <20261123150049.81317-3-sj@kernel.org>
Subject: + mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch added to mm-hotfixes-unstable branch
Message-Id: <20261123174823.E4CE01F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: fix damos_walk() hang with zero watermarks interval
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch

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
From: Yifan Feng <evanfengff@gmail.com>
Subject: mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Mon, 23 Nov 2026 07:00:47 -0800

kdamond_wait_activation() cancels damos_walk() requests while all
schemes are deactivated by their watermarks.  But it returns without
waiting when the watermarks check interval of a deactivated scheme is
zero, which is the default of the DAMON sysfs interface.  The kdamond
main loop then runs with all schemes deactivated.

In that state, kdamond_apply_schemes() finds no scheme to apply and
returns before it calls damos_walk_complete().  The walk request is
neither completed nor cancelled, so damos_walk() waits until the
watermarks activate a scheme again, possibly forever.

For example, with a scheme that has the free_mem_rate metric, zero
interval_us and a high watermark below the current free memory rate,
writing update_schemes_tried_regions to the kdamond state file never
returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.

Cancel the walk request in kdamond_apply_schemes() when no scheme is
activated, as kdamond_wait_activation() does for a non-zero interval.

Link: https://patch.msgid.link/20261123150049.81317-3-sj@kernel.org
Link: https://lore.kernel.org/20261121025626.75981-1-evanfengff@gmail.com
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: SJ Park <sj@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Carlier <devnexen@gmail.com>
Cc: <stable@vger.kernel.org> # 6.14.x

 mm/damon/core.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval
+++ a/mm/damon/core.c
@@ -3492,9 +3492,13 @@ static noinline_for_stack void kdamond_a
 	struct damon_target *t;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	bool has_activated_schemes = false;
 	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
+		if (s->wmarks.activated)
+			has_activated_schemes = true;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
@@ -3506,8 +3510,12 @@ static noinline_for_stack void kdamond_a
 		damos_adjust_quota(c, s);
 	}
 
-	if (!has_schemes_to_apply)
+	if (!has_schemes_to_apply) {
+		/* The walk cannot be completed while no scheme is activated */
+		if (!has_activated_schemes)
+			damos_walk_cancel(c);
 		return;
+	}
 
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
_

Patches currently in -mm which might be from evanfengff@gmail.com are

mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch
mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch

