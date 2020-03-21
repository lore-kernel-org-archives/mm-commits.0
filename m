From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-kmod-fix-handling-test-numbers-above-9.patch
 added to -mm tree
Date: Fri, 20 Mar 2020 19:23:08 -0700
Message-ID: <20200321022308.3hxjaRqqN%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgCUCXM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 22:23:12 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com


The patch titled
     Subject: selftests: kmod: fix handling test numbers above 9
has been added to the -mm tree.  Its filename is
     selftests-kmod-fix-handling-test-numbers-above-9.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/selftests-kmod-fix-handling-test-numbers-above-9.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/selftests-kmod-fix-handling-test-numbers-above-9.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: selftests: kmod: fix handling test numbers above 9

get_test_count() and get_test_enabled() were broken for test numbers above
9 due to awk interpreting a field specification like '$0010' as octal
rather than decimal.  Fix it by stripping the leading zeroes.

Link: http://lkml.kernel.org/r/20200318230515.171692-5-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: NeilBrown <neilb@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/kmod/kmod.sh |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/kmod/kmod.sh~selftests-kmod-fix-handling-test-numbers-above-9
+++ a/tools/testing/selftests/kmod/kmod.sh
@@ -505,18 +505,23 @@ function test_num()
 	fi
 }
 
-function get_test_count()
+function get_test_data()
 {
 	test_num $1
-	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	local field_num=$(echo $1 | sed 's/^0*//')
+	echo $ALL_TESTS | awk '{print $'$field_num'}'
+}
+
+function get_test_count()
+{
+	TEST_DATA=$(get_test_data $1)
 	LAST_TWO=${TEST_DATA#*:*}
 	echo ${LAST_TWO%:*}
 }
 
 function get_test_enabled()
 {
-	test_num $1
-	TEST_DATA=$(echo $ALL_TESTS | awk '{print $'$1'}')
+	TEST_DATA=$(get_test_data $1)
 	echo ${TEST_DATA#*:*:}
 }
 
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-fix-handling-test-numbers-above-9.patch
selftests-kmod-test-disabling-module-autoloading.patch
