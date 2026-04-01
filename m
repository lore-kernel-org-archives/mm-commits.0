Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720292C3251;
	Wed,  1 Apr 2026 03:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775012839; cv=none; b=gt3rtaJD3/BiHWutRJIsJabR5rxitlHQJmV68CU1wq5je83tGp6RzjhnB1l2GNDfBCtqNuF+8o/RPj5sfHWIVKQgvI2Tty5EAfVCLc1pVu9q69iPF7XiCxnrsPO/yRTSSLwKZpZ8ivLT6fsSoOVkokFgoXA6Id1uMLfCmZTJNWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775012839; c=relaxed/simple;
	bh=fvsDEoev0ERQdimzNoVbv3lG8LUpb12dHwgPZomcxiI=;
	h=Date:To:From:Subject:Message-Id; b=sJzfUT0NTVkYOxcQIOIlgMPjdeZXEN9TFPfBZdVapLer8yCh4vujBoSCO0D1CjSzMNWHpROiV+m9V7lLN1FnbzZvHTY98nrxeKtcvQxxlDCca5F156YYy848rfCUsuk2x0p0heYlaIvfxV16BcEshV6ONsUVBRmJma5o3LLNV+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TwnpqbYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TwnpqbYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B32C19423;
	Wed,  1 Apr 2026 03:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775012839;
	bh=fvsDEoev0ERQdimzNoVbv3lG8LUpb12dHwgPZomcxiI=;
	h=Date:To:From:Subject:From;
	b=TwnpqbYxrS1d7Vzp9IFvkTwkTJ8b90IGUuJHsOWKAfKkQDpUacnYGciHPEJIQqidY
	 GlDEum79zpf/YW71OKkMdR2LCjCA3nGatJiaehoXt8oIDO42/Q6gWjrcuj64okMCo1
	 LwCDzwG5ukpG4gt9MITsz93yLxrRgPUSiWOK9EMc=
Date: Tue, 31 Mar 2026 20:07:18 -0700
To: mm-commits@vger.kernel.org,wang.yaxin@zte.com.cn,thomas.orgis@uni-hamburg.de,stable@vger.kernel.org,fan.yu9@zte.com.cn,bsingharora@gmail.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-set-version-in-tgid-exit-notifications.patch added to mm-nonmm-unstable branch
Message-Id: <20260401030718.F0B32C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: taskstats: set version in TGID exit notifications
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     taskstats-set-version-in-tgid-exit-notifications.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/taskstats-set-version-in-tgid-exit-notifications.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

taskstats-set-version-in-tgid-exit-notifications.patch
tools-accounting-handle-truncated-taskstats-netlink-messages.patch

