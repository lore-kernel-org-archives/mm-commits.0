From: akpm@linux-foundation.org
Subject: [merged]
 tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 15:31:52 -0700
Message-ID: <20200608223152.40zzZ_Ol7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgFHWby (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, christian.brauner@ubuntu.com, ebiederm@xmission.com, gpiccoli@canonical.com, gregkh@linuxfoundation.org, ivan.teterevkov@nutanix.com, keescook@chromium.org, mcgrof@kernel.org, mhiramat@kernel.org, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org, yzaikin@google.com


The patch titled
     Subject: tools/testing/selftests/sysctl/sysctl.sh: support CONFIG_TEST_SYSCTL=y
has been removed from the -mm tree.  Its filename was
     tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: tools/testing/selftests/sysctl/sysctl.sh: support CONFIG_TEST_SYSCTL=y

The testing script recommends CONFIG_TEST_SYSCTL=y, but actually only
works with CONFIG_TEST_SYSCTL=m.  Testing of sysctl setting via boot param
however requires the test to be built-in, so make sure the test script
supports it.

Link: http://lkml.kernel.org/r/20200427180433.7029-5-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Guilherme G . Piccoli" <gpiccoli@canonical.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sysctl/sysctl.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/sysctl/sysctl.sh~tools-testing-selftests-sysctl-sysctlsh-support-config_test_sysctl=y
+++ a/tools/testing/selftests/sysctl/sysctl.sh
@@ -122,7 +122,7 @@ test_reqs()
 
 function load_req_mod()
 {
-	if [ ! -d $DIR ]; then
+	if [ ! -d $SYSCTL ]; then
 		if ! modprobe -q -n $TEST_DRIVER; then
 			echo "$0: module $TEST_DRIVER not found [SKIP]"
 			exit $ksft_skip
_

Patches currently in -mm which might be from vbabka@suse.cz are
