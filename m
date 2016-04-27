From: akpm@linux-foundation.org
Subject: [merged]
 localmodconfig-fix-parsing-of-kconfig-source-statements.patch removed from
 -mm tree
Date: Wed, 27 Apr 2016 12:03:23 -0700
Message-ID: <57210cfb.r+3eLejZMbkUZ83a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbcD0TDY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:03:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, jlee@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: fix parsing of Kconfig "source" statements
has been removed from the -mm tree.  Its filename was
     localmodconfig-fix-parsing-of-kconfig-source-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


