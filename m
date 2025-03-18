Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B9D1C700A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274598; cv=none; b=unCmCrvn92JHDbfcGzXJ0Tsr81iDfn4GkYC1MvNlBXPPYPvW6t8pqHxqTx6+sm1aYGgeaGsP7OTRMR0bXCH2je8oArwOyQPgHX6OP1/Hpbnf2ikC0ZWJLHp6mi3PLVzjPabJwmVnh6dDxc8VdpGOJPTTpfdTBsDvVGxvWL2Nmww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274598; c=relaxed/simple;
	bh=080PxQM72R3Ted0r/wyXrgtaxb5Uvo56m3BN1nH3asg=;
	h=Date:To:From:Subject:Message-Id; b=iM7w+dJkcbkEjawEYaEKgT4khRDwKMX5fZWDQ6mLvdTngGi/ToVB/7W400WCRUvWxz1PDSaX9iZvxUwinsp8T7ffygaH/Qnpn6BeQ0e3QnPMIODzrA8/ItHJCsTbAjsd46T1DiWXg0fSKMpgwR1B6rnJR6skraPpE7wkAksIJD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wK9Fy64a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wK9Fy64a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBD4C4CEDD;
	Tue, 18 Mar 2025 05:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274598;
	bh=080PxQM72R3Ted0r/wyXrgtaxb5Uvo56m3BN1nH3asg=;
	h=Date:To:From:Subject:From;
	b=wK9Fy64aD+V1FKmpIkHG6NORyRe6jVEVGTFCG5k/JEKTyX9W6mEGPPqSsSzZcbsNu
	 ohrgQEjwlhsXzOqEto8gaq8niI9REutja7vhdXuw7lXsPSYJ6vRxf0qJnNhant2J4X
	 4LxmY/NsgKivSsoIE1aRh/Gkd7tjKpGc/3A4evf4=
Date: Mon, 17 Mar 2025 22:09:57 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch removed from -mm tree
Message-Id: <20250318050958.6DBD4C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request code from damon_sysfs_handle_cmd()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request code from damon_sysfs_handle_cmd()
Date: Thu, 6 Mar 2025 09:59:00 -0800

damon_sysfs_handle_cmd() handles user requests that it can directly handle
on its own.  For requests that need to be handled from damon_callback
hooks, it uses DAMON sysfs interface's own synchronous damon_callback
hooks management mechanism, namely damon_sysfs_cmd_request.  Now all user
requests are handled without damon_callback hooks, so
damon_sysfs_cmd_request client code in damon_sysfs_andle_cmd() does
nothing in real.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20250306175908.66300-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd
+++ a/mm/damon/sysfs.c
@@ -1715,8 +1715,6 @@ static int damon_sysfs_update_schemes_tr
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
-	bool need_wait = true;
-
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
@@ -1747,38 +1745,8 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_tuned_intervals, kdamond);
 	default:
-		break;
-	}
-
-	/* Pass the command to DAMON callback for safe DAMON context access */
-	if (damon_sysfs_cmd_request.kdamond)
-		return -EBUSY;
-	if (!damon_sysfs_kdamond_running(kdamond))
 		return -EINVAL;
-	damon_sysfs_cmd_request.cmd = cmd;
-	damon_sysfs_cmd_request.kdamond = kdamond;
-
-	/*
-	 * wait until damon_sysfs_cmd_request_callback() handles the request
-	 * from kdamond context
-	 */
-	mutex_unlock(&damon_sysfs_lock);
-	while (need_wait) {
-		schedule_timeout_idle(msecs_to_jiffies(100));
-		if (!mutex_trylock(&damon_sysfs_lock))
-			continue;
-		if (!damon_sysfs_cmd_request.kdamond) {
-			/* damon_sysfs_cmd_request_callback() handled */
-			need_wait = false;
-		} else if (!damon_sysfs_kdamond_running(kdamond)) {
-			/* kdamond has already finished */
-			need_wait = false;
-			damon_sysfs_cmd_request.kdamond = NULL;
-		}
-		mutex_unlock(&damon_sysfs_lock);
 	}
-	mutex_lock(&damon_sysfs_lock);
-	return 0;
 }
 
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
_

Patches currently in -mm which might be from sj@kernel.org are


