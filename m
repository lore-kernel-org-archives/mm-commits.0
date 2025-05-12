Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F182D1A76D4
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011386; cv=none; b=rdhnUFxx48ywAlkrvj9V+v8TwdkFTw8eTX66U6xPTFZGGT+p4/HDAjteccM4+JjQPCTS5Uvhx9RQZ65Mn7r4QcX+2o5TDbLlXEdbYdN6kl8+5MD3xYihHIsR+EmggTbFkYLRCFlroWHm/u3IwK1CMn+s5nfjOOCPai19Nk8O0VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011386; c=relaxed/simple;
	bh=1xJ14uD58wSXsqhDOWg6sCH1iSPZwvaIGPedUeMfoSc=;
	h=Date:To:From:Subject:Message-Id; b=sDC1nh5bira5T35OQZ0aS3HrQKdcWvoy5OCr3qzGgHgOTHBUzX8bnDt1osdPzPQgYKMJ3iOd7VJKxSvGba69Yg8UYWxuJesoUHu5VJX+hH7iXI+kTSH1gvmgV/5z3y0dFajK74U+05NdAiYfczIRnbniQnsfA20y8Ufas8zOW2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MgUdRdkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MgUdRdkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C6EC4CEE4;
	Mon, 12 May 2025 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011385;
	bh=1xJ14uD58wSXsqhDOWg6sCH1iSPZwvaIGPedUeMfoSc=;
	h=Date:To:From:Subject:From;
	b=MgUdRdkE3mX/SXGe6hE1iQhaldzndGU3tzzj/eB3CeeHngkKK4Nxuxy5t3bpvZXis
	 xhS6EnPYY2xM5ThztMhM4E/IL70lWyefGPxsphLduZQ1cIbbpZ+XAHfeyZkRJZq7kA
	 pEMrlcRPHaziFKKzVbQ0FoOYw+Q6Geg+oQPDTty0=
Date: Sun, 11 May 2025 17:56:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brauner@kernel.org,chelsyratnawat2001@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] selftests-fix-some-typos-in-tools-testing-selftests.patch removed from -mm tree
Message-Id: <20250512005625.C5C6EC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: fix some typos in tools/testing/selftests
has been removed from the -mm tree.  Its filename was
     selftests-fix-some-typos-in-tools-testing-selftests.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


