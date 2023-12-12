Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632BC80032
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jLcEVtl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E175C433C7;
	Tue, 12 Dec 2023 18:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407575;
	bh=jopc8QRCefz1xVhQ4nNdWVKANfg4FXj39w5pxS3oHC8=;
	h=Date:To:From:Subject:From;
	b=jLcEVtl4KwjZVTBuI4U8dZfnc4E5L9BT93eHyDKMvYEcdiH31PaKNDnqug9C8l+E8
	 gMN3lrr5LG8ESlZ/Qeu0s1GMaTNKns1zukD3Va7JtgOXiwzjsflolSgScrKVmo1Ozt
	 we0ytGPjDBAhNHRqi9IKBtgjQcZ3tIxru/3utPPk=
Date: Tue, 12 Dec 2023 10:59:34 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-document-damos-quota-auto-tuning.patch removed from -mm tree
Message-Id: <20231212185935.2E175C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: document DAMOS quota auto tuning
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-document-damos-quota-auto-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: document DAMOS quota auto tuning
Date: Thu, 30 Nov 2023 02:36:50 +0000

Document the DAMOS quota auto tuning feature on the design document.

Link: https://lkml.kernel.org/r/20231130023652.50284-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-damos-quota-auto-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -346,6 +346,17 @@ the weight will be respected are up to t
 implementation.
 
 
+Aim-oriented Feedback-driven Auto-tuning
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Automatic feedback-driven quota tuning.  Instead of setting the absolute quota
+value, users can repeatedly provide numbers representing how much of their goal
+for the scheme is achieved as feedback.  DAMOS then automatically tunes the
+aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
+is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
+is over achieving the goal, it decreases the quota.
+
+
 .. _damon_design_damos_watermarks:
 
 Watermarks
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

