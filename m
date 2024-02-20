Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BC738DCC
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 02:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708396101; cv=none; b=JtiMZfAfvjg20BonoEhr25gv7nR1QESLxiIqxVbXvoXtFG7kx8Ci8M2/TeMJsjZKjEhRZWBJsH3nwG8kF5j97gUgV7WGOKsn8aL4macQqhPb9sMcyBDWAJdMAMb6osP5DP7i7GpCK0nPgGLS00KGmhhU75DTBiQhcUMqkHeOPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708396101; c=relaxed/simple;
	bh=+eLJInLsDkPFN06FJOsTaQD/DCh8KWUgNib2s/TqiuU=;
	h=Date:To:From:Subject:Message-Id; b=XW02tWCRPxz1fF6AfplZaXaOCL6gBkfgRP44FINe8TeR1Kk0UbluZOJyOjFBmMcEbGY5yt8iyMAuI0i5B3cOPnNHTp7hj8f4wcfMNJQuoYR0Y4rDtWeF51o43yiOvIH16fVwlZDL57V7hDRn9PgxEFxdd28Lv0g72t7JJakjZKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T8Zuvx4O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T8Zuvx4O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378EDC433C7;
	Tue, 20 Feb 2024 02:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708396101;
	bh=+eLJInLsDkPFN06FJOsTaQD/DCh8KWUgNib2s/TqiuU=;
	h=Date:To:From:Subject:From;
	b=T8Zuvx4Oh+j+Rvz8wZtIB6rjpxDXfCL0W0GT6AtkyQpNCEQvcBL10ToqE8MF7GWRH
	 te0J4G6L2qL01zYs3RLwlEDaHvEX/w0qPKWE7JyGANWTXK1l20rsszG0MBEckZiWTc
	 J6ehEnTIKVWrN0inS+wQMCXbxz28gy1/DQUTq+cM=
Date: Mon, 19 Feb 2024 18:28:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,p.raghav@samsung.com,mcgrof@kernel.org,da.gomez@samsung.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch added to mm-unstable branch
Message-Id: <20240220022821.378EDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_xarray-fix-soft-lockup-for-advanced-api-tests-fix
has been added to the -mm mm-unstable branch.  Its filename is
     test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: test_xarray-fix-soft-lockup-for-advanced-api-tests-fix
Date: Mon Feb 19 06:23:18 PM PST 2024

s/i/loops/, make non-static

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_xarray.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/test_xarray.c~test_xarray-add-tests-for-advanced-multi-index-use-fix-fix
+++ a/lib/test_xarray.c
@@ -728,7 +728,7 @@ static noinline void *test_get_entry(str
 {
 	XA_STATE(xas, xa, index);
 	void *p;
-	static unsigned int i = 0;
+	unsigned int loops = 0;
 
 	rcu_read_lock();
 repeat:
@@ -746,7 +746,7 @@ repeat:
 	 * APIs won't be stupid, proper page cache APIs loop over the proper
 	 * order so when using a larger order we skip shared entries.
 	 */
-	if (++i % XA_CHECK_SCHED == 0)
+	if (++loops % XA_CHECK_SCHED == 0)
 		schedule();
 
 	return p;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro-fix.patch
mm-ptdump-have-ptdump_check_wx-return-bool-fix.patch
test_xarray-add-tests-for-advanced-multi-index-use-fix-fix.patch
mm-compaction-update-the-cc-nr_migratepages-when-allocating-or-freeing-the-freepages-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch
panic-add-option-to-dump-blocked-tasks-in-panic_print-fix.patch

