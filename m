From: akpm@linux-foundation.org
Subject: + selftests-efivarfs-add-create-read-test.patch added to -mm tree
Date: Thu, 07 Feb 2013 15:14:59 -0800
Message-ID: <20130207231500.A7CEB1E407C@corp2gmr1-2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:59179 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425Ab3BGXPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 18:15:03 -0500
Received: by mail-lb0-f202.google.com with SMTP id c1so226973lbg.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 15:15:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jk@ozlabs.org, dyoung@redhat.com, lxiang@redhat.com, matt.fleming@intel.com


The patch titled
     Subject: selftests/efivarfs: add create-read test
has been added to the -mm tree.  Its filename is
     selftests-efivarfs-add-create-read-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeremy Kerr <jk@ozlabs.org>
Subject: selftests/efivarfs: add create-read test

Test that reads from a newly-created efivarfs file (with no data written)
will return EOF.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/efivarfs/Makefile      |    2 
 tools/testing/selftests/efivarfs/create-read.c |   38 +++++++++++++++
 tools/testing/selftests/efivarfs/efivarfs.sh   |    7 ++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/efivarfs/Makefile~selftests-efivarfs-add-create-read-test tools/testing/selftests/efivarfs/Makefile
--- a/tools/testing/selftests/efivarfs/Makefile~selftests-efivarfs-add-create-read-test
+++ a/tools/testing/selftests/efivarfs/Makefile
@@ -1,7 +1,7 @@
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
 
-test_objs = open-unlink
+test_objs = open-unlink create-read
 
 all: $(test_objs)
 
diff -puN /dev/null tools/testing/selftests/efivarfs/create-read.c
--- /dev/null
+++ a/tools/testing/selftests/efivarfs/create-read.c
@@ -0,0 +1,38 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <string.h>
+
+int main(int argc, char **argv)
+{
+	const char *path;
+	char buf[4];
+	int fd, rc;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <path>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	path = argv[1];
+
+	/* create a test variable */
+	fd = open(path, O_RDWR | O_CREAT, 0600);
+	if (fd < 0) {
+		perror("open(O_WRONLY)");
+		return EXIT_FAILURE;
+	}
+
+	rc = read(fd, buf, sizeof(buf));
+	if (rc != 0) {
+		fprintf(stderr, "Reading a new var should return EOF\n");
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
diff -puN tools/testing/selftests/efivarfs/efivarfs.sh~selftests-efivarfs-add-create-read-test tools/testing/selftests/efivarfs/efivarfs.sh
--- a/tools/testing/selftests/efivarfs/efivarfs.sh~selftests-efivarfs-add-create-read-test
+++ a/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -70,6 +70,12 @@ test_create_empty()
 	fi
 }
 
+test_create_read()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+	./create-read $file
+}
+
 test_delete()
 {
 	local attrs='\x07\x00\x00\x00'
@@ -125,6 +131,7 @@ rc=0
 
 run_test test_create
 run_test test_create_empty
+run_test test_create_read
 run_test test_delete
 run_test test_zero_size_delete
 run_test test_open_unlink
_

Patches currently in -mm which might be from jk@ozlabs.org are

selftests-add-tests-for-efivarfs.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-efivarfs-add-empty-file-creation-test.patch
selftests-efivarfs-add-create-read-test.patch

