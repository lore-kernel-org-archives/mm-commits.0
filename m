Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDA430FC09
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967406; cv=none; b=KbSW9jLU+FRXadOIspObBK8Yn0KYlFP7mKzu157BZuG+NNs75HUECzPAdsH8hV5e7cUEw5CGgwvoYS5icu1OCkVoXpcjsHbGOBRIs9wMwpKsZvAHR+eU5Uns1qwOzkyThNqon7huGOp7br3AVukPwzgP+eaCWV4u2vDtAiq9QDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967406; c=relaxed/simple;
	bh=DGH8bcwV02MxPlB704uu/STbVWwTKHbZSBIMv555hfQ=;
	h=Date:To:From:Subject:Message-Id; b=CJwbejb2lICPrMz5X812yNZJnopjV95I3tkiL/kXgDkHO9BQ79yAihKhU1eZ45/d6VKY8S4kxoPmEB9a97IdlBFppb6KTg+p7mtnEG98sFyGTCZY7LkqBFz+psHOfWqvAVdtWdQIwuvgwTFW9ipQV+lYRI+XgMvKGOuw3Pj3BW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aNBocx0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aNBocx0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B451CC116D0;
	Wed, 21 Jan 2026 03:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967405;
	bh=DGH8bcwV02MxPlB704uu/STbVWwTKHbZSBIMv555hfQ=;
	h=Date:To:From:Subject:From;
	b=aNBocx0JlkQDeghCKuTVUNzq+bAsHTkAgzILSRQ2bxsqlccQCi6D6b43yRBg++nEF
	 QCXg5iFFqcYD0VGIPcDm6pxc8j345gUIdA79UOczCmuVlMZT3hPraxDiHNDZkV1HGu
	 pvYkk8k1zsKKK0Gb6fM0OWGWyIJOqPnCgRylcyx0=
Date: Tue, 20 Jan 2026 19:50:05 -0800
To: mm-commits@vger.kernel.org,reinette.chatre@intel.com,edumazet@google.com,tony.luck@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch removed from -mm tree
Message-Id: <20260121035005.B451CC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: once: don't use a work queue to reset sleepable static key
has been removed from the -mm tree.  Its filename was
     once-dont-use-a-work-queue-to-reset-sleepable-static-key.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Luck, Tony" <tony.luck@intel.com>
Subject: once: don't use a work queue to reset sleepable static key
Date: Mon, 12 Jan 2026 10:08:53 -0800

Pointless overhead to use a work queue to reset the static key for a
DO_ONCE_SLEEPABLE() invocation.

Note that the previous code path included a BUG_ON() if the static key
was already disabled. Dropped that as part of this change because:
1) Use of BUG_ON() is highly discouraged.
2) There is a WARN_ON() in the static_branch_disable() code path
   that would provide adequate breadcrumbs to debug any issue.

Link: https://lkml.kernel.org/r/aWU4tfTju1l3oZCu@agluck-desk3
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/once.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/once.c~once-dont-use-a-work-queue-to-reset-sleepable-static-key
+++ a/lib/once.c
@@ -93,6 +93,6 @@ void __do_once_sleepable_done(bool *done
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	once_disable_jump(once_key, mod);
+	static_branch_disable(once_key);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);
_

Patches currently in -mm which might be from tony.luck@intel.com are


