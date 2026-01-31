Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C938A9B1
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 22:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769898336; cv=none; b=meR1cXnxjTVK7Z9dL0EmHchY9zkBKTOjkI4blm6pVD4jCUWgh8JykKRWDrsp4goaOHwb+Ic1L2nHvjaqQgCRL6MYOcwguTfJt7aVTB8zAfhYdLEIYV7GrilTedrZOBzSm2OyMfpYuXfx20Y23xPJq29Tqx7pqZWp4AbF+qjeR/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769898336; c=relaxed/simple;
	bh=bUnqts6ddRa3YJEpNZlUsGqtXEpNyMN8YBVh6H/Hilw=;
	h=Date:To:From:Subject:Message-Id; b=aOacGInn6u/mvHRHcY3i3LjzUC3AMQRcDCeDjxUcL6EowzUJhC1vP4qWq0W+iMEeLQhHmluLgb0AymePzvwmGA+Ui16kFb+G4wOAdi9Gg3FFTX+SPCxZcZotUTdIuwu75c0OPGEnFFyr04vt1RsqdwT64i0A2H9V0876WkuG4VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N40PWzoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N40PWzoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856DCC4CEF1;
	Sat, 31 Jan 2026 22:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769898336;
	bh=bUnqts6ddRa3YJEpNZlUsGqtXEpNyMN8YBVh6H/Hilw=;
	h=Date:To:From:Subject:From;
	b=N40PWzoecKHnbKzt14hpdoeC4GqCJ5T1W64yrtPFNYmQG9exY8iDJ1dNvyf4K3/8t
	 uv2bB7FWXyahMcTUkUDxJzCL2JDnc9n5aMP/CiWUHLfihH8C+aRhYpRMC4sDF98rIU
	 Bh9OJ+IVJg/yryTNAFb06U+3/Y29jKQB5TMi8fXc=
Date: Sat, 31 Jan 2026 14:25:36 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch removed from -mm tree
Message-Id: <20260131222536.856DCC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: process damon_call_control requests on a local list
has been removed from the -mm tree.  Its filename was
     mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: process damon_call_control requests on a local list
Date: Sat, 17 Jan 2026 09:52:51 -0800

kdamond_call() handles damon_call() requests on the ->call_controls list
of damon_ctx, which is shared with damon_call() callers.  To protect the
list from concurrent accesses while letting the callback function
independent of the call_controls_lock, the function does complicated
locking operations.  For each damon_call_control object on the list, the
function removes the control object from the list under locking, invoke
the callback of the control object without locking, and then puts the
control object back to the list if needed, under locking.  It is
complicated, and can contend the locks more frequently with other DAMON
API caller threads as the number of concurrent callback requests
increases.  Contention overhead is not a big deal, but the increased race
opportunity can make headaches.

Simplify the locking sequence by moving all damon_call_control objects
from the shared list to a local list at once under the single lock
protection, processing the callback requests without locking, and adding
back repeat mode controls to the shared list again at once again, again
under the single lock protection.  This change makes the number of locking
in kdamond_call() be always two, regardless of the number of the queued
requests.

Link: https://lkml.kernel.org/r/20260117175256.82826-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   59 ++++++++++++++++------------------------------
 1 file changed, 21 insertions(+), 38 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-process-damon_call_control-requests-on-a-local-list
+++ a/mm/damon/core.c
@@ -2649,48 +2649,31 @@ static void kdamond_usleep(unsigned long
  */
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
-	struct damon_call_control *control;
-	LIST_HEAD(repeat_controls);
-	int ret = 0;
-
-	while (true) {
-		mutex_lock(&ctx->call_controls_lock);
-		control = list_first_entry_or_null(&ctx->call_controls,
-				struct damon_call_control, list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control)
-			break;
-		if (cancel) {
+	struct damon_call_control *control, *next;
+	LIST_HEAD(controls);
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail_init(&ctx->call_controls, &controls);
+	mutex_unlock(&ctx->call_controls_lock);
+
+	list_for_each_entry_safe(control, next, &controls, list) {
+		if (!control->repeat || cancel)
+			list_del(&control->list);
+
+		if (cancel)
 			control->canceled = true;
-		} else {
-			ret = control->fn(control->data);
-			control->return_code = ret;
-		}
-		mutex_lock(&ctx->call_controls_lock);
-		list_del(&control->list);
-		mutex_unlock(&ctx->call_controls_lock);
-		if (!control->repeat) {
+		else
+			control->return_code = control->fn(control->data);
+
+		if (!control->repeat)
 			complete(&control->completion);
-		} else if (control->canceled && control->dealloc_on_cancel) {
+		else if (control->canceled && control->dealloc_on_cancel)
 			kfree(control);
-			continue;
-		} else {
-			list_add(&control->list, &repeat_controls);
-		}
-	}
-	while (true) {
-		control = list_first_entry_or_null(&repeat_controls,
-				struct damon_call_control, list);
-		if (!control)
-			break;
-		/* Unlink from the repeate_controls list. */
-		list_del(&control->list);
-		if (cancel)
-			continue;
-		mutex_lock(&ctx->call_controls_lock);
-		list_add(&control->list, &ctx->call_controls);
-		mutex_unlock(&ctx->call_controls_lock);
 	}
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_splice_tail(&controls, &ctx->call_controls);
+	mutex_unlock(&ctx->call_controls_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from sj@kernel.org are


