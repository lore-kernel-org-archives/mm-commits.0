From: akpm@linux-foundation.org
Subject: + localmodconfig-fix-parsing-of-kconfig-source-statements.patch
 added to -mm tree
Date: Tue, 26 Apr 2016 16:21:40 -0700
Message-ID: <571ff804.7yRFA6F14JkTSewq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbcDZXVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 19:21:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, jlee@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: fix parsing of Kconfig "source" statements
has been added to the -mm tree.  Its filename is
     localmodconfig-fix-parsing-of-kconfig-source-statements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/localmodconfig-fix-parsing-of-kconfig-source-statements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/localmodconfig-fix-parsing-of-kconfig-source-statements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: fix parsing of Kconfig "source" statements

The parameter of Kconfig "source" statements does not need to be quoted. 
The current regex causes many kconfig files to be skipped and hence,
dependencies to be missed.

Also fix the whitespace repeat count.

Link: http://lkml.kernel.org/r/1459619722-13695-1-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-fix-parsing-of-kconfig-source-statements scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-fix-parsing-of-kconfig-source-statements
+++ a/scripts/kconfig/streamline_config.pl
@@ -188,7 +188,7 @@ sub read_kconfig {
 	$cont = 0;
 
 	# collect any Kconfig sources
-	if (/^source\s*"(.*)"/) {
+	if (/^source\s+"?([^"]+)/) {
 	    my $kconfig = $1;
 	    # prevent reading twice.
 	    if (!defined($read_kconfigs{$kconfig})) {
_

Patches currently in -mm which might be from bpoirier@suse.com are

localmodconfig-fix-parsing-of-kconfig-source-statements.patch
localmodconfig-recognize-more-keywords-that-end-a-menu-entry.patch
localmodconfig-fix-parsing-of-help-text.patch
localmodconfig-add-missing-to-reference-a-variable.patch
localmodconfig-reset-certificate-paths.patch
localmodconfig-fix-whitespace-repeat-count-after-tristate.patch

