From: akpm@linux-foundation.org
Subject: + documentation-submittingpatches-describe-the-fixes-tag.patch
 added to -mm tree
Date: Wed, 09 Apr 2014 14:51:58 -0700
Message-ID: <5345c0fe.N3rcHIrncMtlUgLM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933908AbaDIVv7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 17:51:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, jeffrey.t.kirsher@intel.com, aaron.f.brown@intel.com, jacob.e.keller@intel.com

Subject: + documentation-submittingpatches-describe-the-fixes-tag.patch added to -mm tree
To: jacob.e.keller@intel.com,aaron.f.brown@intel.com,jeffrey.t.kirsher@intel.com,rdunlap@infradead.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 14:51:58 -0700


The patch titled
     Subject: Documentation/SubmittingPatches: describe the Fixes: tag
has been added to the -mm tree.  Its filename is
     documentation-submittingpatches-describe-the-fixes-tag.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-submittingpatches-describe-the-fixes-tag.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-submittingpatches-describe-the-fixes-tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jacob Keller <jacob.e.keller@intel.com>
Subject: Documentation/SubmittingPatches: describe the Fixes: tag

Update the SubmittingPatches process to include howto about the new
'Fixed' tag to be used when a patch fixes an issue in a previous commit
(found by git-bisect for example).

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~documentation-submittingpatches-describe-the-fixes-tag Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~documentation-submittingpatches-describe-the-fixes-tag
+++ a/Documentation/SubmittingPatches
@@ -132,6 +132,20 @@ Example:
 	platform_set_drvdata(), but left the variable "dev" unused,
 	delete it.
 
+If your patch fixes a bug in a specific commit, e.g. you found an issue using
+git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
+SHA-1 ID, and the one line summary.
+Example:
+
+	Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")
+
+The following git-config settings can be used to add a pretty format for
+outputting the above style in the git log or git show commands
+
+	[core]
+		abbrev = 12
+	[pretty]
+		fixes = Fixes: %h (\"%s\")
 
 3) Separate your changes.
 
@@ -443,7 +457,7 @@ person it names.  This tag documents tha
 have been included in the discussion
 
 
-14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
+14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
 If this patch fixes a problem reported by somebody else, consider adding a
 Reported-by: tag to credit the reporter for their contribution.  Please
@@ -498,6 +512,12 @@ idea was not posted in a public forum. T
 idea reporters, they will, hopefully, be inspired to help us again in the
 future.
 
+A Fixes: tag indicates that the patch fixes an issue in a previous commit. It
+is used to make it easy to determine where a bug originated, which can help
+review a bug fix. This tag also assists the stable kernel team in determining
+which stable kernel versions should receive your fix. This is the preferred
+method for indicating a bug fixed by the patch. See #2 above for more details.
+
 
 15) The canonical patch format
 
_

Patches currently in -mm which might be from jacob.e.keller@intel.com are

origin.patch
documentation-submittingpatches-describe-the-fixes-tag.patch

