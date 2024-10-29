Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A681E0DA7
	for <mm-commits@vger.kernel.org>; Tue, 29 Oct 2024 03:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730173425; cv=none; b=delX8d4iXArrTbT8RYMavv/827iyYnYIQSIZgjqGm/7rfclULB30GUd0z/nJq0fdeiej7RUmAsMbIZ8GfevYJPRl1DSu74mxjdUryMFhGrWh5nAjpWO/qSOuxc1V56kvlo7HzcX4ghXqonKeF8uJ3ztIWa63+dkiZwGzm7vFvts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730173425; c=relaxed/simple;
	bh=PDlTGjB4M/QTuyrbglGHcBWbcJIXQjcStoVlvD6G5u4=;
	h=Date:To:From:Subject:Message-Id; b=cr+wz2mNCy/bVwze+8TyJE9st+fLwaj2LHRxu9Ja/1QvdvIhkZ/IAo087plSAfZbTnfLXVIXBObJwoe/k5A7KT2rs1i2wl+SF8mhb4oNbRpVyIuwdoFO5LKo2C6eS0G1gEPTyy9F/FJB1A0ebS2zXOYK4REHJWLQxgYa6dc5dRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jMktu72k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jMktu72k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6790C4CECD;
	Tue, 29 Oct 2024 03:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730173424;
	bh=PDlTGjB4M/QTuyrbglGHcBWbcJIXQjcStoVlvD6G5u4=;
	h=Date:To:From:Subject:From;
	b=jMktu72k3IhH+PYyAfgSoS0507oUDXt7nENQEtyTpdAS7w4TVdDCYEoWd7hd8n/ic
	 jiR/MGxgdaHxQjs61CVTHQtuWjMxOcdgJTAqsmIHsrl9hj3E5cwUSyBBBYKleU1any
	 SHpvbG9BRRD/VWcr92u76j1tzb2bhU1ECwdPuOEQ=
Date: Mon, 28 Oct 2024 20:43:44 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,ghe@suse.com,gechangwei@live.cn,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-unused-errmsg-function-and-table.patch added to mm-nonmm-unstable branch
Message-Id: <20241029034344.D6790C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove unused errmsg function and table
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-unused-errmsg-function-and-table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-unused-errmsg-function-and-table.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: ocfs2: remove unused errmsg function and table
Date: Tue, 22 Oct 2024 01:25:43 +0100

dlm_errmsg() has been unused since 2010's commit 0016eedc4185
("ocfs2_dlmfs: Use the stackglue.")

Remove dlm_errmsg() and the message table it indexes.

Link: https://lkml.kernel.org/r/20241022002543.302606-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmapi.h   |    2 -
 fs/ocfs2/dlm/dlmdebug.c |   53 --------------------------------------
 2 files changed, 55 deletions(-)

--- a/fs/ocfs2/dlm/dlmapi.h~ocfs2-remove-unused-errmsg-function-and-table
+++ a/fs/ocfs2/dlm/dlmapi.h
@@ -62,8 +62,6 @@ enum dlm_status {
 	DLM_MAXSTATS,             /* 41: upper limit for return code validation */
 };
 
-/* for pretty-printing dlm_status error messages */
-const char *dlm_errmsg(enum dlm_status err);
 /* for pretty-printing dlm_status error names */
 const char *dlm_errname(enum dlm_status err);
 
--- a/fs/ocfs2/dlm/dlmdebug.c~ocfs2-remove-unused-errmsg-function-and-table
+++ a/fs/ocfs2/dlm/dlmdebug.c
@@ -164,59 +164,6 @@ static const char *dlm_errnames[] = {
 	[DLM_MAXSTATS] =		"DLM_MAXSTATS",
 };
 
-static const char *dlm_errmsgs[] = {
-	[DLM_NORMAL] = 			"request in progress",
-	[DLM_GRANTED] = 		"request granted",
-	[DLM_DENIED] = 			"request denied",
-	[DLM_DENIED_NOLOCKS] = 		"request denied, out of system resources",
-	[DLM_WORKING] = 		"async request in progress",
-	[DLM_BLOCKED] = 		"lock request blocked",
-	[DLM_BLOCKED_ORPHAN] = 		"lock request blocked by a orphan lock",
-	[DLM_DENIED_GRACE_PERIOD] = 	"topological change in progress",
-	[DLM_SYSERR] = 			"system error",
-	[DLM_NOSUPPORT] = 		"unsupported",
-	[DLM_CANCELGRANT] = 		"can't cancel convert: already granted",
-	[DLM_IVLOCKID] = 		"bad lockid",
-	[DLM_SYNC] = 			"synchronous request granted",
-	[DLM_BADTYPE] = 		"bad resource type",
-	[DLM_BADRESOURCE] = 		"bad resource handle",
-	[DLM_MAXHANDLES] = 		"no more resource handles",
-	[DLM_NOCLINFO] = 		"can't contact cluster manager",
-	[DLM_NOLOCKMGR] = 		"can't contact lock manager",
-	[DLM_NOPURGED] = 		"can't contact purge daemon",
-	[DLM_BADARGS] = 		"bad api args",
-	[DLM_VOID] = 			"no status",
-	[DLM_NOTQUEUED] = 		"NOQUEUE was specified and request failed",
-	[DLM_IVBUFLEN] = 		"invalid resource name length",
-	[DLM_CVTUNGRANT] = 		"attempted to convert ungranted lock",
-	[DLM_BADPARAM] = 		"invalid lock mode specified",
-	[DLM_VALNOTVALID] = 		"value block has been invalidated",
-	[DLM_REJECTED] = 		"request rejected, unrecognized client",
-	[DLM_ABORT] = 			"blocked lock request cancelled",
-	[DLM_CANCEL] = 			"conversion request cancelled",
-	[DLM_IVRESHANDLE] = 		"invalid resource handle",
-	[DLM_DEADLOCK] = 		"deadlock recovery refused this request",
-	[DLM_DENIED_NOASTS] = 		"failed to allocate AST",
-	[DLM_FORWARD] = 		"request must wait for primary's response",
-	[DLM_TIMEOUT] = 		"timeout value for lock has expired",
-	[DLM_IVGROUPID] = 		"invalid group specification",
-	[DLM_VERS_CONFLICT] = 		"version conflicts prevent request handling",
-	[DLM_BAD_DEVICE_PATH] = 	"Locks device does not exist or path wrong",
-	[DLM_NO_DEVICE_PERMISSION] = 	"Client has insufficient perms for device",
-	[DLM_NO_CONTROL_DEVICE] = 	"Cannot set options on opened device ",
-	[DLM_RECOVERING] = 		"lock resource being recovered",
-	[DLM_MIGRATING] = 		"lock resource being migrated",
-	[DLM_MAXSTATS] = 		"invalid error number",
-};
-
-const char *dlm_errmsg(enum dlm_status err)
-{
-	if (err >= DLM_MAXSTATS || err < 0)
-		return dlm_errmsgs[DLM_MAXSTATS];
-	return dlm_errmsgs[err];
-}
-EXPORT_SYMBOL_GPL(dlm_errmsg);
-
 const char *dlm_errname(enum dlm_status err)
 {
 	if (err >= DLM_MAXSTATS || err < 0)
_

Patches currently in -mm which might be from linux@treblig.org are

ocfs2-remove-unused-errmsg-function-and-table.patch

