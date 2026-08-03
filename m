Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7852D23A6
	for <mm-commits@vger.kernel.org>; Mon,  3 Aug 2026 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782984; cv=none; b=Bh19idpvEizGZCOirgz9kYlPuxmuWx7kr9YiPisziGYQqGZ04UktYPfOBymI7CK2/Kh5ADw15xzQ0CcpqiiC2Q5AQAtpZLTJaFBpAft+QY2j89Nsa0v6vkw0FcrIg/LO/uOjgsyixze4HK1aQPOubT/e08waL/Qc6eX1gbFIa50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782984; c=relaxed/simple;
	bh=pgkspal4uPdmaFbDqEjYpI/n5Bdab3ahvG2rOt/CSmE=;
	h=Date:To:From:Subject:Message-Id; b=sevZXGmeTwi5ZfhUg+m9Fet/2GoNZc7/Rri+9x4JsVu0aUwjHVL29P/WQsVx+iB3tqPIP2SDLRE65BFNnzXYnWRftEaBIGcnNkni7rR6x+saK+HM8hTd/mT2MsP3gZQSVMJXp85J2T+W5v+y5w4f+0uiWe7iHiEVY4OuSiRh1e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M6BAGGoa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M6BAGGoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4190E1F000E9;
	Mon,  3 Aug 2026 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785782982;
	bh=6Zg89kL8Y3J1h7dGQE6+8Uwn0bMRfCBwT8IIdj2t4ac=;
	h=Date:To:From:Subject;
	b=M6BAGGoaSVQ0/KzeJNaeFcX1S5NpioPqr0ymV89a4e1pWRxFVmFtOLs4HNQMOf04q
	 Km5rpP1tSJ2FELs46KJsO8sdocstL3NLwVRJkmiEZbRrXxR0e8ca5SN5eDHfXWAhTC
	 a+tIUx4rFTauH2N5nRtVkg/1yTD+0Qlb6IKR+260=
Date: Mon, 03 Aug 2026 11:49:41 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,leitao@debian.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch added to mm-new branch
Message-Id: <20260803184942.4190E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Breno Leitao <leitao@debian.org>
Subject: mm: kmemleak: default min_unref_scans to 2 for verbose auto-scan
Date: Fri, 31 Jul 2026 03:13:04 -0700

Patch series "mm: kmemleak: default min_unref_scans to 2 for verbose
kernels", v2.

When CONFIG_DEBUG_KMEMLEAK_VERBOSE is set, which means the host is in
auto scan mode, set min_unref_scans to 2, avoiding false positives.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it already runs the scan thread periodically and
the user has asked for detailed leak reports.

The confirming second scan comes for free there, so default
min_unref_scans to 2 in that case and keep it at 1 everywhere else.
CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so nothing changes for
kernels that do not opt in.

The other two patches bring the documentation and the selftest comments
in line with the new conditional default.

PS: A similar patch (v1 of this patchset) is applied to Meta's kernel,
in real production hosts.


This patch (of 3):

min_unref_scans defers reporting an object as leaked until it has stayed
unreferenced for that many consecutive scans, filtering out objects that
are only transiently unreferenced during a scan.

It defaults to 1, which reports on the first unreferenced scan.

CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
so a kernel built with it runs the scan thread periodically and the user
has opted into detailed leak reporting.  A second confirming scan then
happens on its own.

Default min_unref_scans to 2 there to suppress transient false positives,
and keep it at 1 otherwise, where a manually triggered scan is expected to
report immediately.  The value stays writable through the module
parameter.

CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so this does not change the
default for kernels that do not opt in.

Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org
Link: https://lore.kernel.org/20260731-kmemleak_hardened-v2-1-7b9689ac77cb@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/kmemleak.c~mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan
+++ a/mm/kmemleak.c
@@ -237,7 +237,8 @@ static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
-static unsigned int min_unref_scans = 1;
+static unsigned int min_unref_scans =
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
_

Patches currently in -mm which might be from leitao@debian.org are

mm-memory-failure-drop-dead-error_states-entry-for-reserved-pages.patch
mm-memory-failure-surface-unhandlable-kernel-pages-as-enotrecoverable.patch
mm-memory-failure-report-mf_msg_kernel-for-unrecoverable-kernel-pages.patch
mm-memory-failure-add-panic-option-for-unrecoverable-pages.patch
documentation-document-panic_on_unrecoverable_memory_failure-sysctl.patch
mm-kmemleak-report-leaks-only-after-n-consecutive-unreferenced-scans.patch
mm-kmemleak-factor-leak-confirmation-into-a-helper.patch
selftests-mm-test-kmemleaks-n-consecutive-scan-leak-confirmation.patch
mm-migrate-report-rcu-tasks-quiescent-states-in-migrate_pages_batch.patch
radix-tree-fix-kmemleak-false-positives-on-tree-head-reassignment.patch
mm-kmemleak-report-rcu-tasks-quiescent-states-during-the-scan.patch
mm-kmemleak-default-min_unref_scans-to-2-for-verbose-auto-scan.patch
documentation-kmemleak-document-the-conditional-min_unref_scans-default.patch
selftests-mm-kmemleak-drop-stale-min_unref_scans-default-from-comments.patch

