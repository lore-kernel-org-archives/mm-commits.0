Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACDD1EA90;
	Thu, 19 Dec 2024 03:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577516; cv=none; b=ZsPmCV3FanrX/Xyh2uKH9KzgWjOT8Xgyka41QMPd2qJsTrJg9bm9iErZ2RVhxA8MVbathMg2M5ItO/71n9K5YGO98qH7Se51/HGeQ/Cm8WScoHxOxzZTH8U/jK2GJd2UdNLrFhapRZA8K1v5ouj4e5HfNxVnU7CBfEEfKEMZVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577516; c=relaxed/simple;
	bh=yOCeGTPFSDVFMS535a9jz95Uit346xOX0ir1pXgt8Ao=;
	h=Date:To:From:Subject:Message-Id; b=L3qbvSW8inp+ChBpHTdaeAVai8qYY2X7hPcJ7zAFjRCOV72CmyG1LDKE3XrWMeQUzpMr7PS46xu6hN+ON6mPLqcbYEt3Qf0dXo/gqH/1d7MJakUUlysPEFPZBbjFq5CXEcIcK7yN61/EWDOslP1gWwJkLoxyXrL+5t/9TyuRYW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=co2vWjnQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="co2vWjnQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2AFC4CECD;
	Thu, 19 Dec 2024 03:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577515;
	bh=yOCeGTPFSDVFMS535a9jz95Uit346xOX0ir1pXgt8Ao=;
	h=Date:To:From:Subject:From;
	b=co2vWjnQATSo/hUtip8NgEWHpIL0r62EzSVAXYN+XjjlCn/W7ARUG+KW+p0rRY6yF
	 Zty79XO92ThZJDreM4EqTjJ+jCv/Cd+D1A948aN2Hu51G4s59dDIUuQzlhve44CPq0
	 Pd5hxq1wL4pkTtENBbcu81aVJwzqQpKM01kkU2ZQ=
Date: Wed, 18 Dec 2024 19:05:14 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,kaleshsingh@google.com,jeffxu@google.com,isaacmanjarres@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-memfd-run-sysctl-tests-when-pid-namespace-support-is-enabled.patch removed from -mm tree
Message-Id: <20241219030515.4E2AFC4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd: run sysctl tests when PID namespace support is enabled
has been removed from the -mm tree.  Its filename was
     selftests-memfd-run-sysctl-tests-when-pid-namespace-support-is-enabled.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: selftests/memfd: run sysctl tests when PID namespace support is enabled
Date: Thu, 5 Dec 2024 11:29:41 -0800

The sysctl tests for vm.memfd_noexec rely on the kernel to support PID
namespaces (i.e.  the kernel is built with CONFIG_PID_NS=y).  If the
kernel the test runs on does not support PID namespaces, the first sysctl
test will fail when attempting to spawn a new thread in a new PID
namespace, abort the test, preventing the remaining tests from being run.

This is not desirable, as not all kernels need PID namespaces, but can
still use the other features provided by memfd.  Therefore, only run the
sysctl tests if the kernel supports PID namespaces.  Otherwise, skip those
tests and emit an informative message to let the user know why the sysctl
tests are not being run.

Link: https://lkml.kernel.org/r/20241205192943.3228757-1-isaacmanjarres@google.com
Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-run-sysctl-tests-when-pid-namespace-support-is-enabled
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <linux/memfd.h>
 #include <sched.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
@@ -1557,6 +1558,11 @@ static void test_share_fork(char *banner
 	close(fd);
 }
 
+static bool pid_ns_supported(void)
+{
+	return access("/proc/self/ns/pid", F_OK) == 0;
+}
+
 int main(int argc, char **argv)
 {
 	pid_t pid;
@@ -1591,8 +1597,12 @@ int main(int argc, char **argv)
 	test_seal_grow();
 	test_seal_resize();
 
-	test_sysctl_simple();
-	test_sysctl_nested();
+	if (pid_ns_supported()) {
+		test_sysctl_simple();
+		test_sysctl_nested();
+	} else {
+		printf("PID namespaces are not supported; skipping sysctl tests\n");
+	}
 
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");
_

Patches currently in -mm which might be from isaacmanjarres@google.com are


