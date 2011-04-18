From: akpm@linux-foundation.org
Subject: [merged] mm-thp-use-conventional-format-for-boolean-attributes.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:03:18 -0700
Message-ID: <201104181759.p3IHxTCN016159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756238Ab1DRSFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, aarcange@redhat.com, hughd@google.com, jweiner@redhat.com, mel@csn.ul.ie, neilb@suse.de, riel@redhat.com, rientjes@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm/thp: use conventional format for boolean attributes
has been removed from the -mm tree.  Its filename was
     mm-thp-use-conventional-format-for-boolean-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/thp: use conventional format for boolean attributes
From: Ben Hutchings <ben@decadent.org.uk>

The conventional format for boolean attributes in sysfs is numeric ("0" or
"1" followed by new-line).  Any boolean attribute can then be read and
written using a generic function.  Using the strings "yes [no]", "[yes]
no" (read), "yes" and "no" (write) will frustrate this.

[akpm@linux-foundation.org: use kstrtoul()]
[akpm@linux-foundation.org: test_bit() doesn't return 1/0, per Neil]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Tested-by: David Rientjes <rientjes@google.com>
Cc: NeilBrown <neilb@suse.de>
Cc: <stable@kernel.org> 	[2.6.38.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-use-conventional-format-for-boolean-attributes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-use-conventional-format-for-boolean-attributes
+++ a/mm/huge_memory.c
@@ -244,24 +244,28 @@ static ssize_t single_flag_show(struct k
 				struct kobj_attribute *attr, char *buf,
 				enum transparent_hugepage_flag flag)
 {
-	if (test_bit(flag, &transparent_hugepage_flags))
-		return sprintf(buf, "[yes] no\n");
-	else
-		return sprintf(buf, "yes [no]\n");
+	return sprintf(buf, "%d\n",
+		       !!test_bit(flag, &transparent_hugepage_flags));
 }
+
 static ssize_t single_flag_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t count,
 				 enum transparent_hugepage_flag flag)
 {
-	if (!memcmp("yes", buf,
-		    min(sizeof("yes")-1, count))) {
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret < 0)
+		return ret;
+	if (value > 1)
+		return -EINVAL;
+
+	if (value)
 		set_bit(flag, &transparent_hugepage_flags);
-	} else if (!memcmp("no", buf,
-			   min(sizeof("no")-1, count))) {
+	else
 		clear_bit(flag, &transparent_hugepage_flags);
-	} else
-		return -EINVAL;
 
 	return count;
 }
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

