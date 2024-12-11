Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69F364BA
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 00:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733877509; cv=none; b=F6kylpD+BTcTzxtGYeKsU1kHJIqy+xgeBmrZdD/ElMZ0sVqZjAjAGJj38pjmKqDJCQ2KTeyw40weOtA1Mr8XWvPG2YlG5qY4VjuAu+5xmHyA6H+cDmmGm3yuvSOrVcgf6LlNytFNtsQt2r/7As+5MAGNScuI5AX54txIXLcNlOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733877509; c=relaxed/simple;
	bh=HqLP8IhkjKGBBjc70+feIQDoQwaE741zLoyMYLeqvYU=;
	h=Date:To:From:Subject:Message-Id; b=itn4omek/3Il4DrwFTt6Y3Q63DHTazcJI8qI8ey0rqgRs4ne/USFWEaNvjg/VKcZlX/vERLynX6GuLrjSzyGK3hTKJnahsgv469o6it2eymRgluTCWKlgSslhXmokmpbL5FcWDwxQU2QIe9pcPW/wuM7WcjktBmD5RhihE45tA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DTOwXCP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DTOwXCP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79560C4CED6;
	Wed, 11 Dec 2024 00:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733877508;
	bh=HqLP8IhkjKGBBjc70+feIQDoQwaE741zLoyMYLeqvYU=;
	h=Date:To:From:Subject:From;
	b=DTOwXCP9atOyI4+eTQhTj7KWLmTVkyW/DmnwreM4y7tmlVmgeVbHCXlwYXlTNon+k
	 bwuJHxBDcbupJhSR1iFjYkpHFnti3MaNdWdhgvg+jo0boKx40K720zFZu4c+R8adpn
	 pi27cRA9bgVzLgUUreijVUSGoi8lbPfhlypSU3EQ=
Date: Tue, 10 Dec 2024 16:38:27 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch added to mm-unstable branch
Message-Id: <20241211003828.79560C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: implement working set size estimation and logging
has been added to the -mm mm-unstable branch.  Its filename is
     samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/wsse: implement working set size estimation and logging
Date: Tue, 10 Dec 2024 13:50:28 -0800

Implement the DAMON-based working set size estimation logic.  The logic
iterates memory regions in DAMON-generated access pattern snapshot for
every aggregation interval and get the total sum of the size of any region
having one or higher 'nr_accesses' count.  That is, it assumes any region
having one or higher 'nr_accesses' to be a part of the working set.  The
estimated value is reported to the user by printing it to the kernel log.

Link: https://lkml.kernel.org/r/20241210215030.85675-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/samples/damon/wsse.c~samples-damon-wsse-implement-working-set-size-estimation-and-logging
+++ a/samples/damon/wsse.c
@@ -30,6 +30,23 @@ MODULE_PARM_DESC(enable, "Enable or disa
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
 
+static int damon_sample_wsse_after_aggregate(struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *r;
+		unsigned long wss = 0;
+
+		damon_for_each_region(r, t) {
+			if (r->nr_accesses > 0)
+				wss += r->ar.end - r->ar.start;
+		}
+		pr_info("wss: %lu\n", wss);
+	}
+	return 0;
+}
+
 static int damon_sample_wsse_start(void)
 {
 	struct damon_target *target;
@@ -57,6 +74,7 @@ static int damon_sample_wsse_start(void)
 	}
 	target->pid = target_pidp;
 
+	ctx->callback.after_aggregation = damon_sample_wsse_after_aggregate;
 	return damon_start(&ctx, 1, true);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch

