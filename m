From: akpm@linux-foundation.org
Subject: [merged] localmodconfig-add-missing-to-reference-a-variable.patch removed from -mm tree
Date: Wed, 27 Apr 2016 12:03:30 -0700
Message-ID: <57210d02./hZ2gL0JFGwquFng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbcD0TDb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:03:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: Add missing $ to reference a variable
has been removed from the -mm tree.  Its filename was
     localmodconfig-add-missing-to-reference-a-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: Add missing $ to reference a variable

That is clearly what the original intention was.  This does not change the
output .config but it prevents some useless processing.

! eq "m" is changed to the simpler eq "y"; symbols with values other than
m|y are not included in %orig_configs.

Link: http://lkml.kernel.org/r/1460333193-16361-3-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-add-missing-to-reference-a-variable scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-add-missing-to-reference-a-variable
+++ a/scripts/kconfig/streamline_config.pl
@@ -454,7 +454,7 @@ sub parse_config_depends
 	    $p =~ s/^[^$valid]*[$valid]+//;
 
 	    # We only need to process if the depend config is a module
-	    if (!defined($orig_configs{$conf}) || !$orig_configs{conf} eq "m") {
+	    if (!defined($orig_configs{$conf}) || $orig_configs{$conf} eq "y") {
 		next;
 	    }
 
_

Patches currently in -mm which might be from bpoirier@suse.com are


