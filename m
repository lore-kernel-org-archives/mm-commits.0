Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7519A22126C
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 22:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757371301; cv=none; b=WV7aKgsh0cFVhlEr79VTQ/JdMM3F6ug90S6qhvoaD0VOnW+fxx8pmn3l48bWz16vMkgh1M7O+BQbeJtM8WqUKNHqi8EEXpyStDb8dKmUrtBSrwl/SRaMQAnMn783dvGzCfzx5s+CpOaJMxe+UsNMhBM5F0Zlca6UhDmyG2zcmFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757371301; c=relaxed/simple;
	bh=5LfjzGD3VZb++sl0CKVlpNENf6PYPS/KSKRmWd+xow8=;
	h=Date:To:From:Subject:Message-Id; b=kl8FU9HpoLSvWH6fJ7ucglfUC1/1Rba6trKtLg6oIke7SiEMIZ5iSenPwLw+TnWvFbY5pfXQX4og+C6V+wyvEiujZFU2mKP88ClskgVlEyYE6owttXFeTyuMUKtT+Ht8SCv31OubD4adYcl8EeOc7Sn7BclfhDglE183vhlWp6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IDW83gJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IDW83gJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D9FC4CEF1;
	Mon,  8 Sep 2025 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757371300;
	bh=5LfjzGD3VZb++sl0CKVlpNENf6PYPS/KSKRmWd+xow8=;
	h=Date:To:From:Subject:From;
	b=IDW83gJrslpJXCUI4SCQDshs8iNyuI3Dt85umv7TmeT3/hr+zFa+AHV0WylnSH1CU
	 1Uf0k7rxQ4+8Q2glWoRByvGR97TOrdsINXyeOE+IOJxJrp3IZwsaS+EoIaIShwpq7+
	 Rj86nHHKrkjP+uip/KOoUJCAFyNqrGFeBOwnYJxc=
Date: Mon, 08 Sep 2025 15:41:40 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch added to mm-hotfixes-unstable branch
Message-Id: <20250908224140.C6D9FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_call_control->dealloc_on_cancel
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/core: introduce damon_call_control->dealloc_on_cancel
Date: Mon, 8 Sep 2025 13:15:12 -0700

When damon_call_control->repeat is set, damon_call() is executed
asynchronously, and eventually be canceled when kdamond finishes.  If the
damon_call_control object is dynamically allocated, hence, finding the
place to deallocate the object is difficult.  Introduce a new
damon_call_control field, namely dealloc_on_cancel, to ask the kdamond
deallocates those dynamically allocated objects when those are canceled.

Link: https://lkml.kernel.org/r/20250908201513.60802-2-sj@kernel.org
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_call_control-dealloc_on_cancel
+++ a/include/linux/damon.h
@@ -636,6 +636,7 @@ struct damon_operations {
  * @data:		Data that will be passed to @fn.
  * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
+ * @dealloc_on_cancel:	De-allocate when canceled.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
  * function.  Refer to damon_call() for more details.
@@ -645,6 +646,7 @@ struct damon_call_control {
 	void *data;
 	bool repeat;
 	int return_code;
+	bool dealloc_on_cancel;
 /* private: internal use only */
 	/* informs if the kdamond finished handling of the request */
 	struct completion completion;
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_call_control-dealloc_on_cancel
+++ a/mm/damon/core.c
@@ -2479,10 +2479,14 @@ static void kdamond_call(struct damon_ct
 		mutex_lock(&ctx->call_controls_lock);
 		list_del(&control->list);
 		mutex_unlock(&ctx->call_controls_lock);
-		if (!control->repeat)
+		if (!control->repeat) {
 			complete(&control->completion);
-		else
+		} else if (control->canceled && control->dealloc_on_cancel) {
+			kfree(control);
+			continue;
+		} else {
 			list_add(&control->list, &repeat_controls);
+		}
 	}
 	control = list_first_entry_or_null(&repeat_controls,
 			struct damon_call_control, list);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch
mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch
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

