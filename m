Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E4185B6E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855671; cv=none; b=NH+oKh4infXedmVY9C5fCpD7LXItmXgINJFSXx36+v5P7U5TXbt2iS4RDNZ6s9c1gnBgwqO1ZPSzDo0N9H7l2zKYzPq1oOW+HXm64lxaKEitMNhcBN/q4RNjSXm7YsInkplNUUYym6HmSSxrqGIdranh8DjDA9RX5rDS5BCAri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855671; c=relaxed/simple;
	bh=gkMZ368NanWXxcDyIJ7KUZxC0NKOp0+38USD7LG320M=;
	h=Date:To:From:Subject:Message-Id; b=BSgyL400g6xdnKdFfRhux7GsUvOF5cS48HcVTwxVISg1XRFsy8WeKhUSdKDNJUtJu944cICDQEl/Za2PDA8LHtAvg8SpLZiMfYloy1d5Ztr1s8zj6+Uun+1zbhgmxXZbzNYRdALOiFIaE8Dj9tcTysHWmel6D+GMd9oDls9eX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNOoA1Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNOoA1Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B09C4CECF;
	Wed,  6 Nov 2024 01:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855671;
	bh=gkMZ368NanWXxcDyIJ7KUZxC0NKOp0+38USD7LG320M=;
	h=Date:To:From:Subject:From;
	b=gNOoA1XzmadULEQvwqzoF6mlrA9NczMupc17X05BkLQKuGtiO+a0chk5abcGiTl8a
	 Mdyfs+54xUO/orTvva/zEXYsb+7VSi2F9uopTcKJMvqQbvdHngNIGy0JmyGoRhlOlF
	 7JHUCdAhwxWlOGvd9hj/qNFo8iLt/ukngr1ESx+w=
Date: Tue, 05 Nov 2024 17:14:30 -0800
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-remove-unused-errmsg-function-and-table.patch removed from -mm tree
Message-Id: <20241106011431.84B09C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: remove unused errmsg function and table
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unused-errmsg-function-and-table.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


