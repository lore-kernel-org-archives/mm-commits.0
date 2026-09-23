Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F72419FC9
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 19:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790191097; cv=none; b=W4iyEEMLBv4hA+cS3gOWaozfnRtltUDRmkiiuLvef/8fQ13W+DfLfHRsi/74YfpthiunrByg0q5Bsw8La0+/weyaAMSyUzepjdPF3/tybf4DshOKhgTJKfWto9oboTQBlAQTK3Sut8wQWkHTNH9VTBBFzEMQvUpVVX11JvQEBEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790191097; c=relaxed/simple;
	bh=nYn3WtEEFuUQv+6Bm1dULXwalSTsl2eK9nXD55dezGE=;
	h=Date:To:From:Subject:Message-Id; b=FO5qNfe/cuP4UJQe8of7Wegbu731EOfO+iTNs5p3FzAZltV+LoqHf8+8pfTWi4jm2sJBcawZNPm6sDoeABNRc6+9yTQ1q5J+qR1KR7lJtMz3iwiMQ5YSUSzWbrZ9JwWBIQMYCTxnCG3hdNySV0+pO0iIBlXJsqvwjrDKe5veH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NLZEw5bX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NLZEw5bX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FB01F000FF;
	Wed, 23 Sep 2026 19:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790191095;
	bh=AGZWwqV6GnFmVQ+4Vv6QK3l5RiwsNqZcN46LLEWkBWY=;
	h=Date:To:From:Subject;
	b=NLZEw5bXFQR0esK8DomXLvOp8F2sBA/zUL27Ru0Ftei3aHhWitaZdb6aWm/5RgSOt
	 +lT0aTU8wuTXOOfivX0AMW63WF1HXWI+RtbWfqhrWQSf1vJ3znF3iRUNAzC89zqC9O
	 K884rNZeuqDQieUMEn3/CKhMEzJC20z/EUqtKlCU=
Date: Wed, 23 Sep 2026 12:18:14 -0700
To: mm-commits@vger.kernel.org,wenyang.linux@foxmail.com,shuah@kernel.org,jlayton@kernel.org,jack@suse.cz,djwong@kernel.org,brauner@kernel.org,disgoel@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] selftests-filesystems-fix-missing-and-stale-targets-entries.patch removed from -mm tree
Message-Id: <20260923191815.13FB01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/filesystems: fix missing and stale TARGETS entries
has been removed from the -mm tree.  Its filename was
     selftests-filesystems-fix-missing-and-stale-targets-entries.patch

This patch was dropped because it is obsolete

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Wen Yang <wenyang.linux@foxmail.com>
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


