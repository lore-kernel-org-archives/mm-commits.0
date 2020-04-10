From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 29/35] selftests: kmod: fix handling test numbers
 above 9
Date: Fri, 10 Apr 2020 14:33:53 -0700
Message-ID: <20200410213353.6PUa-fVba%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVd4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:56 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com, torvalds@linux-foundation.org

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
