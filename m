Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D32277035
	for <mm-commits@vger.kernel.org>; Mon,  2 Mar 2026 18:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772476305; cv=none; b=W2y4OLSaGOkoz5UbfhZRz8xFicvNy86LQGjmDtn26WTrNgkbuBH5TUGphHW46ycT1I7On+jDy8ayS6WTfPaH8UX4XWnFgerdps5o4vy+3+0n6TYOEOSHlFuX/IebuvabbnNJKO4D4ofenNdY0wHDa1jWdWs5EKs8c2PxFWXb5ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772476305; c=relaxed/simple;
	bh=XWQOZ069Xd4hwzkE58I7GefGSEN7SOnLWOGl0W4UQvc=;
	h=Date:To:From:Subject:Message-Id; b=gGqOqGV5TcTtNbx9mDiQSGKk5koT60gH9EOoeSrdB+8uDcZOBrldVdx2rOCSqAyigroxgQgQKdUDMDVLkKHf0XFkGUNorO3bK/ANJKHUheYfyZQ8cnUNBO9Fz39dGe8PVELUmkxokJHoIKu6fC/UTAAamPgw8rM+7u9Aa6xvr5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JNK1o/4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JNK1o/4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AFEC19423;
	Mon,  2 Mar 2026 18:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772476304;
	bh=XWQOZ069Xd4hwzkE58I7GefGSEN7SOnLWOGl0W4UQvc=;
	h=Date:To:From:Subject:From;
	b=JNK1o/4/pHqnNx9ELwmDJHcfkL7+4QCKMfcwFOALJZ0WABggHQ2koFr7hFootbsS5
	 SOlSPYd3tootrv4wzbjHAAKR8pJ6hNSK2GOn5pfQNTJooPLA3zD8HQrN0S3rmrzqTQ
	 CN60WMHyHKUYDVDFTPdW1M2cbpQcHeZu/NTMFWqk=
Date: Mon, 02 Mar 2026 10:31:43 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,brauner@kernel.org,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch removed from -mm tree
Message-Id: <20260302183144.99AFEC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/filesystems: assume that TIOCGPTPEER is defined
has been removed from the -mm tree.  Its filename was
     selftests-filesystems-assume-that-tiocgptpeer-is-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/filesystems: assume that TIOCGPTPEER is defined
Date: Fri, 27 Feb 2026 15:20:35 +0000

The devpts_pts selftest has an ifdef in case an architecture does not
define TIOCGPTPEER, but the handling for this is broken since we need
errno to be set to EINVAL in order to skip the test as we should.  Given
that this ioctl() has been defined since v4.15 we may as well just assume
it's there rather than write handling code which will probably never get
used.

Link: https://lkml.kernel.org/r/20260227-selftests-filesystems-devpts-tiocgptpeer-v3-1-07db4d85d5aa@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/devpts_pts.c |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/testing/selftests/filesystems/devpts_pts.c~selftests-filesystems-assume-that-tiocgptpeer-is-defined
+++ a/tools/testing/selftests/filesystems/devpts_pts.c
@@ -119,9 +119,7 @@ static int do_tiocgptpeer(char *ptmx, ch
 		goto do_cleanup;
 	}
 
-#ifdef TIOCGPTPEER
 	slave = ioctl(master, TIOCGPTPEER, O_RDWR | O_NOCTTY | O_CLOEXEC);
-#endif
 	if (slave < 0) {
 		if (errno == EINVAL) {
 			fprintf(stderr, "TIOCGPTPEER is not supported. "
_

Patches currently in -mm which might be from broonie@kernel.org are

selftests-fchmodat2-clean-up-temporary-files-and-directories.patch
selftests-fchmodat2-use-ksft_finished.patch

