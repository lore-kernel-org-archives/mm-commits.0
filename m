Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF96A13BAC9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644519; cv=none; b=rkTQA/RNVwcREjUvB5smT7tzWet+GD7kExaVS0TVE4D2VNeudaRdH+Jv4Oj+YYt0Vgrary8570nXkveuKyfB2xLP/m/pymFrZtQYZfgU0NspkTeakX8mpWtiML+RX2go8J9hKw0XJWjtMwJzgI6WnF8Vl1n09v0ezqBUpucps7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644519; c=relaxed/simple;
	bh=3MyeyUcDM3mB6BzyVVd0OPSOeYSFXqVDJr27rdekunw=;
	h=Date:To:From:Subject:Message-Id; b=OSsPGjv1o+EXuBxnbjlLIMCS/nb+WjqMQKoVPdV9eTL+fGSsNmTfTbeu69xh13uC4pzJNknnDUymuot/rSwsGGBKxc0K3rEvEE9+D9G5Qo4Oyhr9NXxwouv6BoTOloFfqAmc2rZojetlKiEttc5RqgqUymEw0I4cr9oeIl1JkwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1p8kbjAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1p8kbjAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A00C433A6;
	Thu, 22 Feb 2024 23:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644519;
	bh=3MyeyUcDM3mB6BzyVVd0OPSOeYSFXqVDJr27rdekunw=;
	h=Date:To:From:Subject:From;
	b=1p8kbjAM80qcJJAD7E6Ma+2k11CSm4wvPa5OZEe+sxhZ1C9Hq1ek/m+ZxpgYog2C6
	 fWMjdpQIri+ZmWsF9zZNKP9mOc8sozxy60jwjhiIWVAE7hQxcZaVizsH9jbYd1fyd2
	 5xyK50bkC//7ASJkdb0Gosgyhw/ZIc7D54cyIRkI=
Date: Thu, 22 Feb 2024 15:28:38 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch removed from -mm tree
Message-Id: <20240222232839.65A00C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/maintainer-profile: fix reference links for mm-[un]stable tree
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/maintainer-profile: fix reference links for mm-[un]stable tree
Date: Fri, 16 Feb 2024 16:58:38 -0800

Patch series "Docs/mm/damon: misc readability improvements".

Fix trivial mistakes and improve layout of information on different
documents for DAMON.


This patch (of 5):

A couple of sentences on maintainer-profile.rst are having reference links
for mm-unstable and mm-stable trees with wrong rst markup.  Fix those.

Link: https://lkml.kernel.org/r/20240217005842.87348-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20240217005842.87348-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -21,8 +21,8 @@ be queued in mm-stable [3]_ , and finall
 memory management subsystem maintainer.
 
 Note again the patches for review should be made against the mm-unstable
-tree[1] whenever possible.  damon/next is only for preview of others' works in
-progress.
+tree [1]_ whenever possible.  damon/next is only for preview of others' works
+in progress.
 
 Submit checklist addendum
 -------------------------
@@ -41,8 +41,8 @@ Further doing below and putting the resu
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the mm-unstable[1] and
-mm-stable[3] trees depend on the memory management subsystem maintainer.
+Patches can be sent anytime.  Key cycle dates of the mm-unstable [1]_ and
+mm-stable [3]_ trees depend on the memory management subsystem maintainer.
 
 Review cadence
 --------------
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

