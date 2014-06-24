From: akpm@linux-foundation.org
Subject: [merged]
 documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:29 -0700
Message-ID: <53a9cb45.WnRk1b2qBrr+IyiG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaFXTC3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/accounting/getdelays.c: add missing null-terminate after strncpy call
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-cleaning-up-missing-null-terminate-after-strncpy-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch

