From: akpm@linux-foundation.org
Subject: +
 documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
 added to -mm tree
Date: Mon, 10 Jun 2013 14:21:31 -0700
Message-ID: <51b6435b.4fT5r8biYzr+n0ny%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3FJVVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 17:21:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwab@linux-m68k.org, rob@landley.net, keescook@chromium.org

Subject: + documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch added to -mm tree
To: keescook@chromium.org,rob@landley.net,schwab@linux-m68k.org
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 14:21:31 -0700


The patch titled
     Subject: Documentation/accounting/getdelays.c: avoid strncpy in accounting tool
has been added to the -mm tree.  Its filename is
     documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Documentation/accounting/getdelays.c: avoid strncpy in accounting tool

Avoid strncpy anti-pattern.

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
+			containerpath = strdup(optarg);
 			break;
 		case 'w':
 			logfile = strdup(optarg);
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
drivers-mtd-chips-gen_probec-refactor-call-to-request_module.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
clean-up-scary-strncpydst-src-strlensrc-uses-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch

