Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E01A2541
	for <mm-commits@vger.kernel.org>; Thu, 17 Jul 2025 23:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752793951; cv=none; b=DvvOs07ALEcETa1JaBo8tTRNogP3mUq++Zvzu6lMmXDICMBkZBIWOO7YTtLsaTgt2lZAzdpRzKuIhlhVTSn5w4stcuvto5RSUyEC8aQYoON7pTQPFn/gUDvkulbWPjt/Qc5A4wBdjaeFKQPOUntmHMqKEiiglBU+FGskYC7EBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752793951; c=relaxed/simple;
	bh=J+505Vb/dlGxS8WGagW0RAyLt7rbsIOl9JIWSFB7/vU=;
	h=Date:To:From:Subject:Message-Id; b=hAXf4HHRxD4C0LNQrGK0xW0GKXknlcTe/oBa4e1ZJioGNlJKfXYYlxxupyMKBUSap0zMdHSDAcS23IQXAP3TZMUO2NNUYnneUFSjZ4x/XUiWc9061gbfkHe+zhXg/lEuZWWHxL46RAbUxT+Go6YbyCd57MF7EX6c4EuZQMDfhB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K4VwnRHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K4VwnRHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FC1C4CEE3;
	Thu, 17 Jul 2025 23:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752793950;
	bh=J+505Vb/dlGxS8WGagW0RAyLt7rbsIOl9JIWSFB7/vU=;
	h=Date:To:From:Subject:From;
	b=K4VwnRHiwIz+F2gD0tXVmxRhLruhior0rYY0t7g5YWfDT/19YYhCpOrlDuJeJxK8i
	 EEzck0AHXccnGJ/D6GJ+CHDJJPDNGVKNXAyEbVxypsxRHA4qP73uchW9e8fjy7AsUH
	 08TbFtt14AFmEW+K3J/vhv1iH1zVq/N21PbxtXgg=
Date: Thu, 17 Jul 2025 16:12:30 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-update-for-refresh_ms.patch added to mm-new branch
Message-Id: <20250717231230.C6FC1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: update for refresh_ms
has been added to the -mm mm-new branch.  Its filename is
     docs-abi-damon-update-for-refresh_ms.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-update-for-refresh_ms.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: update for refresh_ms
Date: Wed, 16 Jul 2025 22:54:48 -0700

Document the new DAMON sysfs file, refresh_ms, on the ABI document.

Link: https://lkml.kernel.org/r/20250717055448.56976-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-update-for-refresh_ms
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -44,6 +44,13 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Reading this file returns the pid of the kdamond if it is
 		running.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/refresh_ms
+Date:		Jul 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a value to this file sets the time interval for
+		automatic DAMON status file contents update.  Writing '0'
+		disables the update.  Reading this file returns the value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/nr_contexts
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-core-add-cleanup_target-ops-callback-fix-2.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

