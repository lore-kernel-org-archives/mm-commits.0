Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56EB1DB951
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274602; cv=none; b=IthOqNQ52AoGv0qjdWICQ38LIXmC9coF6cNfpQ1cEZZ8aSnmnxMD9vr3Q5Sdb0mHARsN71fKOcNsbN5tyuH0TYX0E7bryp4spfgFuesKtuGeaINC8CFzXkNqxB+7pauXuSROGZY+6C2iR/cv7eElY0gBImPdG/tzHlIDl+hdAD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274602; c=relaxed/simple;
	bh=TPjiQo0IDVZeb4ocdI+fPSeD71GChWYsYbBhXFwq4z0=;
	h=Date:To:From:Subject:Message-Id; b=NJE7CpvlkiHLwRIYQl/FZxV4/gHhSMtlUkX5w44nimAppqNDdMEARbNsDW/D5eMmMBqzlKJhK1bNDgeEoFrxagt0Sd8KOqWUkdpQI8uowDn/yaXJPK2J1wGpgXD5EDA96PS9cIRs2sQa4FqQ3hP7AcnOAZa9dZmA9b48uXVszVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pSWbOzg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pSWbOzg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8516C4CEDD;
	Tue, 18 Mar 2025 05:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274602;
	bh=TPjiQo0IDVZeb4ocdI+fPSeD71GChWYsYbBhXFwq4z0=;
	h=Date:To:From:Subject:From;
	b=pSWbOzg4Tp1sIlxO5lAkxR54/WdDj7a0+TWCW8BhOTq9HQg0eQq0gRBnd3HzvFIzh
	 eq3t0fJWjkELPxKyF6I/sUp1lXPiKoXXPyLq0zp7nmPPzVbI8evPWHi8kxoJM6cYJs
	 5//d/jvvCWb0K9f2l3bIUCYlzmTqAJT7gp9QKB9I=
Date: Mon, 17 Mar 2025 22:10:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-damon_callback-private.patch removed from -mm tree
Message-Id: <20250318051002.A8516C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove damon_callback->private
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-damon_callback-private.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: remove damon_callback->private
Date: Thu, 6 Mar 2025 09:59:04 -0800

The field was added to let users keep their personal data to use inside of
the callbacks.  However, no one is actively using that now.  Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_callback-private
+++ a/include/linux/damon.h
@@ -609,12 +609,10 @@ struct damon_operations {
  * @after_aggregation:	Called after each aggregation.
  * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
- * @private:		User private data.
  *
  * The monitoring thread (&damon_ctx.kdamond) calls @before_start and
  * @before_terminate just before starting and finishing the monitoring,
- * respectively.  Therefore, those are good places for installing and cleaning
- * @private.
+ * respectively.
  *
  * The monitoring thread calls @after_wmarks_check after each DAMON-based
  * operation schemes' watermarks check.  If users need to make changes to the
@@ -630,8 +628,6 @@ struct damon_operations {
  * If any callback returns non-zero, monitoring stops.
  */
 struct damon_callback {
-	void *private;
-
 	int (*before_start)(struct damon_ctx *context);
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
_

Patches currently in -mm which might be from sj@kernel.org are


