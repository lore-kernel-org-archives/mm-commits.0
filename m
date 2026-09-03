Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA79342146
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 02:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788401849; cv=none; b=WNNcHd3ILYRO35ZlPmX/z45Vu/pbcDFQBwis1AvKwuTK7gN257nrPl7/uXmvoXkpvq5ajCV4PJwZ86BefiQU4tPAzRuPAVVHcRzDsSHd4cszQ1g3b/fXQMfh7DEJiaE/zCn8lm0IT+JoUQnfDztfvPAniiAE/I9amtFJJsf1SIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788401849; c=relaxed/simple;
	bh=6OMfjr+lKZ3HxtjT+Hx6cRkB7gADvBiKto+bbNgnm7I=;
	h=Date:To:From:Subject:Message-Id; b=Ew4NR0O4OUaqOe65+2XiuPU4mYgZMosQ6zpW5FPBrbcWXaXjDzDNIczRor03wSOfBXq9NjBImmiEY9d80XJT5WuT4wViiSZbNQmH5G8l0oTvU1vnVNx7xu2z1bSbVyhcwa5E3j7MtGVioOvJcP/CttvB018lXgk5cb4J5WmVI6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0KfbJcD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0KfbJcD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB201F00A3A;
	Thu,  3 Sep 2026 02:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788401844;
	bh=ZHERgg+r3sV+NtGPV14KhCuTR/sYXClQp0WT4TLBbDc=;
	h=Date:To:From:Subject;
	b=0KfbJcD8K4aCp5xNpH+NOzpKJpoCAPM0ODIESvl3kjapQVDjnXt28heRNJ4Z6ag0F
	 S0wlk5PIXc5Eu3aCfPnPddEeJgv1l7tHu8nhmF13Tu+CksGB0LhhbxmRuzHWsEh3g/
	 s2SQEE9nprmvxYwhYKtmKSrXTgpRuPbj6f3yl89g=
Date: Wed, 02 Sep 2026 19:17:23 -0700
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,shuah@kernel.org,jlayton@kernel.org,jack@suse.cz,djwong@kernel.org,brauner@kernel.org,disgoel@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-filesystems-fix-missing-and-stale-targets-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20260903021724.2CB201F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/filesystems: fix missing and stale TARGETS entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-filesystems-fix-missing-and-stale-targets-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-filesystems-fix-missing-and-stale-targets-entries.patch

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
From: Disha Goel <disgoel@linux.ibm.com>
Subject: selftests/filesystems: fix missing and stale TARGETS entries
Date: Fri, 3 Jul 2026 20:37:42 +0530

filesystems/eventfd, filesystems/open_tree_ns and filesystems/xattr were
never added to TARGETS when introduced.  filesystems/openat2 was moved
from selftests/openat2/ but the TARGETS entry was never updated, leaving a
stale entry pointing at a directory that no longer exists.

Fix this by adding the four missing subdirectories to TARGETS and
removing the stale openat2 entry.

Link: https://lore.kernel.org/20260703150742.58991-1-disgoel@linux.ibm.com
Fixes: 7c37857fc23a ("selftests: add eventfd selftests")
Fixes: b8f7622aa6e3 ("selftests/open_tree: add OPEN_TREE_NAMESPACE tests")
Fixes: 7e28fef5d4db ("selftests/xattr: path-based AF_UNIX socket xattr tests")
Fixes: fe087927046c ("selftests: move openat2 tests to selftests/filesystems/")
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wen Yang <wenyang.linux@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/Makefile~selftests-filesystems-fix-missing-and-stale-targets-entries
+++ a/tools/testing/selftests/Makefile
@@ -35,8 +35,11 @@ TARGETS += fchmodat2
 TARGETS += filesystems
 TARGETS += filesystems/binderfs
 TARGETS += filesystems/epoll
+TARGETS += filesystems/eventfd
 TARGETS += filesystems/failfs
 TARGETS += filesystems/fat
+TARGETS += filesystems/openat2
+TARGETS += filesystems/open_tree_ns
 TARGETS += filesystems/overlayfs
 TARGETS += filesystems/statmount
 TARGETS += filesystems/mount-notify
@@ -47,6 +50,7 @@ TARGETS += filesystems/empty_mntns
 TARGETS += filesystems/fsmount_ns
 TARGETS += filesystems/fscontext_ns
 TARGETS += filesystems/mntns_cleanup
+TARGETS += filesystems/xattr
 TARGETS += firmware
 TARGETS += fpu
 TARGETS += ftrace
@@ -103,7 +107,6 @@ TARGETS += prctl
 TARGETS += proc
 TARGETS += pstore
 TARGETS += ptrace
-TARGETS += openat2
 TARGETS += rdma
 TARGETS += resctrl
 TARGETS += riscv
_

Patches currently in -mm which might be from disgoel@linux.ibm.com are

selftests-filesystems-fix-missing-and-stale-targets-entries.patch

