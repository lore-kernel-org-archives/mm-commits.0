Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A11459E2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293221; cv=none; b=Asr+nhmHOuV3h9lbF+XwM8qAO6KXzRDJ8vjf46esvdIbZVykwYdOMwE96jddpFMrz3k1JkBzkM1qfflGo1OvyyhvaMw81LNNsnfsnZoImr0+J8RN6VHOnILB6rXFYOU3TA0NIz7E5JovcBrLRCgplPSCu4kuoFiRZbg1kvKvDoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293221; c=relaxed/simple;
	bh=zrue7e10ozr9Yxmd0u22QSWJ9Iklt/PevB4ZwwWmvIQ=;
	h=Date:To:From:Subject:Message-Id; b=kxU34SDW5sUeQjmMvqC7UxkPEQrv32Ke0i9+w8G2cp1D6c6qRUtMsUjDoyuz+Ew+bIOVyiXgEBd91w/M6gVsfhxwMNfr77691AXRpfaeBVWtWnGuxlGJjoDaX0sOPDSWNw/osjxro+aaQG+5/+3aXKaYT9CW1w87DNABx1LPuWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZgXAdh/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgXAdh/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F22C32782;
	Tue, 25 Jun 2024 05:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293221;
	bh=zrue7e10ozr9Yxmd0u22QSWJ9Iklt/PevB4ZwwWmvIQ=;
	h=Date:To:From:Subject:From;
	b=ZgXAdh/tsnsh/qtLEkRXi0vzeqma86YsEF93vhA37NDE3m2NXJccO11tGIc5juQ9q
	 04xIPuHs6m/DjeIQkaRM+G+akfjMhhRGKcvWPNwQxvMs2wzSdZN3h+IP41fFzKQEMl
	 fVEkLPA53pNTZHiuYoJMJM5Ng9YfUX7DTVjSeVjI=
Date: Mon, 24 Jun 2024 22:27:00 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,jsiddle@redhat.com,j.granados@samsung.com,cunhuang@tencent.com,leonylgao@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch removed from -mm tree
Message-Id: <20240625052700.E6F22C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hung_task: ignore hung_task_warnings when hung_task_panic is enabled
has been removed from the -mm tree.  Its filename was
     hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yongliang Gao <leonylgao@tencent.com>
Subject: hung_task: ignore hung_task_warnings when hung_task_panic is enabled
Date: Thu, 13 Jun 2024 11:31:59 +0800

If hung_task_panic is enabled, don't consider the value of
hung_task_warnings and display the information of the hung tasks.

In some cases, hung_task_panic might not be initially set up, after
several hung tasks occur, the hung_task_warnings count reaches zero.  If
hung_task_panic is set up later, it may not display any helpful hung task
info in dmesg, only showing messages like:

Kernel panic - not syncing: hung_task: blocked tasks
CPU: 3 PID: 58 Comm: khungtaskd Not tainted 6.10.0-rc3 #19
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
 <TASK>
 panic+0x2f3/0x320
 watchdog+0x2dd/0x510
 ? __pfx_watchdog+0x10/0x10
 kthread+0xe0/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2f/0x40
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Link: https://lkml.kernel.org/r/20240613033159.3446265-1-leonylgao@gmail.com
Signed-off-by: Yongliang Gao <leonylgao@tencent.com>
Reviewed-by: Huang Cun <cunhuang@tencent.com>
Cc: Joel Granados <j.granados@samsung.com>
Cc: John Siddle <jsiddle@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/hung_task.c~hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled
+++ a/kernel/hung_task.c
@@ -127,7 +127,7 @@ static void check_hung_task(struct task_
 	 * Ok, the task did not get scheduled for more than 2 minutes,
 	 * complain:
 	 */
-	if (sysctl_hung_task_warnings) {
+	if (sysctl_hung_task_warnings || hung_task_call_panic) {
 		if (sysctl_hung_task_warnings > 0)
 			sysctl_hung_task_warnings--;
 		pr_err("INFO: task %s:%d blocked for more than %ld seconds.\n",
_

Patches currently in -mm which might be from leonylgao@tencent.com are


