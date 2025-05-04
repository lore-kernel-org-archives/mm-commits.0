Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3229A5
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 00:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746318244; cv=none; b=QOrso7KQXID+4LknRhYiTRh6AUxF9bX45i2M3snf5hpV7Zx3TTsNIzPSkqUHA0EgZ2PBaUPYFTgSixZlV7LUUQDccZ2pcZVMRyr3aHDlsO6h9kcD+IFS5rW9g4iEJGryFiVhAZR9DaEVWyCG1+5RRIFYE54hwCEZHl2q9da8ZyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746318244; c=relaxed/simple;
	bh=oPRr9KuzFcq+hDNiVeT76t+JpJBDZD+wHxtpWcHapfE=;
	h=Date:To:From:Subject:Message-Id; b=bIOE1gtBx2Ac9ool3yef/hWPPMugnBvtID3dt7jUfkLa2Jbyx+WZ0IvG/jX/l55CSs+BlZu5CACyEjV548xvy7wRdA8MUiURNxpvpmenPkflcZxwnbtH2AYX/5mz7UqSDR/pnlqN7nz4FFnAkn5mWO5JiHt30gSxg/40aNKmS+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1NGL4Nik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1NGL4Nik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFC1C4CEE3;
	Sun,  4 May 2025 00:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746318243;
	bh=oPRr9KuzFcq+hDNiVeT76t+JpJBDZD+wHxtpWcHapfE=;
	h=Date:To:From:Subject:From;
	b=1NGL4Nik34wkFj3ANHApN1LQfPNvi3UF+ywoSajZ9xzkJL5XLQcrA1tYfbioxndjH
	 gQN/jK5CRexIclbZKeqFjjbV2NiXnBZFtHg554+M1lglp0MjQRbGxr3XP/jUVBOVLI
	 Ig1KyDu0TPiukDj1pWwBKYiVwLYUEaWmyTNkR4V0=
Date: Sat, 03 May 2025 17:24:02 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brauner@kernel.org,chelsyratnawat2001@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-fix-some-typos-in-tools-testing-selftests.patch added to mm-nonmm-unstable branch
Message-Id: <20250504002403.5CFC1C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: fix some typos in tools/testing/selftests
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-fix-some-typos-in-tools-testing-selftests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-fix-some-typos-in-tools-testing-selftests.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: selftests: fix some typos in tools/testing/selftests
Date: Sat, 3 May 2025 14:19:59 -0700

Fix multiple spelling errors:

 - "rougly" -> "roughly"
 - "fielesystems" -> "filesystems"
 - "Can'" -> "Can't"

Link: https://lkml.kernel.org/r/20250503211959.507815-1-chelsyratnawat2001@gmail.com
Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/filesystems/file_stressor.c                      |    2 +-
 tools/testing/selftests/mm/gup_longterm.c                                |    2 +-
 tools/testing/selftests/thermal/intel/power_floor/power_floor_test.c     |    2 +-
 tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/filesystems/file_stressor.c~selftests-fix-some-typos-in-tools-testing-selftests
+++ a/tools/testing/selftests/filesystems/file_stressor.c
@@ -156,7 +156,7 @@ TEST_F_TIMEOUT(file_stressor, slab_types
 			ssize_t nr_read;
 
 			/*
-			 * Concurrently read /proc/<pid>/fd/ which rougly does:
+			 * Concurrently read /proc/<pid>/fd/ which roughly does:
 			 *
 			 * f = fget_task_next(p, &fd);
 			 * if (!f)
--- a/tools/testing/selftests/mm/gup_longterm.c~selftests-fix-some-typos-in-tools-testing-selftests
+++ a/tools/testing/selftests/mm/gup_longterm.c
@@ -158,7 +158,7 @@ static void do_test(int fd, size_t size,
 		/*
 		 * R/O pinning or pinning in a private mapping is always
 		 * expected to work. Otherwise, we expect long-term R/W pinning
-		 * to only succeed for special fielesystems.
+		 * to only succeed for special filesystems.
 		 */
 		should_work = !shared || !rw ||
 			      fs_supports_writable_longterm_pinning(fs_type);
--- a/tools/testing/selftests/thermal/intel/power_floor/power_floor_test.c~selftests-fix-some-typos-in-tools-testing-selftests
+++ a/tools/testing/selftests/thermal/intel/power_floor/power_floor_test.c
@@ -56,7 +56,7 @@ int main(int argc, char **argv)
 	}
 
 	if (write(fd, "1\n", 2) < 0) {
-		perror("Can' enable power floor notifications\n");
+		perror("Can't enable power floor notifications\n");
 		exit(1);
 	}
 
--- a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c~selftests-fix-some-typos-in-tools-testing-selftests
+++ a/tools/testing/selftests/thermal/intel/workload_hint/workload_hint_test.c
@@ -37,7 +37,7 @@ void workload_hint_exit(int signum)
 	}
 
 	if (write(fd, "0\n", 2) < 0) {
-		perror("Can' disable workload hints\n");
+		perror("Can't disable workload hints\n");
 		exit(1);
 	}
 
@@ -99,7 +99,7 @@ int main(int argc, char **argv)
 	}
 
 	if (write(fd, "1\n", 2) < 0) {
-		perror("Can' enable workload hints\n");
+		perror("Can't enable workload hints\n");
 		exit(1);
 	}
 
_

Patches currently in -mm which might be from chelsyratnawat2001@gmail.com are

selftests-fix-some-typos-in-tools-testing-selftests.patch

