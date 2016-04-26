From: akpm@linux-foundation.org
Subject: + localmodconfig-fix-parsing-of-help-text.patch added to -mm tree
Date: Tue, 26 Apr 2016 16:21:44 -0700
Message-ID: <571ff808.YmEL4StYjLKt1ISt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbcDZXVp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Apr 2016 19:21:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bpoirier@suse.com, mmarek@suse.cz, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: localmodconfig: fix parsing of "help" text
has been added to the -mm tree.  Its filename is
     localmodconfig-fix-parsing-of-help-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/localmodconfig-fix-parsing-of-help-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/localmodconfig-fix-parsing-of-help-text.patch

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

localmodconfig-fix-parsing-of-kconfig-source-statements.patch
localmodconfig-recognize-more-keywords-that-end-a-menu-entry.patch
localmodconfig-fix-parsing-of-help-text.patch
localmodconfig-add-missing-to-reference-a-variable.patch
localmodconfig-reset-certificate-paths.patch
localmodconfig-fix-whitespace-repeat-count-after-tristate.patch

