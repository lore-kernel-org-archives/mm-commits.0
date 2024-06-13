Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1D313B5B6
	for <mm-commits@vger.kernel.org>; Thu, 13 Jun 2024 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312572; cv=none; b=oKx/BaLhuBKqTv96H5gc6y3oZlzCVZWdbir3LuA73yDePjQ9AfqSBwBS6BX5XNd5Ns4uvGx+UxErnUFLCUqEhJ3k9828GzV9ZHlYscyhCSv9Kf1Cv3p21B91Jo5L2qZ7hN0tZ8JbXDF2mRniAuurF5+FhsEiP5XqTyDiiZsFX28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312572; c=relaxed/simple;
	bh=UkwwpQqXmRCfzVnKU9U8sk90YrbWezyeZf5551/bQn0=;
	h=Date:To:From:Subject:Message-Id; b=lDvSFRNCdXu2SJaz2738hBkDHFcz/CIs7FO2dhqHRBqbcEoHU3JvAZHp3fZu15jHf8iErebK4bM7/ITmYjwGwYRdoDtE3oGchs3DZRhfc26it+SNHt/xLlNGoX1VSVXNiHVom17CVsxSi5g+IDZGkR2HcLCT5ythUv3KjK/1qe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IdfJROcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IdfJROcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76968C2BBFC;
	Thu, 13 Jun 2024 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718312571;
	bh=UkwwpQqXmRCfzVnKU9U8sk90YrbWezyeZf5551/bQn0=;
	h=Date:To:From:Subject:From;
	b=IdfJROcUKHOyE1ceSILBeZGgv9r/F8kIOAWT5CXbLhxmfgAP9WHf1TtZAv+3ec/y5
	 FUbgmvtwQEUhnWLyAr0OVfoF7ya12uuWozjHavAtoQBXUgFBDAKU+rr3FXqmNnMeZ4
	 rt1EBhOuhk4wVBdpd1Ih/uVdvutA7QqWgQd58oxw=
Date: Thu, 13 Jun 2024 14:02:50 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,jsiddle@redhat.com,j.granados@samsung.com,cunhuang@tencent.com,leonylgao@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch added to mm-nonmm-unstable branch
Message-Id: <20240613210251.76968C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hung_task: ignore hung_task_warnings when hung_task_panic is enabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch

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

hung_task-ignore-hung_task_warnings-when-hung_task_panic-is-enabled.patch

