Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE004635;
	Sat, 13 Sep 2025 20:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794178; cv=none; b=c3rglF02FnOJBrHApQn3niehBtwGLdx+uoPcZVf6D44rBzWtOo0J4Cf/kPzW/J+ChIAdAfbEVlCeRVYzkdfNuVK4gd7u8bDNQmIWH7XquBTPLGMqTnp4B+ynk/qN62mMFgYLWTDzqrcPcWIY/TCYjsFCXvGuNyeQSH7QhBeQGRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794178; c=relaxed/simple;
	bh=wkl9/7qtEY8jWScAmEa3qXRPpJeGiJ65ZkLLnhLzR3Y=;
	h=Date:To:From:Subject:Message-Id; b=g2Y6GzKtD2p5TVdsClZEAzt3Lc5oIiwqUFb+qDajl+YeI1qvwkHISOBfBeIgAxn7lQSnv8o5iGInGB/Txgaw97pvroovIiBLcloTS4iXypOqJfIg6XGKV1qXhm1B+HsfPLeI+pdRcbaYINWn3tpicmNJIpfFHqPiVStcTOrB3ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQkV5Xt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQkV5Xt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D78DC4CEEB;
	Sat, 13 Sep 2025 20:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794178;
	bh=wkl9/7qtEY8jWScAmEa3qXRPpJeGiJ65ZkLLnhLzR3Y=;
	h=Date:To:From:Subject:From;
	b=UQkV5Xt2VW+CLDOFRf9PIxZnJcWRxcUIyUau8HXVVsYzw/XF90e+lCypADoOc433R
	 GgI0wC1zRbsZ+FucN04J5kWkzW8sKawXXMJQ+v3PaFhh55hjcu+daRhziSE+VAQCC2
	 SmJJ3Ex+kGOUeqikoZYQMvI2I2j0EkYETk9nqujg=
Date: Sat, 13 Sep 2025 13:09:37 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] samples-damon-mtier-avoid-starting-damon-before-initialization.patch removed from -mm tree
Message-Id: <20250913200938.4D78DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/mtier: avoid starting DAMON before initialization
has been removed from the -mm tree.  Its filename was
     samples-damon-mtier-avoid-starting-damon-before-initialization.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: samples/damon/mtier: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:38 -0700

Commit 964314344eab ("samples/damon/mtier: support boot time enable
setup") is somehow incompletely applying the origin patch [1].  It is
missing the part that avoids starting DAMON before module initialization. 
Probably a mistake during a merge has happened.  Fix it by applying the
missed part again.

Link: https://lkml.kernel.org/r/20250909022238.2989-4-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-4-sj@kernel.org [1]
Fixes: 964314344eab ("samples/damon/mtier: support boot time enable setup")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/mtier.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/mtier.c~samples-damon-mtier-avoid-starting-damon-before-initialization
+++ a/samples/damon/mtier.c
@@ -208,6 +208,9 @@ static int damon_sample_mtier_enable_sto
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_mtier_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

