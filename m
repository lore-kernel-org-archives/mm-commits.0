Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481728504F
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126266; cv=none; b=X3NuFseVrAeiolF0HOZ1jtluMy915zCjdnk+layGXy+jE87XcpFKJ5eul54xYIkGdTRt/rup2YX/IdBJl+7DMvnd9WfahOtFJtYyVhLg+kt/NnmI+kjRhFMjNN+z9ndwmTqaYtRU24m6azNVCx+pWIxcvE3Q95V2dlaRbtsvPUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126266; c=relaxed/simple;
	bh=UYEF3LcWP5P23G72T6kkhiYbUXIwc9nUjsZbS4XvIPk=;
	h=Date:To:From:Subject:Message-Id; b=kADT1hAs2H3E8x1ZVPXhyz4hmcMFcVhCTZduFMAtvmO6Qndz/0RvlqE/4l+1+j0f66Xz7LvoH9OYdAT6N2bu5kpeqqZtp13vMAsaBllbak+kp7HEuJnD6++spt+qSeZiydetITNivc7jFPvFZN4SfL/MWjTfUpDZ/wGaKPXca1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zUblIzg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zUblIzg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0F8C4CEE3;
	Thu, 10 Jul 2025 05:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126265;
	bh=UYEF3LcWP5P23G72T6kkhiYbUXIwc9nUjsZbS4XvIPk=;
	h=Date:To:From:Subject:From;
	b=zUblIzg0oVgqU5x2xIRVop11cC2W6hUb9WT3y2Fue+D7uKf5OLIvEofgfK1r9kO9d
	 AZWAjzCCw4raTkZp43fEpimZbftGXTkEitXJH6b4exa8DrKKNEqZ/dlfuua/jit+VP
	 O8Qy3XiR8Dm+pZM7WSL7xWJfmGnPn+xytYPZJW1U=
Date: Wed, 09 Jul 2025 22:44:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,david@redhat.com,broonie@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch removed from -mm tree
Message-Id: <20250710054425.DD0F8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: check for YAMA ptrace_scope configuraiton before modifying it
has been removed from the -mm tree.  Its filename was
     selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark Brown <broonie@kernel.org>
Subject: selftests/mm: check for YAMA ptrace_scope configuraiton before modifying it
Date: Tue, 10 Jun 2025 15:07:44 +0100

When running the memfd_secret test run_vmtests.sh unconditionally tries
to confgiure the YAMA LSM's ptrace_scope configuration, leading to an error
if YAMA is not in the running kernel:

# ./run_vmtests.sh: line 432: /proc/sys/kernel/yama/ptrace_scope: No such file or directory
# # ----------------------
# # running ./memfd_secret
# # ----------------------

Check that this file is present before trying to write to it.

The indentation here is a bit odd, and it doesn't seem great that we
configure but don't restore ptrace_scope.

Link: https://lkml.kernel.org/r/20250610-selftest-mm-enable-yama-v1-1-0097b6713116@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-check-for-yama-ptrace_scope-configuraiton-before-modifying-it
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -429,7 +429,9 @@ CATEGORY="vma_merge" run_test ./merge
 
 if [ -x ./memfd_secret ]
 then
-(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
+	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
+fi
 CATEGORY="memfd_secret" run_test ./memfd_secret
 fi
 
_

Patches currently in -mm which might be from broonie@kernel.org are


