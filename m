Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D222979F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739425; cv=none; b=EKZZH2vRjF7L5zfdMwgWOox4yurwUuOonLW5rFJkr89fj1EQ30TSba1kxvP+y7jJpz+Cyjoae3mxvSRCu8BWcaHi+OXdc4TrksaQopm/t2+l/GgmE2gxPdedfA9rKMNhpVqOgXJkb8w+wnVYBuO/CHeeigeyPhjh8Z7+1ggkLsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739425; c=relaxed/simple;
	bh=2WcJ4EQS60biSYCiLkAhZS97jMdhtm/5ZujKmPWQ+B8=;
	h=Date:To:From:Subject:Message-Id; b=LhDln2215Gs7TDWtlpVpvtxDo5hgmyf4tei7BQi7b/hWarbobfkLMqKLiKGSz549m4xr3JfyDzpgUDGFf0BeRe8Zwwr4w8HO1y1/T611svB/uB3yUC7bjAoAWgZLqqVNWEhqYA9kRv/5hrACTDGrn2XJsXLlAboTIb+G502sIfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EhUrXDtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EhUrXDtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90D0C433C7;
	Sat, 24 Feb 2024 01:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739425;
	bh=2WcJ4EQS60biSYCiLkAhZS97jMdhtm/5ZujKmPWQ+B8=;
	h=Date:To:From:Subject:From;
	b=EhUrXDtxlIfvC1d321vzPjaV1pB0vG6XDFp2XPVNbF2QFKTnLeduW+CYXgaalxbNZ
	 UcySpz6bXoVsCIfdSX41k0LssC53t2wg0TevheIaYuITTULfa9V4Sull8QEd6uDlCO
	 dl7xX4wHQQGXqorIgk8IzUVfTfq7qpIsC/C/xIlo=
Date: Fri, 23 Feb 2024 17:50:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-quota-goal-metric-file.patch removed from -mm tree
Message-Id: <20240224015025.A90D0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document quota goal metric file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-quota-goal-metric-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document quota goal metric file
Date: Mon, 19 Feb 2024 11:44:27 -0800

Update DAMON ABI document for the quota goal target_metric file.

Link: https://lkml.kernel.org/r/20240219194431.159606-17-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-quota-goal-metric-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -229,6 +229,12 @@ Description:	Writing a number 'N' to thi
 		directories for setting automatic tuning of the scheme's
 		aggressiveness named '0' to 'N-1' under the goals/ directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_metric
+Date:		Feb 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the quota
+		auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are


