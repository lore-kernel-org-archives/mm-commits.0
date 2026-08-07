Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52E638F658;
	Fri,  7 Aug 2026 02:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068030; cv=none; b=M7b6d9jo6He205taMLU3dsBFbIosvtG8K4BKx0/mrzqyQCi9IqNj2ud7Ap3sc7h8ZiqBCXYVRbKvSdifgk4avZag9v6W3bjxdL00QgPEu1sruCoLrrgIWx6XjsYZ/Uv0x7Xlu7nx+vrCXFMzkLK0r11Ee2esdNYzzFDOChFgJdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068030; c=relaxed/simple;
	bh=KOm4VNiThWjzLlHhz2eVLj9gWw3Kfdd8Nh6ygY+wzUg=;
	h=Date:To:From:Subject:Message-Id; b=Aw40qRhdYugXZUm5S4DQhjHsgiF/eVMSL/zK1ZanGH5CSFEDIAoyiM2FIGT5O3RnLbTreVrTwCTZdf/0UecptkO6SWnFYEzX+xDQn+y1KFajPhz9R9XjFNoNBh95jlu4+Po/tlfw41fNs/KEbwKwBfWHBiZNy802f/CV7mT94KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w49wW6d8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w49wW6d8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B8B1F00A3A;
	Fri,  7 Aug 2026 02:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068016;
	bh=5ifcfBviARGb7X0fvNV1eap+LrE3RWJlUkyrAb6PxC4=;
	h=Date:To:From:Subject;
	b=w49wW6d8wrkfwzsTh6h2W5WNkISl7I4CFnLV+M7TSK5xGfeFxrbKa4T1TWzMy/BPA
	 dB0dm1W0KMUx2NM99YQnEL4Fnm+mwZshHqKZVy1axiLF/7dyIzfp+YYfFHkdQdNFDs
	 E9nCuULdKTa0BzgcOQyymka581JYHbRtReW7aWDY=
Date: Thu, 06 Aug 2026 19:00:16 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,ljs@kernel.org,jackmanb@google.com,david@kernel.org,brendan.jackman@linux.dev,injaeryou@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-on-fault-limit-false-failure-under-sudo-rs.patch removed from -mm tree
Message-Id: <20260807020016.A0B8B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix on-fault-limit false failure under sudo-rs
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-on-fault-limit-false-failure-under-sudo-rs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Injae Ryou <injaeryou@gmail.com>
Subject: selftests/mm: fix on-fault-limit false failure under sudo-rs
Date: Mon, 13 Jul 2026 18:27:00 +0900

run_vmtests.sh runs on-fault-limit as the nobody user via "sudo -u nobody
./on-fault-limit", guarded by a check that nobody can access the binary
("sudo -u nobody ls ./on-fault-limit").

The guard resolves the relative path from the inherited working directory,
which only requires search permission on the test directory itself. 
Classic sudo passes the relative path through to execve() the same way, so
the two agree.  However, sudo-rs (the default sudo implementation since
Ubuntu 25.10) canonicalizes the command to an absolute path before
executing it, which requires search permission on every ancestor
directory.  When the kernel tree lives under a private home directory
(mode 0750, the Ubuntu default for new users since 21.04), the guard
passes but the execution fails with "command not found", and the test is
reported as a false FAIL:

  # running sudo -u nobody ./on-fault-limit
  sudo: './on-fault-limit': command not found
  # [FAIL]

Wrap the command in "sh -c" so that sudo only resolves the shell binary,
and the relative path is resolved by nobody's shell from the inherited
working directory, matching what the guard checks.  This is the only "sudo
-u nobody" invocation in the script; uid, cwd, rlimits (including
RLIMIT_MEMLOCK, which this test exercises) and the exit status are
unchanged through sh.

Verified on Ubuntu 26.04 (sudo-rs 0.2.13): the test now runs and passes
instead of failing.  Verified on Ubuntu 24.04 (sudo 1.9.15p5): behavior is
unchanged.

Link: https://lore.kernel.org/20260713092700.464376-1-injaeryou@gmail.com
Fixes: 5d2146a3354f ("selftests/mm: skip mlock tests if nobody user can't read it")
Signed-off-by: Injae Ryou <injaeryou@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-fix-on-fault-limit-false-failure-under-sudo-rs
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -302,7 +302,7 @@ CATEGORY="compaction" run_test ./compact
 
 if command -v sudo &> /dev/null && sudo -u nobody ls ./on-fault-limit >/dev/null;
 then
-	CATEGORY="mlock" run_test sudo -u nobody ./on-fault-limit
+	CATEGORY="mlock" run_test sudo -u nobody sh -c ./on-fault-limit
 else
 	echo "# SKIP ./on-fault-limit"
 fi
_

Patches currently in -mm which might be from injaeryou@gmail.com are


