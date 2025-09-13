Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA5F23D7DB
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757794169; cv=none; b=lwN1SRVTt9TYRx+Bttqh/XAOxPkODSIoeGl5gINA41TZaJnwZsI6zV5/cDgj5uW3RvrkVl8tpEqYR/RDnMc7YKqlzvy1/0r7uLp0EvDu35j3Ben2BOPQu0S6rF9/WmW5QkiycwwBsxHGyupNQr79HFmjFH+paQobeFQYlarn0Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757794169; c=relaxed/simple;
	bh=f8MumAnEhKY47+w0Nd9m1+Qpi9F2e44riU0sOljhtFg=;
	h=Date:To:From:Subject:Message-Id; b=mkzJeTgqCSqBjez7QJvWUmHS/WN5N2pVxENmlLS/bV/f+W3cDm80wQ9stRn7CeooXP/0NV0Sopp60R/Uwx5ELZqj09PyoSXagIQgffTodzY2V8FiisXnWTug9uvt1dVRJ0ngLsApc+AFRO4vz/nDjLDNJOeIz0v22XfDdRvn3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=msHOKU74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="msHOKU74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683E3C4CEF5;
	Sat, 13 Sep 2025 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757794169;
	bh=f8MumAnEhKY47+w0Nd9m1+Qpi9F2e44riU0sOljhtFg=;
	h=Date:To:From:Subject:From;
	b=msHOKU745crbCgSC+ygrTDSEIbfsl343WbFU9sjVV+8CQmlaRZAhF9CmRre9ruHyM
	 H0Ln+fBXnk+DGvsrq9FcAJXDahtg6JmPxpqrGSSHN28+of+rROgOfK6WZ58suBPg0L
	 QgKsMK/ZVYe7XFLbXnNT3SyMtokN7QhVbnHAfDfs=
Date: Sat, 13 Sep 2025 13:09:28 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch removed from -mm tree
Message-Id: <20250913200929.683E3C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_call_control->dealloc_on_cancel
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_call_control->dealloc_on_cancel
Date: Mon, 8 Sep 2025 13:15:12 -0700

Patch series "mm/damon/sysfs: fix refresh_ms control overwriting on
multi-kdamonds usages".

Automatic esssential DAMON/DAMOS status update feature of DAMON sysfs
interface (refresh_ms) is broken [1] for multiple DAMON contexts
(kdamonds) use case, since it uses a global single damon_call_control
object for all created DAMON contexts.  The fields of the object,
particularly the list field is over-written for the contexts and it makes
unexpected results including user-space hangup and kernel crashes [2]. 
Fix it by extending damon_call_control for the use case and updating the
usage on DAMON sysfs interface to use per-context dynamically allocated
damon_call_control object.


This patch (of 2):

When damon_call_control->repeat is set, damon_call() is executed
asynchronously, and is eventually canceled when kdamond finishes.  If the
damon_call_control object is dynamically allocated, finding the place to
deallocate the object is difficult.  Introduce a new damon_call_control
field, namely dealloc_on_cancel, to ask the kdamond deallocates those
dynamically allocated objects when those are canceled.

Link: https://lkml.kernel.org/r/20250908201513.60802-3-sj@kernel.org
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

