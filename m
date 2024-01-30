Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295E038DF9
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706597105; cv=none; b=lepDO9P83Ft/NwB3yUNqfk3Lwp3R/LHEZtf5+/y0WbHA/ZXv7V/zzvndsMcjuOEmDCKcPjvSqorRzNCrOuZPwHewj2ZtP0zS+zh8FaKu/tsHGcjPuf20UD8eqKMUor3BmA0HJYIb+mNOPpADDA51cf8FDSlZX9sgM4iDpGofjaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706597105; c=relaxed/simple;
	bh=HxHMiH2Gujp+7LlZUV65FmvY3r+jhiAXdnQacdgmSeY=;
	h=Date:To:From:Subject:Message-Id; b=Z6ff9duwI+py3/mXfWKrzvMXKhOeF66xBFxE3CT0abHAvrqF7W48Z4BUpTot6q6BRlNEBEJu+y2Yx3RvE73uMK8wGt3Qe6uBiJrguwsXBI4FzjBbXQoTbnF33Y74sTperY0k6F+J0Yv5eyVTi9Nl7Gv/kDw/UUhT3CLGNg3ciJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iWQKKKa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iWQKKKa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA12C433F1;
	Tue, 30 Jan 2024 06:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706597104;
	bh=HxHMiH2Gujp+7LlZUV65FmvY3r+jhiAXdnQacdgmSeY=;
	h=Date:To:From:Subject:From;
	b=iWQKKKa+mUoD/oTsarunkXpHGDZ1qSbdi16Jxri4gufTYdscVMY4hrxmHAIuiooV4
	 WqKF3WzDR15/FqrTViAJfhb0Y52HitN4e3pS5pOJ8iJjHb+BbQw8ZN/NUfU71EoZV0
	 cqfhm2/W27ioFXGpZPGJqHr5mE4Wa1oh+9O82vN8=
Date: Mon, 29 Jan 2024 22:44:52 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch added to mm-unstable branch
Message-Id: <20240130064503.8EA12C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: rename CONFIG_DAMON_DBGFS to DAMON_DBGFS_DEPRECATED
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename CONFIG_DAMON_DBGFS to DAMON_DBGFS_DEPRECATED
Date: Mon, 29 Jan 2024 17:35:41 -0800

DAMON debugfs interface is deprecated.  The fact has documented by commit
5445fcbc4cda ("Docs/admin-guide/mm/damon/usage: add DAMON debugfs
interface deprecation notice").  Commit 620932cd2852 ("mm/damon/dbgfs:
print DAMON debugfs interface deprecation message") further started
printing a warning message when users still use it.  Many people don't
read documentation or kernel log, though.

Make the deprecation harder to be ignored using the approach of commit
eb07c4f39c3e ("mm/slab: rename CONFIG_SLAB to CONFIG_SLAB_DEPRECATED"). 
'make oldconfig' with 'CONFIG_DAMON_DBGFS=y' will get a new prompt with
the explicit deprecation notice on the name.  'make olddefconfig' with
'CONFIG_DAMON_DBGFS=y' will result in not building DAMON debugfs
interface.  If there is a real user of DAMON debugfs interface, they will
complain the change to the builder.

Link: https://lkml.kernel.org/r/20240130013549.89538-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated
+++ a/mm/damon/Kconfig
@@ -71,7 +71,7 @@ config DAMON_SYSFS_KUNIT_TEST
 
 	  If unsure, say N.
 
-config DAMON_DBGFS
+config DAMON_DBGFS_DEPRECATED
 	bool "DAMON debugfs interface (DEPRECATED!)"
 	depends on DAMON_VADDR && DAMON_PADDR && DEBUG_FS
 	help
@@ -84,6 +84,11 @@ config DAMON_DBGFS
 	  (DAMON_SYSFS).  If you depend on this and cannot move, please report
 	  your usecase to damon@lists.linux.dev and linux-mm@kvack.org.
 
+config DAMON_DBGFS
+	bool
+	default y
+	depends on DAMON_DBGFS_DEPRECATED
+
 config DAMON_DBGFS_KUNIT_TEST
 	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_DBGFS && KUNIT=y
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch

