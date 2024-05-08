Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1825A85925
	for <mm-commits@vger.kernel.org>; Wed,  8 May 2024 17:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715189046; cv=none; b=dLYZ7lQmq8+4edCXJ4yLNBslE/IGzBPnuCP6DOo1r+S2og4/RsNKxGZX0+8cuzR8gTfodggl6reAG01iR5ZKDbBAUcYeC8OP6kHxj+KiwSv1pFv2b290ZV03ypTa7oyJTAGQwZUIdsv+fV3J8FA5q8urWdJit7jwcAQ7YoyLOWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715189046; c=relaxed/simple;
	bh=jnKBtm0Zf2tPvVvHOO98Xd+7McJingHRUggs9zBEJwQ=;
	h=Date:To:From:Subject:Message-Id; b=FTiELq7LSilJ4Su8sXbBaaExlur9jO66smVCzopwee81gCiel8/VpHxAM9ObZEcb1tR2pAIbNY6pXjiRJYMpyh+RjNt5q72z67FAvnrocRe0rHM97OkNg6f+2CkjSHqELhBIvocJ3Buz0jvksw/K28L+LyRlOORhslGLBXNe89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NPx1khz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NPx1khz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D35CC32781;
	Wed,  8 May 2024 17:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715189045;
	bh=jnKBtm0Zf2tPvVvHOO98Xd+7McJingHRUggs9zBEJwQ=;
	h=Date:To:From:Subject:From;
	b=1NPx1khzBi7+2gIEtwfVuRpuJZAlZrlJ7sTPT/UDIi4NV1Z9wuXtmH+/NSWZMcWFD
	 xjakA5bUjBIQUWBXXlLEwA/MfdZpFKXzey+cZ7TNRd4/phvP3kuLxh5iQBD2lDBBLV
	 1ZhWwo2Cqdog9UwpkFojeQGPDp3Eb4qsPAlOo6ME=
Date: Wed, 08 May 2024 10:24:04 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch removed from -mm tree
Message-Id: <20240508172405.8D35CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: try to send SIGBUS even if unmap failed
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: try to send SIGBUS even if unmap failed
Date: Wed, 1 May 2024 17:24:56 -0600

Patch series "Enhance soft hwpoison handling and injection".

This series aim at the following enhancement -

1. Let one hwpoison injector, that is, madvise(MADV_HWPOISON) to behave
   more like as if a real UE occurred. Because the other two injectors
   such as hwpoison-inject and the 'einj' on x86 can't, and it seems to
   me we need a better simulation to real UE scenario.

2. For years, if the kernel is unable to unmap a hwpoisoned page, it send
   a SIGKILL instead of SIGBUS to prevent user process from potentially
   accessing the page again. But in doing so, the user process also lose
   important information: vaddr, for recovery.  Fortunately, the kernel
   already has code to kill process re-accessing a hwpoisoned page, so
   remove the '!unmap_success' check.

3. Right now, if a thp page under GUP longterm pin is hwpoisoned, and
   kernel cannot split the thp page, memory-failure simply ignores
   the UE and returns.  That's not ideal, it could deliver a SIGBUS with
   useful information for userspace recovery.


This patch (of 3):

For years when it comes down to kill a process due to hwpoison, a SIGBUS
is delivered only if unmap has been successful.  Otherwise, a SIGKILL is
delivered.  And the reason for that is to prevent the involved process
from accessing the hwpoisoned page again.

Since then a lot has changed, a hwpoisoned page is marked and upon being
re-accessed, the process will be killed immediately.  So let's take out
the '!unmap_success' factor and try to deliver SIGBUS if possible.

Link: https://lkml.kernel.org/r/20240501232458.3919593-1-jane.chu@oracle.com
Link: https://lkml.kernel.org/r/20240501232458.3919593-2-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed
+++ a/mm/memory-failure.c
@@ -517,19 +517,14 @@ void add_to_kill_ksm(struct task_struct
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs(struct list_head *to_kill, int forcekill, bool fail,
+static void kill_procs(struct list_head *to_kill, int forcekill,
 		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
 
 	list_for_each_entry_safe(tk, next, to_kill, nd) {
 		if (forcekill) {
-			/*
-			 * In case something went wrong with munmapping
-			 * make sure the process doesn't catch the
-			 * signal and then access the memory. Just kill it.
-			 */
-			if (fail || tk->addr == -EFAULT) {
+			if (tk->addr == -EFAULT) {
 				pr_err("%#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,
@@ -1660,7 +1655,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	forcekill = folio_test_dirty(folio) || (flags & MF_MUST_KILL) ||
 		    !unmap_success;
-	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
+	kill_procs(&tokill, forcekill, pfn, flags);
 
 	return unmap_success;
 }
@@ -1724,7 +1719,7 @@ static void unmap_and_kill(struct list_h
 		unmap_mapping_range(mapping, start, size, 0);
 	}
 
-	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
+	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
 }
 
 /*
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

