From: akpm@linux-foundation.org
Subject: + memfd_test-make-it-work-on-32-bit-systems.patch added to -mm
 tree
Date: Wed, 03 Sep 2014 15:54:17 -0700
Message-ID: <54079c19.JUsP64Mts4SON5ib%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707AbaICWyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 18:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bobby.prani@gmail.com, dh.herrmann@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/memfd/memfd_test.c: make it work on 32-bit systems
has been added to the -mm tree.  Its filename is
     memfd_test-make-it-work-on-32-bit-systems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memfd_test-make-it-work-on-32-bit-systems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memfd_test-make-it-work-on-32-bit-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pranith Kumar <bobby.prani@gmail.com>
Subject: tools/testing/selftests/memfd/memfd_test.c: make it work on 32-bit systems

This test currently fails on 32-bit systems since we use u64 type to pass
the flags to fcntl.

This commit changes this to use 'unsigned int' type for flags to fcntl
making it work on 32-bit systems.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |   34 ++++++++-----------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff -puN tools/testing/selftests/memfd/memfd_test.c~memfd_test-make-it-work-on-32-bit-systems tools/testing/selftests/memfd/memfd_test.c
--- a/tools/testing/selftests/memfd/memfd_test.c~memfd_test-make-it-work-on-32-bit-systems
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -59,9 +59,9 @@ static void mfd_fail_new(const char *nam
 	}
 }
 
-static __u64 mfd_assert_get_seals(int fd)
+static unsigned int mfd_assert_get_seals(int fd)
 {
-	long r;
+	int r;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0) {
@@ -69,50 +69,48 @@ static __u64 mfd_assert_get_seals(int fd
 		abort();
 	}
 
-	return r;
+	return (unsigned int)r;
 }
 
-static void mfd_assert_has_seals(int fd, __u64 seals)
+static void mfd_assert_has_seals(int fd, unsigned int seals)
 {
-	__u64 s;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	if (s != seals) {
-		printf("%llu != %llu = GET_SEALS(%d)\n",
-		       (unsigned long long)seals, (unsigned long long)s, fd);
+		printf("%u != %u = GET_SEALS(%d)\n", seals, s, fd);
 		abort();
 	}
 }
 
-static void mfd_assert_add_seals(int fd, __u64 seals)
+static void mfd_assert_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	s = mfd_assert_get_seals(fd);
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r < 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) failed: %m\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) failed: %m\n", fd, s, seals);
 		abort();
 	}
 }
 
-static void mfd_fail_add_seals(int fd, __u64 seals)
+static void mfd_fail_add_seals(int fd, unsigned int seals)
 {
-	long r;
-	__u64 s;
+	int r;
+	unsigned int s;
 
 	r = fcntl(fd, F_GET_SEALS);
 	if (r < 0)
 		s = 0;
 	else
-		s = r;
+		s = (unsigned int)r;
 
 	r = fcntl(fd, F_ADD_SEALS, seals);
 	if (r >= 0) {
-		printf("ADD_SEALS(%d, %llu -> %llu) didn't fail as expected\n",
-		       fd, (unsigned long long)s, (unsigned long long)seals);
+		printf("ADD_SEALS(%d, %u -> %u) didn't fail as expected\n",
+				fd, s, seals);
 		abort();
 	}
 }
_

Patches currently in -mm which might be from bobby.prani@gmail.com are

memfd_test-make-it-work-on-32-bit-systems.patch
linux-next.patch

