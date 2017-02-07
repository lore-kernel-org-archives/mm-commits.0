From: akpm@linux-foundation.org
Subject: + tests-improve-output-of-sigaltstack-testcase.patch added to -mm tree
Date: Tue, 07 Feb 2017 14:47:27 -0800
Message-ID: <589a4e7f.7V0vmX8V2QkTNGDG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35928 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbdBGWzx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2017 17:55:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stsp@list.ru, luto@kernel.org, mingo@kernel.org, oleg@redhat.com, shuah@kernel.org, stsp@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/testing/selftests/sigaltstack/sas.c: improve output of sigaltstack testcase
has been added to the -mm tree.  Its filename is
     tests-improve-output-of-sigaltstack-testcase.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tests-improve-output-of-sigaltstack-testcase.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tests-improve-output-of-sigaltstack-testcase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stas Sergeev <stsp@list.ru>
Subject: tools/testing/selftests/sigaltstack/sas.c: improve output of sigaltstack testcase

Currently it uses %i for bitmasks, which makes it difficult to properly
decode the values.  Use %x instead.

Link: http://lkml.kernel.org/r/b7b4c45d-2f21-de6c-d1c8-16c8386da27c@list.ru
Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/sigaltstack/sas.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN tools/testing/selftests/sigaltstack/sas.c~tests-improve-output-of-sigaltstack-testcase tools/testing/selftests/sigaltstack/sas.c
--- a/tools/testing/selftests/sigaltstack/sas.c~tests-improve-output-of-sigaltstack-testcase
+++ a/tools/testing/selftests/sigaltstack/sas.c
@@ -57,7 +57,7 @@ void my_usr1(int sig, siginfo_t *si, voi
 		exit(EXIT_FAILURE);
 	}
 	if (stk.ss_flags != SS_DISABLE)
-		printf("[FAIL]\tss_flags=%i, should be SS_DISABLE\n",
+		printf("[FAIL]\tss_flags=%x, should be SS_DISABLE\n",
 				stk.ss_flags);
 	else
 		printf("[OK]\tsigaltstack is disabled in sighandler\n");
@@ -122,7 +122,8 @@ int main(void)
 	if (stk.ss_flags == SS_DISABLE) {
 		printf("[OK]\tInitial sigaltstack state was SS_DISABLE\n");
 	} else {
-		printf("[FAIL]\tInitial sigaltstack state was %i; should have been SS_DISABLE\n", stk.ss_flags);
+		printf("[FAIL]\tInitial sigaltstack state was %x; "
+		       "should have been SS_DISABLE\n", stk.ss_flags);
 		return EXIT_FAILURE;
 	}
 
@@ -165,7 +166,7 @@ int main(void)
 		exit(EXIT_FAILURE);
 	}
 	if (stk.ss_flags != SS_AUTODISARM) {
-		printf("[FAIL]\tss_flags=%i, should be SS_AUTODISARM\n",
+		printf("[FAIL]\tss_flags=%x, should be SS_AUTODISARM\n",
 				stk.ss_flags);
 		exit(EXIT_FAILURE);
 	}
_

Patches currently in -mm which might be from stsp@list.ru are

sigaltstack-support-ss_autodisarm-for-config_compat.patch
tests-improve-output-of-sigaltstack-testcase.patch

