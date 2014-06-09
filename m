From: akpm@linux-foundation.org
Subject: [merged]
 documentation-submittingpatches-describe-the-fixes-tag.patch removed from
 -mm tree
Date: Mon, 09 Jun 2014 12:33:12 -0700
Message-ID: <53960bf8.rMU3/UIL+9zCTELJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbaFITdN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:33:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, jeffrey.t.kirsher@intel.com, aaron.f.brown@intel.com, jacob.e.keller@intel.com

Subject: [merged] documentation-submittingpatches-describe-the-fixes-tag.patch removed from -mm tree
To: jacob.e.keller@intel.com,aaron.f.brown@intel.com,jeffrey.t.kirsher@intel.com,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:33:12 -0700


The patch titled
     Subject: Documentation/SubmittingPatches: describe the Fixes: tag
has been removed from the -mm tree.  Its filename was
     documentation-submittingpatches-describe-the-fixes-tag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jacob Keller <jacob.e.keller@intel.com>
Subject: Documentation/SubmittingPatches: describe the Fixes: tag

Update the SubmittingPatches process to include howto about the new
'Fixes:' tag to be used when a patch fixes an issue in a previous commit
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
linux-next.patch

