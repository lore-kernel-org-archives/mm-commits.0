From: akpm@linux-foundation.org
Subject: [merged]
 documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:02 -0700
Message-ID: <51db14de.lL1PbNVDktL+E302%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3GHThD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwab@linux-m68k.org, rob@landley.net, keescook@chromium.org

Subject: [merged] documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch removed from -mm tree
To: keescook@chromium.org,rob@landley.net,schwab@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:02 -0700


The patch titled
     Subject: Documentation/accounting/getdelays.c: avoid strncpy in accounting tool
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Documentation/accounting/getdelays.c: avoid strncpy in accounting tool

Avoid strncpy anti-pattern.

[akpm@linux-foundation.org: remove the str[cpy|dup] altogether]
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool
+++ a/Documentation/accounting/getdelays.c
@@ -272,7 +272,7 @@ int main(int argc, char *argv[])
 	char *logfile = NULL;
 	int loop = 0;
 	int containerset = 0;
-	char containerpath[1024];
+	char *containerpath = NULL;
 	int cfd = 0;
 	int forking = 0;
 	sigset_t sigset;
@@ -299,7 +299,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'C':
 			containerset = 1;
-			strncpy(containerpath, optarg, strlen(optarg) + 1);
+			containerpath = optarg;
 			break;
 		case 'w':
 			logfile = strdup(optarg);
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
isdn-clean-up-debug-format-string-usage.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch

