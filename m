From: akpm@linux-foundation.org
Subject: +
 tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
 added to -mm tree
Date: Mon, 27 Apr 2020 11:33:59 -0700
Message-ID: <20200427183359._QNabr0nj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0SeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Apr 2020 14:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com


The patch titled
     Subject: tools/testing/selftests/sysctl/sysctl.sh: support CONFIG_TEST_SYSCTL=y
has been added to the -mm tree.  Its filename is
     tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl%3Dy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl%3Dy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: tools/testing/selftests/sysctl/sysctl.sh: support CONFIG_TEST_SYSCTL=y

The testing script recommends CONFIG_TEST_SYSCTL=y, but actually only
works with CONFIG_TEST_SYSCTL=m.  Testing of sysctl setting via boot param
however requires the test to be built-in, so make sure the test script
supports it.

Link: http://lkml.kernel.org/r/20200427180433.7029-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sysctl/sysctl.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/sysctl/sysctl.sh~tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -42,7 +42,7 @@ ALL_TESTS="$ALL_TESTS 0006:50:1:bitmap_0
 
 test_modprobe()
 {
-       if [ ! -d $DIR ]; then
+       if [ ! -d $SYSCTL ]; then
                echo "$0: $DIR not present" >&2
                echo "You must have the following enabled in your kernel:" >&2
                cat $TEST_DIR/config >&2
@@ -122,9 +122,9 @@ test_reqs()
 
 function load_req_mod()
 {
-	if [ ! -d $DIR ]; then
+	if [ ! -d $DIR -a ! -d $SYSCTL ]; then
 		if ! modprobe -q -n $TEST_DRIVER; then
-			echo "$0: module $TEST_DRIVER not found [SKIP]"
+			echo "$0: module $TEST_DRIVER not found and not built-in [SKIP]"
 			exit $ksft_skip
 		fi
 		modprobe $TEST_DRIVER
_

Patches currently in -mm which might be from vbabka@suse.cz are

usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch
mm-dump_page-do-not-crash-with-invalid-mapping-pointer.patch
kernel-sysctl-support-setting-sysctl-parameters-from-kernel-command-line.patch
kernel-sysctl-support-handling-command-line-aliases.patch
kernel-hung_task-convert-hung_task_panic-boot-parameter-to-sysctl.patch
tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
lib-test_sysctl-support-testing-of-sysctl-boot-parameter.patch
