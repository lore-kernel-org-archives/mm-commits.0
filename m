Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795456108;
	b=HaoNdi+6F2VHATKAiKgRTN5xUg2M1J6nLSEKZRdc9+wT2Aq2HBqXqQr8rAW246gjE/U7
	 fqNs3AC20d/gSpG2XzwY/95g/fj9TvlUJzEtf9nWWM3t63WRUEpVvHc+dQ4L0mgV+7rMD
	 9R7s18rcQiQCufGXfwvBVnIjh1LFu9nNbRnleAjK9eE3+hWsobFJIoP/0ExCnujAc/On5
	 o5uyw4DK/qP2PE9arCxFagcIgmQMCRcFexagOOao8n15r2QQy4eCe/DbcvytGfPsS3l8Y
	 QEQM/GtZRssqrKtkfrBap+WTvYBhZWsYOkUdbtN62YLncAfSi0KTAU/C1Dt8BaVD58Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795456108;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Ak+T7CDzK5uEeQsOqVtKLyPXpbWdeLP4No8mRkWLV4k=;
	b=p5ioe5MMaA7OobUwM1RdlzHXK5rXbR4H/iD1oAQ9Iun+43pZFjhEomzl7IYsDLVAWhOC
	 n7uM+y26/l9eZbQTqT5H7ZkfsS5FaixqLaqdnF1fe38NQpDGIYZvmKlwF+p3zPtscDFrm
	 xRyVE/VQxy87mDGRwsuyUU+v3iIKODKceNtSDFPuNb3ZlTYM4CuJrDPuqmAsZhPtGJm73
	 u48UEwC1O3xlw6EkdC2CDxliJxyIEqjTL5radtnX0A4ZbCprZaCsm8Wb5nC7DARRoCrNS
	 Mzy1PI6VCo/BizlpQaIrDSRbK8rLlH1337jVltYtmofhxvnMNbOwnH95GseclvxAkrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hpauP1HQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB25606A31F;
	Mon, 23 Nov 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hpauP1HQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB531F000C4;
	Mon, 23 Nov 2026 17:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795456107;
	bh=Ak+T7CDzK5uEeQsOqVtKLyPXpbWdeLP4No8mRkWLV4k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=hpauP1HQ6+omoT81mV+hM9RVQsj+M8dcxD3YkbEo+aibOeK778FV7Kep9lge3PzOC
	 0jaC+6KX/EnzasHnJW4sH6h4JVEMb5dtPqHxp/0FJ7fQkeBOYHgXxZwM8SiXu17ahK
	 8C15FCjCVFfBcGXZBBlake6bUX0FL1GKXpqhYun0=
Date: Mon, 23 Nov 2026 09:48:27 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,
	devnexen@gmail.com,evanfengff@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123150049.81317-4-sj@kernel.org>
References: <20261123150049.81317-4-sj@kernel.org>
Subject: + mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch added to mm-hotfixes-unstable branch
Message-Id: <20261123174827.BDB531F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: do not overwrite wmarks.activated in damos_commit()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch

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
Subject: mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Mon, 23 Nov 2026 07:00:48 -0800

damos_commit() copies the whole wmarks struct from the source scheme,
including the private 'activated' field.  The source scheme is a new
one, so the field is always true there.

As a result, a commit turns on a scheme that the watermarks turned off.
If the metric is between mid and high at that time, the scheme keeps
running, though it should stay off until the metric goes below mid.
DAMON_RECLAIM and DAMON_LRU_SORT use the same path for commit_inputs.

Save 'activated' before the copy and restore it after.  Do not restore
it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
the scheme would stay off.

Link: https://patch.msgid.link/20261123150049.81317-4-sj@kernel.org
Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit function")
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Carlier <devnexen@gmail.com>
Cc: <stable@vger.kernel.org> # 6.11.x

 mm/damon/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit
+++ a/mm/damon/core.c
@@ -1567,6 +1567,7 @@ static struct damos *damon_nth_scheme(in
 
 static int damos_commit(struct damos *dst, struct damos *src)
 {
+	bool activated = dst->wmarks.activated;
 	int err;
 
 	dst->pattern = src->pattern;
@@ -1578,6 +1579,8 @@ static int damos_commit(struct damos *ds
 		return err;
 
 	dst->wmarks = src->wmarks;
+	if (dst->wmarks.metric != DAMOS_WMARK_NONE)
+		dst->wmarks.activated = activated;
 	dst->target_nid = src->target_nid;
 
 	err = damos_commit_dests(&dst->migrate_dests, &src->migrate_dests);
_

Patches currently in -mm which might be from evanfengff@gmail.com are

mm-damon-core-fix-damos_walk-hang-with-zero-watermarks-interval.patch
mm-damon-core-do-not-overwrite-wmarksactivated-in-damos_commit.patch

