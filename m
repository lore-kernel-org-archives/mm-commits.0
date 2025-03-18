Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE161C700A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274597; cv=none; b=biR61acQnqTrY98CvLJC+4Nm6pdissiCW8f3TM+T2vXem8tmbFqtajQig7Ph6MYlpaSS8ubNyiyj/lrFL4RjqbjuN77C85bgts5dYe/W2G3Omk1ddUcUlJPNLGhNaacNUACrI10bSOyCt+b6eRWUy7/mkwmAD6TyEiQQVM/3mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274597; c=relaxed/simple;
	bh=SPiwvjq9ntfujpKuZOjAlm4Ozidm63afpP5fySP9dgg=;
	h=Date:To:From:Subject:Message-Id; b=uOUXjTvOSKXcAW2WJHPx1sw2QzofGAHyVobgpDYSdyDP42MPYZSW0xmEaKNTC3nJZN3ixTgZcbjJAlc5LJQit3t/IuxMVJQtBlJYyV1bKFygxlXvk69fZB8QrAxOw9Haz/HSe4sleI06nTp7zJmnTc4MEYf2jXOL5nQzJsLga7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0LeVTVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0LeVTVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED50C4CEDD;
	Tue, 18 Mar 2025 05:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274597;
	bh=SPiwvjq9ntfujpKuZOjAlm4Ozidm63afpP5fySP9dgg=;
	h=Date:To:From:Subject:From;
	b=h0LeVTVEXmkTR9Nf2nTLNO8rvaGE1NS0N0o0i+ETFdsaaMRAVHhtpnHUs4Vl/UvI2
	 pATYNFH5XCySY6hFmTum+mftoLP7xyN+Aq92UbeoeVVY+gewMIEYNT1TUfJIioPp53
	 E9BpZX7/pBXJsQnnfFYXUYlgMvCXd1VNzEhN2Xts=
Date: Mon, 17 Mar 2025 22:09:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-handle-commit-command-using-damon_call.patch removed from -mm tree
Message-Id: <20250318050957.5ED50C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: handle commit command using damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-handle-commit-command-using-damon_call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: handle commit command using damon_call()
Date: Thu, 6 Mar 2025 09:58:59 -0800

DAMON sysfs interface is using damon_callback->after_aggregation hook with
its self-implemented synchronization mechanism for the hook.  It is
inefficient, complicated, and take up to one aggregation interval to
complete, which can be long on some configs.

Use damon_call() instead.  It provides a synchronization mechanism that
built inside DAMON's core layer, so more efficient than DAMON sysfs
interface's own one.  Also it isolates the implementation inside the core
layer, and hence it makes the code easier to maintain.  Finally, it takes
up to one sampling interval, which is much shorter than the aggregation
interval in common setups.

Link: https://lkml.kernel.org/r/20250306175908.66300-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-handle-commit-command-using-damon_call
+++ a/mm/damon/sysfs.c
@@ -1451,8 +1451,9 @@ static struct damon_ctx *damon_sysfs_bui
  *
  * Returns error if the sysfs input is wrong.
  */
-static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
+static int damon_sysfs_commit_input(void *data)
 {
+	struct damon_sysfs_kdamond *kdamond = data;
 	struct damon_ctx *param_ctx, *test_ctx;
 	int err;
 
@@ -1550,11 +1551,6 @@ static int damon_sysfs_cmd_request_callb
 	if (!kdamond || kdamond->damon_ctx != c)
 		goto out;
 	switch (damon_sysfs_cmd_request.cmd) {
-	case DAMON_SYSFS_CMD_COMMIT:
-		if (!after_aggregation)
-			goto out;
-		err = damon_sysfs_commit_input(kdamond);
-		break;
 	default:
 		break;
 	}
@@ -1712,11 +1708,7 @@ static int damon_sysfs_update_schemes_tr
  * @cmd:	The command to handle.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
- * This function handles a DAMON sysfs command for a kdamond.  For commands
- * that need to access running DAMON context-internal data, it requests
- * handling of the command to the DAMON callback
- * (@damon_sysfs_cmd_request_callback()) and wait until it is properly handled,
- * or the context is completed.
+ * This function handles a DAMON sysfs command for a kdamond.
  *
  * Return: 0 on success, negative error code otherwise.
  */
@@ -1730,6 +1722,9 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_COMMIT:
+		return damon_sysfs_damon_call(
+				damon_sysfs_commit_input, kdamond);
 	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_commit_schemes_quota_goals,
_

Patches currently in -mm which might be from sj@kernel.org are


