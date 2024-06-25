Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08C913D512
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291574; cv=none; b=ZxvjRLycqBshQyUU6tu1EOBARiCggcCXi4GqV1BB4Xy8B1H2Y+dxI9yEP6ABTsf964EnIekclivYTktguIW03aH70MML7GGo8ye1kDp/qH05b5vVmIxWQyBdUKafhTBn27nIw0Fx9aM2DoR3gczdm2IRxCh/hoz61/HxCEZUY/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291574; c=relaxed/simple;
	bh=IwYr3bb6SJWHN0Qjykz5aIFdheytKAE3l8OOEJhTuis=;
	h=Date:To:From:Subject:Message-Id; b=os2HO/yDYHX4IvbKuHLM2GrQbNdYcxQXB4g7RIP+0bEDJSMDygaYSjscZ1Mrr8NVXOuHFTF21JHo4VHKDOHNs8oqy/m6tt/JqZxcNpBkLNf5U96cxisjxPC7Wvq2vTdp85GKjQN/cEEy9kZws/CF+3ZMNpfJXXmj1WD4OtsLW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NOp7CqV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NOp7CqV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25841C32782;
	Tue, 25 Jun 2024 04:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291574;
	bh=IwYr3bb6SJWHN0Qjykz5aIFdheytKAE3l8OOEJhTuis=;
	h=Date:To:From:Subject:From;
	b=NOp7CqV+zdAYKYr2HWyCRc+ghREjmBmEMRnH3erg0ILLAZp7hrJxvfYlKXrFUmWFb
	 kDil2hOK9iE4avBQXmxPaht4QW0ey+jr0zl8A1gYNcVPUXRbtXLBLvAsdEQfOxDMdv
	 kFJ6NReFJmJkmdJnymX9Pho9dEIOyfZq0dTbGKfg=
Date: Mon, 24 Jun 2024 21:59:33 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,oalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch removed from -mm tree
Message-Id: <20240625045934.25841C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: try to send SIGBUS even if unmap failed
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/memory-failure: try to send SIGBUS even if unmap failed
Date: Fri, 24 May 2024 15:53:02 -0600

Patch series "Enhance soft hwpoison handling and injection", v4.

This series is aimed at the following enhancements:

- Let one hwpoison injector, that is, madvise(MADV_HWPOISON) to behave
  more like as if a real UE occurred.  Because the other two injectors
  such as hwpoison-inject and the 'einj' on x86 can't, and it seems to me
  we need a better simulation to real UE scenario.
- For years, if the kernel is unable to unmap a hwpoisoned page, it send
  a SIGKILL instead of SIGBUS to prevent user process from potentially
  accessing the page again.  But in doing so, the user process also lose
  important information: vaddr, for recovery.  Fortunately, the kernel
  already has code to kill process re-accessing a hwpoisoned page, so
  remove the '!unmap_success' check.
- Right now, if a thp page under GUP longterm pin is hwpoisoned, and
  kernel cannot split the thp page, memory-failure simply ignores the UE
  and returns.  That's not ideal, it could deliver a SIGBUS with useful
  information for userspace recovery.


This patch (of 5):

For years when it comes down to kill a process due to hwpoison, a SIGBUS
is delivered only if unmap has been successful.  Otherwise, a SIGKILL is
delivered.  And the reason for that is to prevent the involved process
from accessing the hwpoisoned page again.

Since then a lot has changed, a hwpoisoned page is marked and upon being
re-accessed, the memory-failure handler invokes kill_accessing_process()
to kill the process immediately.  So let's take out the '!unmap_success'
factor and try to deliver SIGBUS if possible.

Link: https://lkml.kernel.org/r/20240524215306.2705454-1-jane.chu@oracle.com
Link: https://lkml.kernel.org/r/20240524215306.2705454-2-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <oalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed
+++ a/mm/memory-failure.c
@@ -514,22 +514,15 @@ void add_to_kill_ksm(struct task_struct
  *
  * Only do anything when FORCEKILL is set, otherwise just free the
  * list (this is used for clean pages which do not need killing)
- * Also when FAIL is set do a force kill because something went
- * wrong earlier.
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
@@ -1660,7 +1653,7 @@ static bool hwpoison_user_mappings(struc
 	 */
 	forcekill = folio_test_dirty(folio) || (flags & MF_MUST_KILL) ||
 		    !unmap_success;
-	kill_procs(&tokill, forcekill, !unmap_success, pfn, flags);
+	kill_procs(&tokill, forcekill, pfn, flags);
 
 	return unmap_success;
 }
@@ -1724,7 +1717,7 @@ static void unmap_and_kill(struct list_h
 		unmap_mapping_range(mapping, start, size, 0);
 	}
 
-	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
+	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
 }
 
 /*
_

Patches currently in -mm which might be from jane.chu@oracle.com are


