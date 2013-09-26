From: akpm@linux-foundation.org
Subject: + gcov-reuse-kbasename-helper.patch added to -mm tree
Date: Wed, 25 Sep 2013 17:59:21 -0700
Message-ID: <524386e9.2ErHYT0HqSiqro+k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3IZA7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 20:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peter.oberparleiter@de.ibm.com, jg1.han@samsung.com, andriy.shevchenko@linux.intel.com

Subject: + gcov-reuse-kbasename-helper.patch added to -mm tree
To: andriy.shevchenko@linux.intel.com,jg1.han@samsung.com,peter.oberparleiter@de.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 17:59:21 -0700


The patch titled
     Subject: gcov: reuse kbasename helper
has been added to the -mm tree.  Its filename is
     gcov-reuse-kbasename-helper.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-reuse-kbasename-helper.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-reuse-kbasename-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: gcov: reuse kbasename helper

To get name of the file from a pathname let's use kbasename() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/gcov/fs.c~gcov-reuse-kbasename-helper kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~gcov-reuse-kbasename-helper
+++ a/kernel/gcov/fs.c
@@ -365,7 +365,7 @@ static const char *deskew(const char *ba
  */
 static void add_links(struct gcov_node *node, struct dentry *parent)
 {
-	char *basename;
+	const char *basename;
 	char *target;
 	int num;
 	int i;
@@ -381,10 +381,9 @@ static void add_links(struct gcov_node *
 				&gcov_link[i]);
 		if (!target)
 			goto out_err;
-		basename = strrchr(target, '/');
-		if (!basename)
+		basename = kbasename(target);
+		if (basename == target)
 			goto out_err;
-		basename++;
 		node->links[i] = debugfs_create_symlink(deskew(basename),
 							parent,	target);
 		if (!node->links[i])
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

gcov-reuse-kbasename-helper.patch
linux-next.patch

