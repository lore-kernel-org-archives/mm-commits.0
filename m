From: akpm@linux-foundation.org
Subject: [merged] selftests-add-tests-for-efivarfs.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:58 -0800
Message-ID: <20130228201758.AE6BC5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:64504 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3B1USA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:18:00 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245586qen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:59 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jk@ozlabs.org, dyoung@redhat.com, lxiang@redhat.com, matt.fleming@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add tests for efivarfs
has been removed from the -mm tree.  Its filename was
     selftests-add-tests-for-efivarfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeremy Kerr <jk@ozlabs.org>
Subject: selftests: add tests for efivarfs

This change adds a few initial efivarfs tests to the
tools/testing/selftests directory.

The open-unlink test is based on code from Lingzhu Xiang.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/Makefile               |    2 
 tools/testing/selftests/efivarfs/Makefile      |   12 +
 tools/testing/selftests/efivarfs/efivarfs.sh   |  119 +++++++++++++++
 tools/testing/selftests/efivarfs/open-unlink.c |   63 +++++++
 4 files changed, 195 insertions(+), 1 deletion(-)

diff -puN tools/testing/selftests/Makefile~selftests-add-tests-for-efivarfs tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~selftests-add-tests-for-efivarfs
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \
diff -puN /dev/null tools/testing/selftests/efivarfs/Makefile
--- /dev/null
+++ a/tools/testing/selftests/efivarfs/Makefile
@@ -0,0 +1,12 @@
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall
+
+test_objs = open-unlink
+
+all: $(test_objs)
+
+run_tests: all
+	@/bin/bash ./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+
+clean:
+	rm -f $(test_objs)
diff -puN /dev/null tools/testing/selftests/efivarfs/efivarfs.sh
--- /dev/null
+++ a/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -0,0 +1,119 @@
+#!/bin/bash
+
+efivarfs_mount=/sys/firmware/efi/efivars
+test_guid=210be57c-9849-4fc7-a635-e6382d1aec27
+
+check_prereqs()
+{
+	local msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	if ! grep -q "^\S\+ $efivarfs_mount efivarfs" /proc/mounts; then
+		echo $msg efivarfs is not mounted on $efivarfs_mount >&2
+		exit 0
+	fi
+}
+
+run_test()
+{
+	local test="$1"
+
+	echo "--------------------"
+	echo "running $test"
+	echo "--------------------"
+
+	if [ "$(type -t $test)" = 'function' ]; then
+		( $test )
+	else
+		( ./$test )
+	fi
+
+	if [ $? -ne 0 ]; then
+		echo "  [FAIL]"
+		rc=1
+	else
+		echo "  [PASS]"
+	fi
+}
+
+test_create()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	if [ $(stat -c %s $file) -ne 5 ]; then
+		echo "$file has invalid size" >&2
+		exit 1
+	fi
+}
+
+test_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	rm $file
+
+	if [ -e $file ]; then
+		echo "$file couldn't be deleted" >&2
+		exit 1
+	fi
+
+}
+
+# test that we can remove a variable by issuing a write with only
+# attributes specified
+test_zero_size_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file does not exist" >&2
+		exit 1
+	fi
+
+	printf "$attrs" > $file
+
+	if [ -e $file ]; then
+		echo "$file should have been deleted" >&2
+		exit 1
+	fi
+}
+
+test_open_unlink()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+	./open-unlink $file
+}
+
+check_prereqs
+
+rc=0
+
+run_test test_create
+run_test test_delete
+run_test test_zero_size_delete
+run_test test_open_unlink
+
+exit $rc
diff -puN /dev/null tools/testing/selftests/efivarfs/open-unlink.c
--- /dev/null
+++ a/tools/testing/selftests/efivarfs/open-unlink.c
@@ -0,0 +1,63 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+int main(int argc, char **argv)
+{
+	const char *path;
+	char buf[5];
+	int fd, rc;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <path>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	path = argv[1];
+
+	/* attributes: EFI_VARIABLE_NON_VOLATILE |
+	 *		EFI_VARIABLE_BOOTSERVICE_ACCESS |
+	 *		EFI_VARIABLE_RUNTIME_ACCESS
+	 */
+	*(uint32_t *)buf = 0x7;
+	buf[4] = 0;
+
+	/* create a test variable */
+	fd = open(path, O_WRONLY | O_CREAT);
+	if (fd < 0) {
+		perror("open(O_WRONLY)");
+		return EXIT_FAILURE;
+	}
+
+	rc = write(fd, buf, sizeof(buf));
+	if (rc != sizeof(buf)) {
+		perror("write");
+		return EXIT_FAILURE;
+	}
+
+	close(fd);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return EXIT_FAILURE;
+	}
+
+	if (unlink(path) < 0) {
+		perror("unlink");
+		return EXIT_FAILURE;
+	}
+
+	rc = read(fd, buf, sizeof(buf));
+	if (rc > 0) {
+		fprintf(stderr, "reading from an unlinked variable "
+				"shouldn't be possible\n");
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
_

Patches currently in -mm which might be from jk@ozlabs.org are

origin.patch

