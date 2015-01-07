From: akpm@linux-foundation.org
Subject: +
 checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch added to -mm tree
Date: Wed, 07 Jan 2015 14:13:50 -0800
Message-ID: <54adaf9e.XIYt1CY+vQ3NVq7r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbAGWNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 17:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cj@linux.com, dborkman@redhat.com, joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add check for keyword 'boolean' in Kconfig definitions
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Jaeger <cj@linux.com>
Subject: checkpatch: add check for keyword 'boolean' in Kconfig definitions

Discourage the use of keyword 'boolean' for type definition attributes of
config options as support for it will be dropped later on.

See http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com

Signed-off-by: Christoph Jaeger <cj@linux.com>
Suggested-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Joe Perches <joe@perches.com>
Acked-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions
+++ a/scripts/checkpatch.pl
@@ -2357,6 +2357,13 @@ sub process {
 			     "Use of CONFIG_EXPERIMENTAL is deprecated. For alternatives, see https://lkml.org/lkml/2012/10/23/580\n");
 		}
 
+# discourage the use of boolean for type definition attributes of Kconfig options
+		if ($realfile =~ /Kconfig/ &&
+		    $line =~ /^\+\s*\bboolean\b/) {
+			WARN("CONFIG_TYPE_BOOLEAN",
+			     "Use of boolean is deprecated, please use bool instead.\n" . $herecurr);
+		}
+
 		if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
 		    ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
 			my $flag = $1;
_

Patches currently in -mm which might be from cj@linux.com are

checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
linux-next.patch

