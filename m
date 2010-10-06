From: akpm@linux-foundation.org
Subject: + doc-clarify-the-behaviour-of-dirty_ratio-dirty_bytes.patch added to -mm tree
Date: Wed, 06 Oct 2010 15:45:50 -0700
Message-ID: <201010062245.o96MjoDj026727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759416Ab0JFWqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 18:46:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arighi@develer.com, gthelen@google.com, rdunlap@xenotime.net, rientjes@google.com


The patch titled
     doc: clarify the behaviour of dirty_ratio/dirty_bytes
has been added to the -mm tree.  Its filename is
     doc-clarify-the-behaviour-of-dirty_ratio-dirty_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: clarify the behaviour of dirty_ratio/dirty_bytes
From: Andrea Righi <arighi@develer.com>

When dirty_ratio or dirty_bytes is written the other parameter is disabled
and set to 0 (in dirty_bytes_handler() / dirty_ratio_handler()).

We do the same for dirty_background_ratio and dirty_background_bytes.

However, in the sysctl documentation, we say that the counterpart becomes
a function of the old value, that is not correct.

Clarify the documentation reporting the actual behaviour.

Reviewed-by: Greg Thelen <gthelen@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN Documentation/sysctl/vm.txt~doc-clarify-the-behaviour-of-dirty_ratio-dirty_bytes Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~doc-clarify-the-behaviour-of-dirty_ratio-dirty_bytes
+++ a/Documentation/sysctl/vm.txt
@@ -80,8 +80,10 @@ dirty_background_bytes
 Contains the amount of dirty memory at which the pdflush background writeback
 daemon will start writeback.
 
-If dirty_background_bytes is written, dirty_background_ratio becomes a function
-of its value (dirty_background_bytes / the amount of dirtyable system memory).
+Note: dirty_background_bytes is the counterpart of dirty_background_ratio. Only
+one of them may be specified at a time. When one sysctl is written it is
+immediately taken into account to evaluate the dirty memory limits and the
+other appears as 0 when read.
 
 ==============================================================
 
@@ -97,8 +99,10 @@ dirty_bytes
 Contains the amount of dirty memory at which a process generating disk writes
 will itself start writeback.
 
-If dirty_bytes is written, dirty_ratio becomes a function of its value
-(dirty_bytes / the amount of dirtyable system memory).
+Note: dirty_bytes is the counterpart of dirty_ratio. Only one of them may be
+specified at a time. When one sysctl is written it is immediately taken into
+account to evaluate the dirty memory limits and the other appears as 0 when
+read.
 
 Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
 value lower than this limit will be ignored and the old configuration will be
_

Patches currently in -mm which might be from arighi@develer.com are

doc-clarify-the-behaviour-of-dirty_ratio-dirty_bytes.patch

