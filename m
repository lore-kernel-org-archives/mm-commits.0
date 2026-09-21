Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6C3AC0C5
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790019231; cv=none; b=XOrZJwUz0vzo3c79iOurydCyCiVN1FCx6rAe+zHGZ3mEcoU+Wr7elYMbJlMx277bp0rRjKDDu40uYdbKJzaqyC63UtyKK0BQjDlPrNcEKKHeLmUaUohoiU7tIbj3I0/TmxBObiJYr6PmNQocO6qakwNgeHiWPby4MSyeFyQDNbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790019231; c=relaxed/simple;
	bh=K0aKMQfLfTEUqzR8NcIS4rKdK3+q83r4W+9gBSoPQps=;
	h=Date:To:From:Subject:Message-Id; b=I4fxfVGq8uvgSrslgic9kPuDm2a48yANfNwlD6P0SYrbyTIfRKUO+sW9cVRf1xjr7AEYb94PtOO7yoYHAb/Gp5OtD8r3YcrfPGTioVSIZ0a96vCZfyXRrfxHLtiN6PCFEizMOgdmwXHawoPN4+rHiad5V7+BVsB31TcTVvU8WJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o24ABnA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o24ABnA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B796E1F00893;
	Mon, 21 Sep 2026 19:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790019229;
	bh=fQYt0ep3mOBKqWAdk7giAZxxG5oZi2lGjAgzmpbJlZ8=;
	h=Date:To:From:Subject;
	b=o24ABnA2RFXEtCpldTB/ZfqrvUgx2EBEqOdAMqTBkcQyU58kRI1x/E4CAw0kUvyWh
	 1RynizMz9ZN+paalhxVCyH8bK6RK3pHolKMIlgFMHS0OKbRnWs2f6eeySXv1hT5WWj
	 vlDbN3FxYR/jRozIHORuiFajgbhVDG6eTQjw7qtQ=
Date: Mon, 21 Sep 2026 12:33:49 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,wangxuewen@kylinos.cn,sj@kernel.org,aethernet65535@gmail.com,adrianhuang0701@gmail.com,karthiproffesional@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-document-that-a-zero-sample_interval-is-accepted.patch added to mm-new branch
Message-Id: <20260921193349.B796E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: document that a zero sample_interval is accepted
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-document-that-a-zero-sample_interval-is-accepted.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-document-that-a-zero-sample_interval-is-accepted.patch

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
From: Karthikeyan KS <karthiproffesional@gmail.com>
Subject: mm/damon: document that a zero sample_interval is accepted
Date: Mon, 21 Sep 2026 08:15:46 -0700

damon_set_attrs() accepts sample_interval == 0.  This was reported as a
bug in v1 of this patch (rejecting it in damon_set_attrs()).  A similar
patch was already declined for the same reason: a zero interval is
intentionally supported [1].

Document the behavior instead of changing it.

Link: https://lore.kernel.org/20260921151547.78472-5-sj@kernel.org
Link: https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/ [1]
Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Adrian Huang <adrianhuang0701@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

 include/linux/damon.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-document-that-a-zero-sample_interval-is-accepted
+++ a/include/linux/damon.h
@@ -836,7 +836,8 @@ struct damon_probe {
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
- * @sample_interval:		The time between access samplings.
+ * @sample_interval:		The time between access samplings.  Zero is
+ *				accepted.
  * @aggr_interval:		The time between monitor results aggregations.
  * @ops_update_interval:	The time between monitoring operations updates.
  * @intervals_goal:		Intervals auto-tuning goal.
_

Patches currently in -mm which might be from karthiproffesional@gmail.com are

mm-damon-document-that-a-zero-sample_interval-is-accepted.patch

