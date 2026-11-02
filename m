Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793591268;
	b=bbXUCUqiixhwJIGPTZbuKoWT0v1NTFrKNwikyfHeWC8Hu31tTqyKSoVPyQokutonHqp3
	 amSXOuYRWAy+qttiIQCuwybxjrTkf3P0zcJwothGk/1/XHcsskW6Khv5Kw0p9CWQyB8v5
	 asK49hg9o9x6gIfBSvCNGFxNvsDFj6WF6t/HFnbAR9VFlYGf9Sx/iHLeuAERGIXnucqlj
	 bW3q/v1zDgH0OEostg6jQpedG4AfoSkaG4cwRewF5CrKSA2z2NO1DcD6xHD1ffapSrmCT
	 B21+LrvdyD2uBYYDrpsDCLRerziAP0CUGC54sCxDfImeUJiyjJ3JIPyihKv4TxAYnTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793591268;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=M1z0xO8J/AgJPddDRpYXpJXqKXwRmFiZmZzR1gQrnro=;
	b=u3Id7UpVs3NROUVzUvctV60Ub5wuX28tA7hl+mw4ep90ctKtunYKRFEhRXCIvBGn8Eo/
	 7SC96jC929HQyu9VgmOp0fzHQDk+5FA06dCqM1yiSaPiUicVf7f3xaZYSn19Xj7dknOUn
	 DEUKMM/M6HvYQd5bk4dOReYtSPPCxU8vk3fYMAmrcAVHz3t/6IjKMfLAfb02VmNVjX4Yx
	 SUhz9nHAdREZUqDhxORlcIM+wf3rDtcnWXHXUIcScrm1RacSH4iUQPeAniHUTot1jJlnL
	 B3SL1pybikC6gI5UMRihZ8vANO2mFrWxLP29itlHCNAGl20Hboq5HVaN2dv4qSlIDKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M7khRa+h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D202606A337
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 03:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=M7khRa+h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7771F00919;
	Mon,  2 Nov 2026 03:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793591261;
	bh=M1z0xO8J/AgJPddDRpYXpJXqKXwRmFiZmZzR1gQrnro=;
	h=Date:To:From:Subject;
	b=M7khRa+hYOcOp59hYj4NQcesBkIeiAb4Ghphf34vBYBY/kY/unfKlOq1PPSb2pA5A
	 aidtyhpkgvpPIoAhu6PKXf7wu+DNSBi7XL3XllU9vL2ETcxyX7RrqY3uys+6Ekui70
	 JO1dRrYhkuqTA7ZEXs+xV3WlLTmA0Rl181dRCHOQ=
Date: Sun, 01 Nov 2026 19:47:41 -0800
To: mm-commits@vger.kernel.org,pizhenwei@bytedance.com,
	nao.horiguchi@gmail.com,mchehab+huawei@kernel.org,linmiaohe@huawei.com,
	m.chehab@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch added to mm-hotfixes-unstable branch
Message-Id: <20261102034741.9E7771F00919@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: memory-failure: update statistics before emitting the trace event
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Mauro Carvalho Chehab <m.chehab@huawei.com>
Subject: mm: memory-failure: update statistics before emitting the trace event
Date: Wed, 28 Oct 2026 09:09:57 +0100

Today's rasdaemon-ci run showed a race condition at the page poison logic
affecting userspace (rasdaemon): action_result() emits a
memory_failure_event before incrementing num_poisoned_pages and updating
the per-node memory failure statistics.

That causes userspace to read /proc/meminfo to detect HardwareCorrupted
trace events to warn if the value exceeds POISON_STAT_THRESHOLD.  This
works most of the cases, but there is a chance that the value not being
updated in time before libtraceevent notification is handled.

Root cause is commit e240ac52f7da ("mm/memory-failure.c: simplify
num_poisoned_pages_inc/dec") which changed the order of updates.

Rasdaemod-ci run up to Oct 27 worked properly, but on today's run, it
failed to get the HardwareCorrupted data from /proc/meminfo because
it was updated only after trigging the hardware error event:
	https://mchehab.github.io/rasdaemon-ci/failures/20261028T035110Z-40629018388/daily/aarch64/consumer-poison-page-stat.html

E.g. it failed to log this:
	rasdaemon: Poison page statistics exceeded threshold: 4 kB (threshold: 0 kB)

This is important for rasdaemon, as the consumer's action monitors a
failed threshold before poisoning pages.  So, if the counter doesn't
update properly, it will end not poisoning pages at the expected
threshold.

Link: https://lore.kernel.org/d472a9a3ccfa8c0359d7d7acabed92c8927d8e47.1793174996.git.mchehab+huawei@kernel.org
Fixes: e240ac52f7da ("mm/memory-failure.c: simplify num_poisoned_pages_inc/dec")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://github.com/mchehab/rasdaemon-ci/actions/runs/40629018388
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-update-statistics-before-emitting-the-trace-event
+++ a/mm/memory-failure.c
@@ -1320,13 +1320,13 @@ static bool panic_on_unrecoverable_mf(en
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
 			 enum mf_result result)
 {
-	trace_memory_failure_event(pfn, type, result);
-
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
 	}
 
+	trace_memory_failure_event(pfn, type, result);
+
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
_

Patches currently in -mm which might be from m.chehab@huawei.com are

mm-memory-failure-update-statistics-before-emitting-the-trace-event.patch

