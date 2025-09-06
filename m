Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB53523A;
	Sat,  6 Sep 2025 00:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757117668; cv=none; b=AYo0ch29tLlez9xWApAvb9nfxPtmg4/zYse6eNZlngAqZ3bMB/2k29/bq0A3KdkAfGrF5JN3lwlBbu6DL8kvGGtziD9cCLmqOeDNBEMd2070J1Ha8FsOwFsS0BxAPVAsnAkFAi8ls1CUTSzniol4qSCD0GdDLcppLOeMw0NnKUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757117668; c=relaxed/simple;
	bh=4KdJgxxG9SGBqZCqqYjQb1WwwbrpoQBJntbEZ+J9w/o=;
	h=Date:To:From:Subject:Message-Id; b=d9RSGvdoJ5l0OWpF5jK5lbUJzx0xHFQ/WuN+B9KOeiSgS4rMWeP4IpmOM0ZtP8V2I7FG8PyY7dllmd9+xDBS9/FIR7RtN0mk8Ixu3n0IsBI4pbnFTokDNDIoQC8el+cpaMQaRjDeQQyW4yhqgwvjlWz6yoRnC03BnTR3W8h1lUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XDXAKREY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XDXAKREY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADC0C4CEF1;
	Sat,  6 Sep 2025 00:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757117667;
	bh=4KdJgxxG9SGBqZCqqYjQb1WwwbrpoQBJntbEZ+J9w/o=;
	h=Date:To:From:Subject:From;
	b=XDXAKREYFk8ARsIjmiokxtBHcOOyGSeE/9/O4W5vCTIdu8Yx5IjGeuueOSfqBmZ9k
	 DTU9NFJAtUHniFiEfayMs4faIVI1BGjNZL5hJiZdbqwvi0NGDdPhuMR93HSsI8rBLL
	 NsGcU2KQHTlhXMpNBdZDgbp0cBPVkL0YPCiadDy8=
Date: Fri, 05 Sep 2025 17:14:26 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,disclosure@aisle.com,stanislav.fort@aisle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-fix-use-after-free-in-state_show.patch added to mm-hotfixes-unstable branch
Message-Id: <20250906001427.AADC0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: fix use-after-free in state_show()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-sysfs-fix-use-after-free-in-state_show.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-fix-use-after-free-in-state_show.patch

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
From: Stanislav Fort <stanislav.fort@aisle.com>
Subject: mm/damon/sysfs: fix use-after-free in state_show()
Date: Fri, 5 Sep 2025 13:10:46 +0300

state_show() reads kdamond->damon_ctx without holding damon_sysfs_lock. 
This allows a use-after-free race:

CPU 0                         CPU 1
-----                         -----
state_show()                  damon_sysfs_turn_damon_on()
ctx = kdamond->damon_ctx;     mutex_lock(&damon_sysfs_lock);
                              damon_destroy_ctx(kdamond->damon_ctx);
                              kdamond->damon_ctx = NULL;
                              mutex_unlock(&damon_sysfs_lock);
damon_is_running(ctx);        /* ctx is freed */
mutex_lock(&ctx->kdamond_lock); /* UAF */

(The race can also occur with damon_sysfs_kdamonds_rm_dirs() and
damon_sysfs_kdamond_release(), which free or replace the context under
damon_sysfs_lock.)

Fix by taking damon_sysfs_lock before dereferencing the context, mirroring
the locking used in pid_show().

The bug has existed since state_show() first accessed kdamond->damon_ctx.

Link: https://lkml.kernel.org/r/20250905101046.2288-1-disclosure@aisle.com
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
Reported-by: Stanislav Fort <disclosure@aisle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-fix-use-after-free-in-state_show
+++ a/mm/damon/sysfs.c
@@ -1260,14 +1260,18 @@ static ssize_t state_show(struct kobject
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	bool running;
+	struct damon_ctx *ctx;
+	bool running = false;
 
-	if (!ctx)
-		running = false;
-	else
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+
+	ctx = kdamond->damon_ctx;
+	if (ctx)
 		running = damon_is_running(ctx);
 
+	mutex_unlock(&damon_sysfs_lock);
+
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);
_

Patches currently in -mm which might be from stanislav.fort@aisle.com are

mm-damon-sysfs-fix-use-after-free-in-state_show.patch

