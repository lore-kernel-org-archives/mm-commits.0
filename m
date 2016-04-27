From: akpm@linux-foundation.org
Subject: [merged]
 localmodconfig-fix-whitespace-repeat-count-after-tristate.patch removed
 from -mm tree
Date: Wed, 27 Apr 2016 12:03:35 -0700
Message-ID: <57210d07.duMm5gc7vgGVWqDg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbcD0TDg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:03:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: fix whitespace repeat count after "tristate"
has been removed from the -mm tree.  Its filename was
     localmodconfig-fix-whitespace-repeat-count-after-tristate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Benjamin Poirier <bpoirier@suse.com>
Subject: localmodconfig: fix whitespace repeat count after "tristate"

Also recognize standalone "prompt".

Before this patch we incorrectly identified some symbols as not having a
prompt and potentially needing to be selected by something else.

Note that this patch could theoretically change the resulting .config,
causing it to have fewer symbols turned on.  However, given the current
set of Kconfig files, this situation does not occur because the symbols
newly added to %prompts are absent from %selects.

Link: http://lkml.kernel.org/r/1461696998-3953-1-git-send-email-bpoirier@suse.com

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/streamline_config.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/streamline_config.pl~localmodconfig-fix-whitespace-repeat-count-after-tristate scripts/kconfig/streamline_config.pl
--- a/scripts/kconfig/streamline_config.pl~localmodconfig-fix-whitespace-repeat-count-after-tristate
+++ a/scripts/kconfig/streamline_config.pl
@@ -237,7 +237,7 @@ sub read_kconfig {
 	    }
 
 	# configs without prompts must be selected
-	} elsif ($state ne "NONE" && /^\s*tristate\s\S/) {
+	} elsif ($state ne "NONE" && /^\s*(tristate\s+\S|prompt\b)/) {
 	    # note if the config has a prompt
 	    $prompts{$config} = 1;
 
_

Patches currently in -mm which might be from bpoirier@suse.com are


