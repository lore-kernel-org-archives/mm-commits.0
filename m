From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
 removed from -mm tree
Date: Mon, 16 Feb 2015 12:17:09 -0800
Message-ID: <54e25045.+MGqOt6qTrN9U2CG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbBPURp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cj@linux.com, dborkman@redhat.com, joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add check for keyword 'boolean' in Kconfig definitions
has been removed from the -mm tree.  Its filename was
     checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
lib-kconfig-use-bool-instead-of-boolean.patch

