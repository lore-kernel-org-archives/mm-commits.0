Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C272D29C2
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754970617; cv=none; b=s3gCStp0OmPCA7IL9cn/oqOXbl+bIZJomBFkryh1/WgzgVcH5M8W/6cJSPwG/JqirNTJ+UBUBwkBoDJEYrxlOaoRsySkG5vvr6Hqrb67fFokvry9fkBEZE/dm4NKETGj9OCiWfG59sWsgn9ORsTwCEsiNtXC42c1eHoWNvS6DX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754970617; c=relaxed/simple;
	bh=uW+HpQlx6xvmamoFeyJU1cnZyiGOT7k+bbHRL60VGjI=;
	h=Date:To:From:Subject:Message-Id; b=JsI5DnCGV+aG64gP/kr8K0VE9UHTA2bQsO7C0IHM03ZocvERZt+slD9wuRX2lQpkU4odIsUSoze+6Dl8GIa5O1yBvBPJGRf6yiKhHB/w0GpPI3GxuE8p7HZa3N+tJycSpqULSe3SHrIEkIvar98n0MUAR22e0ScQUCutbF/UZ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YGOevB57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YGOevB57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829E0C4CEF0;
	Tue, 12 Aug 2025 03:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754970616;
	bh=uW+HpQlx6xvmamoFeyJU1cnZyiGOT7k+bbHRL60VGjI=;
	h=Date:To:From:Subject:From;
	b=YGOevB57Pzb88dLqciRpmP00zC0DUo2SCWVTALnNgVoH8jNZC2ZGsqmpzxtLOb45a
	 FbKS6E6pN8iYnZR6LVnT1PJSwLxmt3/g4MWEU9TPJlhmCBkuZw8n1j3txJgsegmjWj
	 06tR1RFS42u2wxRQjS9kkI69yRLZaUIHhnPf9VC4=
Date: Mon, 11 Aug 2025 20:50:15 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,linux@weissschuh.net,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftest-kho-update-generation-of-initrd.patch added to mm-new branch
Message-Id: <20250812035016.829E0C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftest/kho: update generation of initrd
has been added to the -mm mm-new branch.  Its filename is
     selftest-kho-update-generation-of-initrd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftest-kho-update-generation-of-initrd.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftest/kho: update generation of initrd
Date: Mon, 11 Aug 2025 11:25:10 +0300

Use nolibc include directory rather than include a cumulative nolibc.h on
the compiler command line and replace use of 'sudo cpio' with
usr/gen_init_cpio.

While on it fix spelling of KHO_FINALIZE

Link: https://lkml.kernel.org/r/20250811082510.4154080-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kho/init.c    |   13 +++--------
 tools/testing/selftests/kho/vmtest.sh |   28 ++++++++++++------------
 2 files changed, 19 insertions(+), 22 deletions(-)

--- a/tools/testing/selftests/kho/init.c~selftest-kho-update-generation-of-initrd
+++ a/tools/testing/selftests/kho/init.c
@@ -1,22 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#ifndef NOLIBC
-#include <errno.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <syscall.h>
+#include <sys/syscall.h>
 #include <sys/mount.h>
 #include <sys/reboot.h>
-#endif
+#include <linux/kexec.h>
 
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-/* from include/linux/kexex.h */
-#define KEXEC_FILE_NO_INITRAMFS	0x00000004
-
-#define KHO_FINILIZE "/debugfs/kho/out/finalize"
+#define KHO_FINALIZE "/debugfs/kho/out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
@@ -32,7 +27,7 @@ static int kho_enable(void)
 	const char enable[] = "1";
 	int fd;
 
-	fd = open(KHO_FINILIZE, O_RDWR);
+	fd = open(KHO_FINALIZE, O_RDWR);
 	if (fd < 0)
 		return -1;
 
--- a/tools/testing/selftests/kho/vmtest.sh~selftest-kho-update-generation-of-initrd
+++ a/tools/testing/selftests/kho/vmtest.sh
@@ -10,7 +10,6 @@ kernel_dir=$(realpath "$test_dir/../../.
 
 tmp_dir=$(mktemp -d /tmp/kho-test.XXXXXXXX)
 headers_dir="$tmp_dir/usr"
-initrd_dir="$tmp_dir/initrd"
 initrd="$tmp_dir/initrd.cpio"
 
 source "$test_dir/../kselftest/ktap_helpers.sh"
@@ -81,19 +80,22 @@ EOF
 function mkinitrd() {
 	local kernel=$1
 
-	mkdir -p "$initrd_dir"/{dev,debugfs,proc}
-	sudo mknod "$initrd_dir/dev/console" c 5 1
+	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
+			-fno-asynchronous-unwind-tables -fno-ident \
+			-I "$headers_dir/include" \
+			-I "$kernel_dir/tools/include/nolibc" \
+			-o "$tmp_dir/init" "$test_dir/init.c"
+
+	cat > "$tmp_dir/cpio_list" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $tmp_dir/init 0755 0 0
+file /kernel $kernel 0644 0 0
+EOF
 
-	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -I"$headers_dir/include" \
-			-fno-asynchronous-unwind-tables -fno-ident -nostdlib \
-			-include "$test_dir/../../../include/nolibc/nolibc.h" \
-			-o "$initrd_dir/init" "$test_dir/init.c" \
-
-	cp "$kernel" "$initrd_dir/kernel"
-
-	pushd "$initrd_dir" &>/dev/null
-	find . | cpio -H newc --create > "$initrd" 2>/dev/null
-	popd &>/dev/null
+	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
 }
 
 function run_qemu() {
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

