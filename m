Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8868E332629;
	Wed, 15 Apr 2026 09:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776244548; cv=none; b=I/wzLTdqgb8T0Ybs8OIbXW8l7UjfgeMSeijrRSfTFT6XG+n9LsHN8lib4ZJUQJsdSB6G4Jatpy0jDlck1iPyP9wbepNhz/hUSN/10XYyasbU+ZCwvpUesDycbfkEAz1XvspGO4cKtUewQ3aPOc0eYnDQw7BstC1H9wBTdgBmFm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776244548; c=relaxed/simple;
	bh=GFDEQoxdJApsSirlTDsmFqNZgiVYM0SnfIYI2fsJNgY=;
	h=Date:To:From:Subject:Message-Id; b=hZyZ6B7sn4oDIIuXyikhG1CfQwH7vQZvTVgL5mRRXYFwtYErv9uFatbpc8Bzyl+CLZOSXU2ayOZNvmrT2fwEPJ0dCUKJYHrVN+DN7+RavVXY+U3XbssP+l/pgAcrnsEv3keMvcUm3cJrEonb5x0gm/CpSvogOMbUHPR2sYYKOiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zcm9Hjzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zcm9Hjzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAA1C19424;
	Wed, 15 Apr 2026 09:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776244548;
	bh=GFDEQoxdJApsSirlTDsmFqNZgiVYM0SnfIYI2fsJNgY=;
	h=Date:To:From:Subject:From;
	b=Zcm9Hjznyf2Ax0iDLyoLC5Q/cX/HN9l+u4HCGJcPxUQNx1uwSajtISLS/CF7IsC01
	 SwqZek0pSe+5IxOLHigpyC73RNrqj2ptZduC846DzUBZq8rJKsJpvUH6sEuLwMen82
	 0n4pqOzdB+Td0GBWUUT4I6h5Ww9ig+Qh1p7GD8XQ=
Date: Wed, 15 Apr 2026 02:15:44 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,thomas.orgis@uni-hamburg.de,stable@vger.kernel.org,fan.yu9@zte.com.cn,bsingharora@gmail.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-set-version-in-tgid-exit-notifications.patch removed from -mm tree
Message-Id: <20260415091547.DBAA1C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: set version in TGID exit notifications
has been removed from the -mm tree.  Its filename was
     taskstats-set-version-in-tgid-exit-notifications.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: set version in TGID exit notifications
Date: Mon, 30 Mar 2026 03:00:40 +0800

delay accounting started populating taskstats records with a valid version
field via fill_pid() and fill_tgid().

Later, commit ad4ecbcba728 ("[PATCH] delay accounting taskstats interface
send tgid once") changed the TGID exit path to send the cached
signal->stats aggregate directly instead of building the outgoing record
through fill_tgid().  Unlike fill_tgid(), fill_tgid_exit() only
accumulates accounting data and never initializes stats->version.

As a result, TGID exit notifications can reach userspace with version == 0
even though PID exit notifications and TASKSTATS_CMD_GET replies carry a
valid taskstats version.

This is easy to reproduce with `tools/accounting/getdelays.c`.

I have a small follow-up patch for that tool which:

1. increases the receive buffer/message size so the pid+tgid
   combined exit notification is not dropped/truncated

2. prints `stats->version`.

With that patch, the reproducer is:

  Terminal 1:
    ./getdelays -d -v -l -m 0

  Terminal 2:
    taskset -c 0 python3 -c 'import threading,time; t=threading.Thread(target=time.sleep,args=(0.1,)); t.start(); t.join()'

That produces both PID and TGID exit notifications for the same
process.  The PID exit record reports a valid taskstats version, while
the TGID exit record reports `version 0`.


This patch (of 2):

Set stats->version = TASKSTATS_VERSION after copying the cached TGID
aggregate into the outgoing netlink payload so all taskstats records are
self-describing again.

Link: https://lkml.kernel.org/r/ba83d934e59edd431b693607de573eb9ca059309.1774810498.git.cyyzero16@gmail.com
Fixes: ad4ecbcba728 ("[PATCH] delay accounting taskstats interface send tgid once")
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/taskstats.c~taskstats-set-version-in-tgid-exit-notifications
+++ a/kernel/taskstats.c
@@ -649,6 +649,7 @@ void taskstats_exit(struct task_struct *
 		goto err;
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	stats->version = TASKSTATS_VERSION;
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
_

Patches currently in -mm which might be from cyyzero16@gmail.com are


