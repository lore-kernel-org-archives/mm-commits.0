From: akpm@linux-foundation.org
Subject: +
 documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch added to -mm tree
Date: Thu, 12 Jun 2014 14:47:01 -0700
Message-ID: <539a1fd5.K5I++eGI9DD2NCqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaFLVrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jun 2014 17:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, rickard_strandqvist@spectrumdigital.se

Subject: + documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch added to -mm tree
To: rickard_strandqvist@spectrumdigital.se,keescook@chromium.org
From: akpm@linux-foundation.org
Date: Thu, 12 Jun 2014 14:47:01 -0700


The patch titled
     Subject: Documentation/accounting/getdelays.c: add missing null-terminate after strncpy call
has been added to the -mm tree.  Its filename is
     documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Documentation/accounting/getdelays.c: add missing null-terminate after strncpy call

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call
+++ a/Documentation/accounting/getdelays.c
@@ -314,6 +314,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'm':
 			strncpy(cpumask, optarg, sizeof(cpumask));
+			cpumask[sizeof(cpumask) - 1] = '\0';
 			maskset = 1;
 			printf("cpumask %s maskset %d\n", cpumask, maskset);
 			break;
_

Patches currently in -mm which might be from rickard_strandqvist@spectrumdigital.se are

origin.patch
documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch
linux-next.patch

