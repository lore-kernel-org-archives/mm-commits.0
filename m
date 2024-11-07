Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1523E219C9B
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019132; cv=none; b=MNM0awn/GO6OC7sF/Tfe+Ha5lrzR0FMGlTwwkJ20iUM5wtztGf7Nazl8csKTt6o/LIQ4rvoUiwyyuyXdgVOg4BntIAXyfrIicXuJ5wTJeKs1YeDA+joyhVy57PocYIsenNmkatlE7pSzz9FLJFPZ9u4ebO29o4zk+sviKottLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019132; c=relaxed/simple;
	bh=llsQFcKyuN1K+So/LnI7lGu01BTJMf0NJ2aWMV6lnhQ=;
	h=Date:To:From:Subject:Message-Id; b=kBHQT/0Vc3aNKNE0OCLErx3ud/TvOyuB+GjOKI1QHOl5cY4VfAujPjQPifc9LqtSVokOrzVP1qcWkcxmZa7xj1shmDUTu3K2lhtftJ45iEdy5fE/ULfObJkoyjSSyJWakP/OZcxy+cDYq/R2twUD8eW6eKjqY+unlu2hoTOx9nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VVVhyLlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VVVhyLlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80128C4CECC;
	Thu,  7 Nov 2024 22:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019131;
	bh=llsQFcKyuN1K+So/LnI7lGu01BTJMf0NJ2aWMV6lnhQ=;
	h=Date:To:From:Subject:From;
	b=VVVhyLlZLpN18HE7CywhLUeBr5PcAmoO9z22EwMlKuPWCa6HAPFuf+DEbJr1IHnYF
	 pdvF7tVOJqRCYQuB9MGpH1XTXaC4XpU/TGjPJzLS4hyWk8bo4XiblSFph+3GY1F6NH
	 eZKJRe/pjt88KSYEEp5V/NFnBXzI3mRo9V/Ec7QE=
Date: Thu, 07 Nov 2024 14:38:50 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,brendan.higgins@linux.dev,apanyaki@amazon.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch removed from -mm tree
Message-Id: <20241107223851.80128C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/Kconfig: update DBGFS_KUNIT prompt copy for SYSFS_KUNIT
has been removed from the -mm tree.  Its filename was
     mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/Kconfig: update DBGFS_KUNIT prompt copy for SYSFS_KUNIT
Date: Mon, 28 Oct 2024 16:30:57 -0700

CONFIG_DAMON_SYSFS_KUNIT_TEST prompt is copied from that for DAMON debugfs
interface kunit tests, and not correctly updated.  Fix it.

Link: https://lkml.kernel.org/r/20241028233058.283381-6-sj@kernel.org
Fixes: b8ee5575f763 ("mm/damon/sysfs-test: add a unit test for damon_sysfs_set_targets()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Andrew Paniakin <apanyaki@amazon.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-kconfig-update-dbgfs_kunit-prompt-copy-for-sysfs_kunit
+++ a/mm/damon/Kconfig
@@ -60,7 +60,7 @@ config DAMON_SYSFS
 	  the interface for arbitrary data access monitoring.
 
 config DAMON_SYSFS_KUNIT_TEST
-	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
+	bool "Test for damon sysfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_SYSFS && KUNIT=y
 	default KUNIT_ALL_TESTS
 	help
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-recommend-academic-papers-to-read-and-or-cite.patch
maintainers-memory-management-add-document-files-for-mm.patch

