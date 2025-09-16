Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E82321CC44
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757997226; cv=none; b=BViw6F+8gqjUE3tQQAzKigXWlIehg1+P/wWh5W4rWGCGZmHj0k04l/Tj8VtL6XJT2y20KjPVCTRIxvioCovHvKd0RFD6R8brwj45LB857dH+xZHd83Amz/77gqK6e0F3bx19rKpPB5PuVnNLDasQUgBifIw3DzvaM4ZuVx3Gngk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757997226; c=relaxed/simple;
	bh=XfCJ+8o4Ep9Yb7bzmyiqe/40/uQ+xzeFVhx3wc5mNLQ=;
	h=Date:To:From:Subject:Message-Id; b=rfaenvBURHQNicbzGz8iq4juhJrN+c6V/kI/SjMi7hQTan9kP6DXnddJHhNOj8utx/lqn1jPdEWB7R54KehZX94+u2xsuXabL6jc5JsVtDR7CJ3+VwmZ4/z5NTocDqWW65AnUh4ili4ljEx2grMhorp+03RUFjt1vq5UR6c1mUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J1o0OhUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J1o0OhUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F816C4CEEB;
	Tue, 16 Sep 2025 04:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757997225;
	bh=XfCJ+8o4Ep9Yb7bzmyiqe/40/uQ+xzeFVhx3wc5mNLQ=;
	h=Date:To:From:Subject:From;
	b=J1o0OhUxiRKM9hIbAmfwjQitH444G5n4fzsQ3DgM9/1dl1ddTnko8ZeFoP92ES6iL
	 e3YOrHTmqXWQKMuDmqWjX/RRXlN3qn0HGNMhtuBgR0U8eMf7Rkf0RJBQTOjBlDsLGC
	 LfLRGc0BkWDouFne0Ypl9rScF2STchQCH+cmGRJ8=
Date: Mon, 15 Sep 2025 21:33:44 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-use-damon_initialized.patch added to mm-new branch
Message-Id: <20250916043345.6F816C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: use damon_initialized()
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-wsse-use-damon_initialized.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-use-damon_initialized.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: samples/damon/wsse: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:09 -0700

damon_sample_wsse is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Link: https://lkml.kernel.org/r/20250916033511.116366-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-use-damon_initialized
+++ a/samples/damon/wsse.c
@@ -102,8 +102,6 @@ static void damon_sample_wsse_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_wsse_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -117,10 +115,10 @@ static int damon_sample_wsse_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
-	if (enabled) {
-		if (!init_called)
-			return 0;
+	if (!damon_initialized())
+		return 0;
 
+	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
 			enabled = false;
@@ -134,7 +132,12 @@ static int __init damon_sample_wsse_init
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		if (enabled)
+			enabled = false;
+	}
+
 	if (enabled) {
 		err = damon_sample_wsse_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch
mm-damon-core-implement-damon_initialized-function.patch
mm-damon-stat-use-damon_initialized.patch
mm-damon-reclaim-use-damon_initialized.patch
mm-damon-lru_sort-use-damon_initialized.patch
samples-damon-wsse-use-damon_initialized.patch
samples-damon-prcl-use-damon_initialized.patch
samples-damon-mtier-use-damon_initialized.patch

