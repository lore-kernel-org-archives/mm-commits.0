From: akpm@linux-foundation.org
Subject: [merged] localmodconfig-fix-parsing-of-help-text.patch removed
 from -mm tree
Date: Wed, 27 Apr 2016 12:03:28 -0700
Message-ID: <57210d00.yQDIMec2CfjggyN2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbcD0TD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: fix parsing of "help" text
has been removed from the -mm tree.  Its filename was
     localmodconfig-fix-parsing-of-help-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: fix parsing of "help" text

Help text may start with "help" or "---help---".  This patch fixes
read_kconfig() to recognize the second variant.

This removes useless junk from %depends and %selects.  That junk is due to
help text that contains the words "selects" and "depends".

Link: http://lkml.kernel.org/r/1460333193-16361-2-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-fix-parsing-of-help-text scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-fix-parsing-of-help-text
+++ a/scripts/kconfig/streamline_config.pl
@@ -257,7 +257,7 @@ sub read_kconfig {
 	    $iflevel-- if ($iflevel);
 
 	# stop on "help" and keywords that end a menu entry
-	} elsif (/^\s*help\s*$/ || /^(comment|choice|menu)\b/) {
+	} elsif (/^\s*(---)?help(---)?\s*$/ || /^(comment|choice|menu)\b/) {
 	    $state = "NONE";
 	}
     }
_

Patches currently in -mm which might be from bpoirier@suse.com are


