Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10FAC0015E
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjHKWfV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbjHKWfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:35:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EB31FED
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:35:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7728C60DCE
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04B2C433C8;
        Fri, 11 Aug 2023 22:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691793319;
        bh=VRoYu87/0HySvwj3IJhU30roPq4RYdezq75Fbq6ymGg=;
        h=Date:To:From:Subject:From;
        b=ysmotRSX3KzOyX5+mOHOPTEAtoF7V+MLlX7RK5+of9TO07rufSc6c9UOwZeV1pW8U
         d777ba5Ann0kZC08mgWYSO1zWEdXiXyVGtMg2I+6OQ6Ewi9xlL3SJgyQWqMqyYwNga
         a6SGxGF4q8rBCf59HlMzXMK/reO661Yt7eDI0mhA=
Date:   Fri, 11 Aug 2023 15:35:19 -0700
To:     mm-commits@vger.kernel.org, w@1wt.eu, naresh.kamboju@linaro.org,
        lkft@linaro.org, broonie@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-line-buffer-test-programs-stdout-fix.patch removed from -mm tree
Message-Id: <20230811223519.C04B2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/nolibc/stdio: add setvbuf() to set buffering mode
has been removed from the -mm tree.  Its filename was
     selftests-line-buffer-test-programs-stdout-fix.patch

This patch was dropped because it was folded into selftests-line-buffer-test-programs-stdout.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: tools/nolibc/stdio: add setvbuf() to set buffering mode
Date: Wed, 26 Jul 2023 08:06:55 +0100

Add a minimal implementation of setvbuf(), which error checks the mode
argument (as required by spec) and returns.  Since nolibc never buffers
output, nothing needs to be done.

The kselftest framework recently added a call to setvbuf().  As a result,
any tests that use the kselftest framework and nolibc cause a compiler
error due to missing function.  This provides an urgent fix for the
problem which is preventing arm64 testing on linux-next.

Example:

clang --target=aarch64-linux-gnu -fintegrated-as
-Werror=unknown-warning-option -Werror=ignored-optimization-argument
-Werror=option-ignored -Werror=unused-command-line-argument
--target=aarch64-linux-gnu -fintegrated-as
-fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
-include ../../../../include/nolibc/nolibc.h -I../..\
-static -ffreestanding -Wall za-fork.c
build/kselftest/arm64/fp/za-fork-asm.o
-o build/kselftest/arm64/fp/za-fork
In file included from <built-in>:1:
In file included from ./../../../../include/nolibc/nolibc.h:97:
In file included from ./../../../../include/nolibc/arch.h:25:
./../../../../include/nolibc/arch-aarch64.h:178:35: warning: unknown
attribute 'optimize' ignored [-Wunknown-attributes]
void __attribute__((weak,noreturn,optimize("omit-frame-pointer")))
__no_stack_protector _start(void)
                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from za-fork.c:12:
../../kselftest.h:123:2: error: call to undeclared function 'setvbuf';
ISO C99 and later do not support implicit function declarations
[-Wimplicit-function-declaration]
        setvbuf(stdout, NULL, _IOLBF, 0);
        ^
../../kselftest.h:123:24: error: use of undeclared identifier '_IOLBF'
        setvbuf(stdout, NULL, _IOLBF, 0);
                              ^
1 warning and 2 errors generated.

Link: https://lkml.kernel.org/r/20230726070655.2713530-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Fixes: ecb7fe2cd610 ("selftests: line buffer test program's stdout")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Link: https://lore.kernel.org/linux-kselftest/CA+G9fYus3Z8r2cg3zLv8uH8MRrzLFVWdnor02SNr=rCz+_WGVg@mail.gmail.com/
Reviewed-by: Mark Brown <broonie@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/nolibc/stdio.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/include/nolibc/stdio.h~selftests-line-buffer-test-programs-stdout-fix
+++ a/tools/include/nolibc/stdio.h
@@ -21,6 +21,11 @@
 #define EOF (-1)
 #endif
 
+/* Buffering mode used by setvbuf.  */
+#define _IOFBF 0	/* Fully buffered. */
+#define _IOLBF 1	/* Line buffered. */
+#define _IONBF 2	/* No buffering. */
+
 /* just define FILE as a non-empty type. The value of the pointer gives
  * the FD: FILE=~fd for fd>=0 or NULL for fd<0. This way positive FILE
  * are immediately identified as abnormal entries (i.e. possible copies
@@ -350,6 +355,25 @@ void perror(const char *msg)
 	fprintf(stderr, "%s%serrno=%d\n", (msg && *msg) ? msg : "", (msg && *msg) ? ": " : "", errno);
 }
 
+static __attribute__((unused))
+int setvbuf(FILE *stream, char *buf, int mode, size_t size)
+{
+	/*
+	 * nolibc does not support buffering so this is a nop. Just check mode
+	 * is valid as required by the spec.
+	 */
+	switch (mode) {
+	case _IOFBF:
+	case _IOLBF:
+	case _IONBF:
+		break;
+	default:
+		return EOF;
+	}
+
+	return 0;
+}
+
 /* make sure to include all global symbols */
 #include "nolibc.h"
 
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-line-buffer-test-programs-stdout.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch

