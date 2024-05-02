Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9491415B97C
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663788; cv=none; b=d2z9hNiuPzuoQ1PHkJptcqxHWlel4qxrP4bQKTqQn321yQGTGnC4+HfeXwdtPDiZIHo4MNfAoIRflJjtulsouZ3iHMoUrE66Y9tUCe4fIydpJBUhLgcxKTewzw47kg1UzXr4QiesFGh351o7Qj2LsFcw9LroarFoBoSfVJGdsQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663788; c=relaxed/simple;
	bh=pXSG9EW8vHdNbLayuK405giVkOpEpcArWafL1JJAsH0=;
	h=Date:To:From:Subject:Message-Id; b=u0Lu/TGEBDY+qEiUgGS2xAbtaFt79CitgzwqdvZZea0edMIepugBeB2N5qxPmQ4a3Mr332xEbzO05U5RftRwyH7CXZkHmKMg80N/ZcvwHs8HbDqJ05+zTXBVhb2kc2XMAqYePU3dKyLQFDQ+q7wAUuzTF2bvTurO4MNK53RQGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0q/At/VD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0q/At/VD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA572C113CC;
	Thu,  2 May 2024 15:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663788;
	bh=pXSG9EW8vHdNbLayuK405giVkOpEpcArWafL1JJAsH0=;
	h=Date:To:From:Subject:From;
	b=0q/At/VDDBNkqNkGeNQ14FbWbbPb5dPEhiWNWvLl8vDXODpLP28uJhixVBYtSsGf9
	 /Ta0LgaQ5ArfWEEjvoO08Cktve4gaW/aBLAnU9NlqIfn0hSaGzwvp1x1R3QfJEm351
	 hBBuQ/e0IF+WiiJT8YoR9OtKKJQXaR6j6eseugZA=
Date: Thu, 02 May 2024 08:29:46 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch added to mm-unstable branch
Message-Id: <20240502152947.DA572C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: try to send SIGBUS even if unmap failed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch

This patch will later appear in the mm-unstable branch at
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

mm-memory-failure-try-to-send-sigbus-even-if-unmap-failed.patch
mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch
mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

