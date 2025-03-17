Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24893175D5D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188450; cv=none; b=dgiKmF3m41ay+swSauz98q2WmZCs8mRD0h8H33ONhVqxcCdNRczV9HUGO8XTcpQsNsRjbsAmJnfGT7T12lVxVE2YgZ61RM3N5+Gvei8l1E1VBog9zz7p3Mce0sOOtXldwbT61k3HTFrGmvLJcmMmOfvQmN++FUpnjaHE+srueYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188450; c=relaxed/simple;
	bh=zGQ0YN7Jr9ydc0XwuJW6tt+tUvSTPMmZzYnI1wI+iOE=;
	h=Date:To:From:Subject:Message-Id; b=l6X+W6ZmVBxcV6tQfl7gv6bUZqFgLJiscKGG7uHcNWTUyBgMlaRKUgSTwlmu8xagFW5+YtrLQtOWgwlZOVWhXy9WebteEzIelr9GdriuJDhfZ5ezBRYt9BpdaoEEKNv4SIdnYwaDRKXGc2ygI9kVoNWj8q+G1n5azVvfqhNIA+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OpLm+pkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OpLm+pkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA70C4CEEC;
	Mon, 17 Mar 2025 05:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188450;
	bh=zGQ0YN7Jr9ydc0XwuJW6tt+tUvSTPMmZzYnI1wI+iOE=;
	h=Date:To:From:Subject:From;
	b=OpLm+pkGRa3dwUeA4tzPN2Ky3E0UFGYaJl8oGeFVYHR7shQvjBScUnPm+k3ba9Hrj
	 WtzJIF3v77Thtu0vxbQreEGsmmJRsFZuh5N3+ul8syhuEHtKRZz08iiq/+hw6jgMqj
	 +PZtqTvuvT4O4FuoHZNZer//3VAaMc1LlKNOWJZE=
Date: Sun, 16 Mar 2025 22:14:09 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,mjguzik@gmail.com,lorenzo.stoakes@oracle.com,dev.jain@arm.com,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-mlock-print-error-on-failure.patch removed from -mm tree
Message-Id: <20250317051409.EEA70C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm/mlock: print error on failure
has been removed from the -mm tree.  Its filename was
     selftests-mm-mlock-print-error-on-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: selftests/mm/mlock: print error on failure
Date: Tue, 11 Mar 2025 13:18:23 +0000

It's not really possible to start diagnosing this without knowing the
actual error.

Also update the mlock2 helper to behave like libc would by setting errno
and returning -1.

Link: https://lkml.kernel.org/r/20250311-mm-selftests-v4-12-dec210a658f5@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock-random-test.c |    4 ++--
 tools/testing/selftests/mm/mlock2.h            |    8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/mlock2.h~selftests-mm-mlock-print-error-on-failure
+++ a/tools/testing/selftests/mm/mlock2.h
@@ -6,7 +6,13 @@
 
 static int mlock2_(void *start, size_t len, int flags)
 {
-	return syscall(__NR_mlock2, start, len, flags);
+	int ret = syscall(__NR_mlock2, start, len, flags);
+
+	if (ret) {
+		errno = ret;
+		return -1;
+	}
+	return 0;
 }
 
 static FILE *seek_to_smaps_entry(unsigned long addr)
--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-mlock-print-error-on-failure
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -161,9 +161,9 @@ static void test_mlock_within_limit(char
 				       MLOCK_ONFAULT);
 
 		if (ret)
-			ksft_exit_fail_msg("%s() failure at |%p(%d)| mlock:|%p(%d)|\n",
+			ksft_exit_fail_msg("%s() failure (%s) at |%p(%d)| mlock:|%p(%d)|\n",
 					   is_mlock ? "mlock" : "mlock2",
-					   p, alloc_size,
+					   strerror(errno), p, alloc_size,
 					   p + start_offset, lock_size);
 	}
 
_

Patches currently in -mm which might be from jackmanb@google.com are

scripts-gdb-add-lx_per_cpu_ptr.patch

