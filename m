From: akpm@linux-foundation.org
Subject: [merged]
 localmodconfig-recognize-more-keywords-that-end-a-menu-entry.patch removed
 from -mm tree
Date: Wed, 27 Apr 2016 12:03:26 -0700
Message-ID: <57210cfe.hXZsel6naJ2R7JbH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbcD0TD1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:03:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: recognize more keywords that end a menu entry
has been removed from the -mm tree.  Its filename was
     localmodconfig-recognize-more-keywords-that-end-a-menu-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: recognize more keywords that end a menu entry

Based on the list in Documentation/kbuild/kconfig-language.txt

This removes junk from %depends because parsing of a menu entry spilled
over to another menu entry.

Link: http://lkml.kernel.org/r/1460333193-16361-1-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-recognize-more-keywords-that-end-a-menu-entry scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-recognize-more-keywords-that-end-a-menu-entry
+++ a/scripts/kconfig/streamline_config.pl
@@ -256,8 +256,8 @@ sub read_kconfig {
 
 	    $iflevel-- if ($iflevel);
 
-	# stop on "help"
-	} elsif (/^\s*help\s*$/) {
+	# stop on "help" and keywords that end a menu entry
+	} elsif (/^\s*help\s*$/ || /^(comment|choice|menu)\b/) {
 	    $state = "NONE";
 	}
     }
_

Patches currently in -mm which might be from bpoirier@suse.com are


